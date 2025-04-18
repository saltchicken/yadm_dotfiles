-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.keymap.set("n", "<leader>ac", ":Augment chat<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>ac", ":Augment chat<CR>", { noremap = true, silent = true })

vim.g.augment_workspace_folders = { "~/workspace" }
