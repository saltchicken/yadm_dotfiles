return {
  {
    "saltchicken/solarized-osaka.nvim",
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
    config = function()
      vim.cmd.colorscheme("solarized-osaka")
    end,
  },
}
