return {
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
  --   "ojroques/nvim-osc52",
  --   config = function()
  --     require("osc52").setup()
  --
  --     local function copy()
  --       if vim.v.event.operator == "y" and vim.v.event.regname == "+" then
  --         require("osc52").copy_register("+")
  --       end
  --     end
  --
  --     vim.api.nvim_create_autocmd("TextYankPost", {
  --       callback = copy,
  --     })
  --   end,
  -- },
}
