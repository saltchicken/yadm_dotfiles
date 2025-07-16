return {
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      on_highlights = function(hl, c)
        hl.CursorLine = { bg = "#1E2229" }
        hl.Folded = { bg = "#1E2229" }
        hl.StatusLine = { bg = "#1E2229" }
        hl.StatusLineNC = { bg = "#1E2229" }
      end,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "solarized-osaka",
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    config = function(_, opts)
      local lualine = require("lualine")
      lualine.setup(opts)

      -- Create commands
      vim.api.nvim_create_user_command("LualineHide", function()
        lualine.hide()
      end, {})

      vim.api.nvim_create_user_command("LualineShow", function()
        lualine.hide({ unhide = true })
      end, {})

      lualine.hide()
    end,

    keys = {
      { "<leader>mh", "<cmd>LualineHide<cr>", desc = "Hide Lualine" },
      { "<leader>ms", "<cmd>LualineShow<cr>", desc = "Show Lualine" },
    },
  },
  {
    "danilamihailov/beacon.nvim",
    opts = {
      enabled = true, --- (boolean | fun():boolean) check if enabled
      speed = 2, --- integer speed at wich animation goes
      width = 20, --- integer width of the beacon window
      winblend = 95, --- integer starting transparency of beacon window :h winblend
      fps = 60, --- integer how smooth the animation going to be
      min_jump = 10, --- integer what is considered a jump. Number of lines
      cursor_events = { "CursorMoved" }, -- table<string> what events trigger check for cursor moves
      window_events = { "WinEnter", "FocusGained" }, -- table<string> what events trigger cursor highlight
      highlight = { bg = "black", ctermbg = 15 }, -- vim.api.keyset.highlight table passed to vim.api.nvim_set_hl
    },
  },
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  -- {
  --   "Exafunction/windsurf.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "hrsh7th/nvim-cmp",
  --   },
  --   config = function()
  --     require("codeium").setup({
  --       -- Optionally disable cmp source if using virtual text only
  --       -- enable_cmp_source = true,
  --       virtual_text = {
  --         enabled = false,
  --
  --         -- These are the defaults
  --
  --         -- Set to true if you never want completions to be shown automatically.
  --         manual = false,
  --         -- A mapping of filetype to true or false, to enable virtual text.
  --         filetypes = {},
  --         -- Whether to enable virtual text of not for filetypes not specifically listed above.
  --         default_filetype_enabled = true,
  --         -- How long to wait (in ms) before requesting completions after typing stops.
  --         idle_delay = 75,
  --         -- Priority of the virtual text. This usually ensures that the completions appear on top of
  --         -- other plugins that also add virtual text, such as LSP inlay hints, but can be modified if
  --         -- desired.
  --         virtual_text_priority = 65535,
  --         -- Set to false to disable all key bindings for managing completions.
  --         map_keys = true,
  --         -- The key to press when hitting the accept keybinding but no completion is showing.
  --         -- Defaults to \t normally or <c-n> when a popup is showing.
  --         accept_fallback = nil,
  --         -- Key bindings for managing completions in virtual text mode.
  --         key_bindings = {
  --           -- Accept the current completion.
  --           accept = "<Tab>",
  --           -- Accept the next word.
  --           accept_word = false,
  --           -- Accept the next line.
  --           accept_line = false,
  --           -- Clear the virtual text.
  --           clear = false,
  --           -- Cycle to the next completion.
  --           next = "<M-]>",
  --           -- Cycle to the previous completion.
  --           prev = "<M-[>",
  --         },
  --       },
  --     })
  --   end,
  -- },
  {
    {
      "kristijanhusak/vim-dadbod-ui",
      dependencies = {
        { "tpope/vim-dadbod", lazy = true },
        { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
      },
      cmd = {
        "DBUI",
        "DBUIToggle",
        "DBUIAddConnection",
        "DBUIFindBuffer",
      },
      init = function()
        -- Your DBUI configuration
        vim.g.db_ui_use_nerd_fonts = 1
      end,
    },
    { -- optional saghen/blink.cmp completion source
      "saghen/blink.cmp",
      opts = {
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
          per_filetype = {
            sql = { "snippets", "dadbod", "buffer" },
          },
          -- add vim-dadbod-completion to your completion providers
          providers = {
            dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
            codeium = { name = "Codeium", module = "codeium.blink", async = true },
          },
        },
      },
    },
  },
  { "augmentcode/augment.vim" },
  {
    "shahshlok/vim-coach.nvim",
    dependencies = {
      "folke/snacks.nvim",
    },
    config = function()
      require("vim-coach").setup()
    end,
    keys = {
      { "<leader>?", "<cmd>VimCoach<cr>", desc = "Vim Coach" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = "LazyFile",
    dependencies = {
      "mason.nvim",
      { "mason-org/mason-lspconfig.nvim", config = function() end },
    },
    opts = function()
      ---@class PluginLspOpts
      local ret = {
        -- options for vim.diagnostic.config()
        ---@type vim.diagnostic.Opts
        diagnostics = {
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
          -- },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = LazyVim.config.icons.diagnostics.Error,
              [vim.diagnostic.severity.WARN] = LazyVim.config.icons.diagnostics.Warn,
              [vim.diagnostic.severity.HINT] = LazyVim.config.icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = LazyVim.config.icons.diagnostics.Info,
            },
          },
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = true,
          exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
          enabled = false,
        },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overridden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        -- LSP Server Settings
        ---@type lspconfig.options
        servers = {
          lua_ls = {
            -- mason = false, -- set to false if you don't want this server to be installed with mason
            -- Use this to add any additional keymaps
            -- for specific lsp servers
            -- ---@type LazyKeysSpec[]
            -- keys = {},
            settings = {
              Lua = {
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
        setup = {
          -- example to setup with typescript.nvim
          -- tsserver = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
        },
      }
      return ret
    end,
    ---@param opts PluginLspOpts
    config = function(_, opts)
      -- setup autoformat
      LazyVim.format.register(LazyVim.lsp.formatter())

      -- setup keymaps
      LazyVim.lsp.on_attach(function(client, buffer)
        require("lazyvim.plugins.lsp.keymaps").on_attach(client, buffer)
      end)

      LazyVim.lsp.setup()
      LazyVim.lsp.on_dynamic_capability(require("lazyvim.plugins.lsp.keymaps").on_attach)

      -- diagnostics signs
      if vim.fn.has("nvim-0.10.0") == 0 then
        if type(opts.diagnostics.signs) ~= "boolean" then
          for severity, icon in pairs(opts.diagnostics.signs.text) do
            local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
            name = "DiagnosticSign" .. name
            vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
          end
        end
      end

      if vim.fn.has("nvim-0.10") == 1 then
        -- inlay hints
        if opts.inlay_hints.enabled then
          LazyVim.lsp.on_supports_method("textDocument/inlayHint", function(client, buffer)
            if
              vim.api.nvim_buf_is_valid(buffer)
              and vim.bo[buffer].buftype == ""
              and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
            then
              vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
            end
          end)
        end

        -- code lens
        if opts.codelens.enabled and vim.lsp.codelens then
          LazyVim.lsp.on_supports_method("textDocument/codeLens", function(client, buffer)
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
              buffer = buffer,
              callback = vim.lsp.codelens.refresh,
            })
          end)
        end
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
          or function(diagnostic)
            local icons = LazyVim.config.icons.diagnostics
            for d, icon in pairs(icons) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        has_blink and blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then
          return
        end

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
              setup(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      if have_mason then
        mlsp.setup({
          ensure_installed = vim.tbl_deep_extend(
            "force",
            ensure_installed,
            LazyVim.opts("mason-lspconfig.nvim").ensure_installed or {}
          ),
          handlers = { setup },
        })
      end

      if LazyVim.lsp.is_enabled("denols") and LazyVim.lsp.is_enabled("vtsls") then
        local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
        LazyVim.lsp.disable("vtsls", is_deno)
        LazyVim.lsp.disable("denols", function(root_dir, config)
          if not is_deno(root_dir) then
            config.settings.deno.enable = false
          end
          return false
        end)
      end
    end,
  },
  {
    "saltchicken/echo_lsp_server",
    build = "./scripts/install.sh",
    -- config = function()
    --   require("lspconfig").setup()
    -- end,
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
              -- vim.fn.stdpath("config") .. "/echo_lsp_server.py",
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

      return opts
    end,
  },
  { "akinsho/bufferline.nvim", enabled = false },
  { "saltchicken/file-selector.nvim" },
}
