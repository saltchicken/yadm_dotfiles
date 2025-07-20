return {
  {
    "saltchicken/echo_lsp_server",
    build = "./scripts/install.sh",
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.diagnostics = {
        virtual_lines = true,
        underline = true,
        update_in_insert = false,
        virtual_text = false,
      }

      local configs = require("lspconfig.configs")
      if not configs.echo_lsp then
        configs.echo_lsp = {
          default_config = {
            cmd = {
              vim.fn.stdpath("data") .. "/lazy/echo_lsp_server/scripts/launch.sh",
            },
            filetypes = { "text", "markdown", "lua", "python", "javascript", "typescript" },
            root_dir = function(fname)
              return vim.fn.getcwd()
            end,
            settings = {},
            single_file_support = true,
          },
          docs = {
            description = "Simple Echo LSP Server for testing",
          },
        }
      end

      opts.servers = vim.tbl_extend("force", opts.servers or {}, {
        echo_lsp = {},
      })

      -- Ghost Text Handler Setup
      local ghost_ns = vim.api.nvim_create_namespace("echo_lsp_ghost_text")
      local ghost_extmarks = {}
      local ghost_text = ""
      local ghost_line = nil
      local ghost_bufnr = nil

      vim.lsp.handlers["ghostText/virtualText"] = function(_, result)
        if not result or not result.uri then
          return
        end

        local bufnr = vim.uri_to_bufnr(result.uri)
        if not vim.api.nvim_buf_is_loaded(bufnr) then
          vim.fn.bufload(bufnr)
        end

        local line = result.line or 0
        local text = result.text or ""
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local cursor_line = cursor_pos[1] - 1
        local cursor_col = cursor_pos[2]

        vim.api.nvim_buf_clear_namespace(bufnr, ghost_ns, 0, -1)
        ghost_extmarks = {}

        local lines = vim.split(text, "\n", { plain = true })

        if #lines > 0 then
          local ghost_line_text = lines[1]
          local extmark = vim.api.nvim_buf_set_extmark(bufnr, ghost_ns, line, cursor_col, {
            virt_text = { { ghost_line_text, "Comment" } },
            virt_text_pos = "inline",
            hl_mode = "combine",
          })
          ghost_extmarks = { extmark }
        else
          ghost_extmarks = {}
        end

        ghost_text = text
        ghost_line = line
        ghost_bufnr = bufnr
      end

      vim.api.nvim_create_autocmd({ "InsertCharPre", "CursorMovedI", "TextChangedI", "InsertLeave" }, {
        callback = function(args)
          if ghost_bufnr then
            vim.api.nvim_buf_clear_namespace(ghost_bufnr, ghost_ns, 0, -1)
            ghost_extmarks = {}
            ghost_text = ""
            ghost_line = nil
            ghost_bufnr = nil
          end
          local bufnr = args.buf
          local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

          for _, client in ipairs(clients) do
            if client.name == "echo_lsp" then
              client.notify("$/cancelGhostText")
            end
          end
        end,
      })

      vim.g._echo_lsp_ghost_state = {
        ns = ghost_ns,
        extmark = function()
          return #ghost_extmarks > 0 and ghost_extmarks or nil
        end,
        text = function()
          return ghost_text
        end,
        line = function()
          return ghost_line
        end,
        bufnr = function()
          return ghost_bufnr
        end,
        clear = function()
          if ghost_bufnr then
            vim.api.nvim_buf_clear_namespace(ghost_bufnr, ghost_ns, 0, -1)
          end
          ghost_extmarks = {}
          ghost_text = ""
          ghost_line = nil
          ghost_bufnr = nil
        end,
        insert = function()
          if ghost_bufnr and ghost_line then
            local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
            local ghost_lines = vim.split(ghost_text, "\n", { plain = true })

            local orig_line = vim.api.nvim_buf_get_lines(ghost_bufnr, ghost_line, ghost_line + 1, false)[1] or ""
            local prefix = orig_line:sub(1, cursor_col)
            local suffix = orig_line:sub(cursor_col + 1)

            local final_line = prefix .. (ghost_lines[1] or "") .. suffix

            vim.api.nvim_buf_set_lines(ghost_bufnr, ghost_line, ghost_line + 1, false, { final_line })

            -- Save for later use inside vim.schedule
            local saved_ghost_line = ghost_line
            local saved_cursor_col = cursor_col
            local inserted_length = #(ghost_lines[1] or "")

            vim.api.nvim_buf_clear_namespace(ghost_bufnr, ghost_ns, 0, -1)
            ghost_extmarks = {}
            ghost_text = ""
            ghost_line = nil
            ghost_bufnr = nil

            vim.schedule(function()
              vim.api.nvim_win_set_cursor(0, { saved_ghost_line + 1, saved_cursor_col + inserted_length })
            end)
          end
        end,
      }

      return opts
    end,

    init = function()
      local function trigger_ghost_text()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

        local echo_client = nil
        for _, client in ipairs(clients) do
          if client.name == "echo_lsp" then
            echo_client = client
            break
          end
        end

        if not echo_client then
          vim.notify("Echo LSP not active", vim.log.levels.WARN)
          return
        end

        local pos = vim.api.nvim_win_get_cursor(0)
        local line = pos[1] - 1
        local character = pos[2]
        local uri = vim.uri_from_bufnr(bufnr)

        echo_client.request("custom/triggerGhostText", {
          textDocument = { uri = uri },
          position = { line = line, character = character },
        }, function(err, result)
          if err then
            vim.notify("Error triggering ghost text: " .. tostring(err), vim.log.levels.ERROR)
          end
        end, bufnr)
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "echo_lsp" then
            local bufnr = args.buf

            vim.keymap.set("i", "<C-n>", trigger_ghost_text, {
              buffer = bufnr,
              desc = "Trigger Ghost Text",
            })

            vim.keymap.set("i", "<Tab>", function()
              local state = vim.g._echo_lsp_ghost_state
              if state and state.extmark() then
                state.insert()
              else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
              end
            end, { buffer = bufnr, desc = "Accept Ghost Text" })
          end
        end,
      })
    end,
  },
}
