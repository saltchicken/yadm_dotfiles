-- vim.keymap.set("n", "<leader>ac", ":Augment chat<CR>", { noremap = true, silent = true })
-- vim.keymap.set("v", "<leader>ac", ":Augment chat<CR>", { noremap = true, silent = true })
--
-- vim.keymap.set("n", "<leader>at", ":Augment chat-toggle<CR>", { noremap = true, silent = true })
-- vim.keymap.set("v", "<leader>at", ":Augment chat-toggle<CR>", { noremap = true, silent = true })
--
-- vim.keymap.set("i", "<C-f>", "<Nop>", { noremap = true, silent = true })
--

vim.keymap.set("i", "<C-f>", require("neocodeium").accept)
vim.keymap.set("i", "<C-l>", require("neocodeium").accept_line)
vim.keymap.set("i", "<C-Right>", require("neocodeium").accept_word)
vim.keymap.set("i", "<C-Left>", require("neocodeium").clear)
vim.keymap.set("i", "<C-Down>", function()
  require("neocodeium").cycle_or_complete()
end)
vim.keymap.set("i", "<C-Up>", function()
  require("neocodeium").cycle_or_complete(-1)
end)

vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", {})
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", {})
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "[B]uffer [D]elete" })

vim.keymap.set("n", "<leader>hp", function()
  Snacks.dashboard()
end, { desc = "Show Dashboard" })

-- vim.keymap.set("n", "<leader>db", ":DBUIToggle<CR>", { desc = "Open DBUI" })
