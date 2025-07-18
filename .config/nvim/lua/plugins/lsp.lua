return {
  {
    "saltchicken/echo_lsp_server",
    build = "./scripts/install.sh",
  },

  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local lspconfig = require("lspconfig")
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

      opts.diagnostics = {
        virtual_lines = true,
        underline = true,
        update_in_insert = false,
        virtual_text = false,
      }

      -- Ghost Text Handler Setup
      local ghost_ns = vim.api.nvim_create_namespace("echo_lsp_ghost_text")
      local ghost_extmark = nil
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

        if line == cursor_line then
          ghost_extmark = vim.api.nvim_buf_set_extmark(bufnr, ghost_ns, line, cursor_col, {
            virt_text = { { text, "Comment" } },
            virt_text_pos = "inline",
          })
          ghost_text = text
          ghost_line = line
          ghost_bufnr = bufnr
        end
      end

      -- Clear ghost text on any insert-related action
      vim.api.nvim_create_autocmd({ "InsertCharPre", "CursorMovedI", "TextChangedI", "InsertLeave" }, {
        callback = function(args)
          if ghost_extmark and ghost_bufnr then
            vim.api.nvim_buf_clear_namespace(ghost_bufnr, ghost_ns, 0, -1)
            ghost_extmark = nil
            ghost_text = ""
            ghost_line = nil
            ghost_bufnr = nil
          end
          local bufnr = args.buf
          local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
          local uri = vim.uri_from_bufnr(bufnr)

          for _, client in ipairs(clients) do
            if client.name == "echo_lsp" then
              client.notify("$/cancelGhostText")
            end
          end
        end,
      })

      -- Shared access from init()
      vim.g._echo_lsp_ghost_state = {
        ns = ghost_ns,
        extmark = function()
          return ghost_extmark
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
          if ghost_extmark and ghost_bufnr then
            vim.api.nvim_buf_clear_namespace(ghost_bufnr, ghost_ns, 0, -1)
          end
          ghost_extmark = nil
          ghost_text = ""
          ghost_line = nil
          ghost_bufnr = nil
        end,
        insert = function()
          if ghost_extmark and ghost_bufnr and ghost_line then
            local line_content = vim.api.nvim_buf_get_lines(ghost_bufnr, ghost_line, ghost_line + 1, false)[1]
            local cursor_col = vim.api.nvim_win_get_cursor(0)[2]
            -- local ghost_first_line = vim.split(ghost_text, "\n", { plain = true })[1]
            -- local new_line = line_content:sub(1, cursor_col) .. ghost_first_line .. line_content:sub(cursor_col + 1)
            local new_line = line_content:sub(1, cursor_col) .. ghost_text .. line_content:sub(cursor_col + 1)
            local lines = vim.split(new_line, "\n", { plain = true })
            vim.api.nvim_buf_set_lines(ghost_bufnr, ghost_line, ghost_line + #lines, false, lines)
            -- vim.api.nvim_buf_set_lines(ghost_bufnr, ghost_line, ghost_line + 1, false, { new_line })
            vim.api.nvim_buf_clear_namespace(ghost_bufnr, ghost_ns, 0, -1)
            ghost_extmark = nil
            ghost_text = ""
            ghost_line = nil
            ghost_bufnr = nil
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

      -- Set keymaps on LSP attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "echo_lsp" then
            local bufnr = args.buf

            -- Trigger ghost text
            vim.keymap.set("i", "<C-n>", trigger_ghost_text, {
              buffer = bufnr,
              desc = "Trigger Ghost Text",
            })

            -- Accept ghost text
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
