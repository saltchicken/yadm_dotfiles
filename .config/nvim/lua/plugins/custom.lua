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
  {
    "Exafunction/windsurf.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("codeium").setup({
        -- Optionally disable cmp source if using virtual text only
        enable_cmp_source = false,
        virtual_text = {
          enabled = true,

          -- These are the defaults

          -- Set to true if you never want completions to be shown automatically.
          manual = false,
          -- A mapping of filetype to true or false, to enable virtual text.
          filetypes = {},
          -- Whether to enable virtual text of not for filetypes not specifically listed above.
          default_filetype_enabled = true,
          -- How long to wait (in ms) before requesting completions after typing stops.
          idle_delay = 75,
          -- Priority of the virtual text. This usually ensures that the completions appear on top of
          -- other plugins that also add virtual text, such as LSP inlay hints, but can be modified if
          -- desired.
          virtual_text_priority = 65535,
          -- Set to false to disable all key bindings for managing completions.
          map_keys = true,
          -- The key to press when hitting the accept keybinding but no completion is showing.
          -- Defaults to \t normally or <c-n> when a popup is showing.
          accept_fallback = nil,
          -- Key bindings for managing completions in virtual text mode.
          key_bindings = {
            -- Accept the current completion.
            accept = "<Tab>",
            -- Accept the next word.
            accept_word = false,
            -- Accept the next line.
            accept_line = false,
            -- Clear the virtual text.
            clear = false,
            -- Cycle to the next completion.
            next = "<M-]>",
            -- Cycle to the previous completion.
            prev = "<M-[>",
          },
        },
      })
    end,
  },
  { "augmentcode/augment.vim" },
  -- { "vuciv/golf" },
}
