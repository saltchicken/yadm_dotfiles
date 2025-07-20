return {
  {
    "saltchicken/llmcoder",
    build = "./scripts/install.sh",
    config = function()
      require("llmcoder").setup({
        auto_trigger = {
          enabled = true,
          delay_ms = 500,
        },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",

    opts = function(_, opts)
      -- opts.diagnostics = {
      --   virtual_lines = true,
      --   underline = true,
      --   update_in_insert = false,
      --   virtual_text = false,
      -- }

      local configs = require("lspconfig.configs")
      if not configs.echo_lsp then
        configs.echo_lsp = {
          default_config = {
            cmd = {
              vim.fn.stdpath("data") .. "/lazy/llmcoder/scripts/launch.sh",
            },
            filetypes = { "text", "markdown", "lua", "python", "javascript", "typescript" },
            root_dir = function(fname)
              return vim.fn.getcwd()
            end,
            settings = {},
            single_file_support = true,
          },
          docs = {
            description = "LLM Coder",
          },
        }
      end

      opts.servers = vim.tbl_extend("force", opts.servers or {}, {
        echo_lsp = {},
      })
    end,
  },
}
