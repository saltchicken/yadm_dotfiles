return {
  {
    "saltchicken/echo_lsp_server",
    build = "./scripts/install.sh",
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- Register the custom LSP server configuration
      local lspconfig = require("lspconfig")
      local configs = require("lspconfig.configs")

      -- Register echo_lsp as a custom server if not already registered
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

      -- Add to servers list so LazyVim will set it up
      opts.servers = vim.tbl_extend("force", opts.servers or {}, {
        echo_lsp = {},
      })
      opts.diagnostics = {
        virtual_lines = true,
        underline = true,
        update_in_insert = false,
        virtual_text = false,
        -- virtual_text = {
        --   spacing = 4,
        --   source = "if_many",
        --   prefix = "●",
        --   -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
        --   -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
        --   -- prefix = "icons",
      }

      -- Handler for ghost text notifications
      vim.lsp.handlers["ghostText/virtualText"] = function(_, result)
        if not result or not result.uri then
          return
        end
        local bufnr = vim.uri_to_bufnr(result.uri)
        if not vim.api.nvim_buf_is_loaded(bufnr) then
          vim.fn.bufload(bufnr)
        end
        local ns = vim.api.nvim_create_namespace("echo_lsp_ghost_text")
        local line = result.line or 0
        local text = result.text or ""

        -- Clear previous ghost text on this line
        vim.api.nvim_buf_clear_namespace(bufnr, ns, line, line + 1)

        -- Get current cursor position
        local cursor_pos = vim.api.nvim_win_get_cursor(0)
        local cursor_col = cursor_pos[2]

        -- Only show ghost text if we're on the same line as the cursor
        local current_line = cursor_pos[1] - 1 -- Convert to 0-based
        if line == current_line then
          -- Set the ghost text at cursor position
          vim.api.nvim_buf_set_extmark(bufnr, ns, line, cursor_col, {
            virt_text = { { text, "Comment" } },
            virt_text_pos = "overlay", -- This positions it right at the cursor
          })
        end
      end

      return opts
    end,

    -- Set up the keymap when the LSP attaches
    init = function()
      -- Function to trigger ghost text
      local function trigger_ghost_text()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

        -- Find the echo_lsp client
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

        -- Get current position
        local pos = vim.api.nvim_win_get_cursor(0)
        local line = pos[1] - 1 -- Convert to 0-based
        local uri = vim.uri_from_bufnr(bufnr)

        -- Send custom request to trigger ghost text
        echo_client.request("custom/triggerGhostText", {
          textDocument = { uri = uri },
          position = { line = line, character = 0 },
        }, function(err, result)
          if err then
            vim.notify("Error triggering ghost text: " .. tostring(err), vim.log.levels.ERROR)
          end
        end, bufnr)
      end

      -- Set up the keymap
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == "echo_lsp" then
            local bufnr = args.buf
            vim.keymap.set("i", "<C-n>", trigger_ghost_text, {
              buffer = bufnr,
              desc = "Trigger Ghost Text",
            })
          end
        end,
      })
    end,
  },
}
