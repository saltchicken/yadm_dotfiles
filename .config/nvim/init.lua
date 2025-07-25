-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.laststatus = 0

vim.keymap.set("n", "<leader>ac", ":Augment chat<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>ac", ":Augment chat<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>at", ":Augment chat-toggle<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>at", ":Augment chat-toggle<CR>", { noremap = true, silent = true })

vim.g.augment_workspace_folders = { "~/.config/tmux/" }

vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", {})
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", {})
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "[B]uffer [D]elete" })

vim.keymap.set("n", "<leader>hp", function()
  Snacks.dashboard()
end, { desc = "Show Dashboard" })

vim.keymap.set("n", "<leader>db", ":DBUIToggle<CR>", { desc = "Open DBUI" })

-- vim.keymap.set({ "n", "v" }, "y", '"+y', { noremap = true })
-- vim.keymap.set("n", "yy", '"+yy', { noremap = true })

-- local echo_lsp_config = {
--   name = "echo_lsp",
--   cmd = { vim.fn.stdpath("data") .. "/lazy/llmcoder/scripts/launch.sh" },
--   filetypes = { "text", "markdown", "lua", "python", "javascript", "typescript" },
--   root_dir = vim.fn.getcwd(),
--   single_file_support = true,
--   on_attach = function(client, bufnr)
--     -- Optional: set keymaps, attach handlers, etc.
--   end,
-- }
--
-- -- Autostart LSP when opening relevant filetypes
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = echo_lsp_config.filetypes,
--   callback = function(args)
--     -- Prevent multiple clients in one buffer
--     local bufnr = args.buf
--     local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
--     for _, client in ipairs(clients) do
--       if client.name == echo_lsp_config.name then
--         return
--       end
--     end
--
--     vim.lsp.start({
--       name = echo_lsp_config.name,
--       cmd = echo_lsp_config.cmd,
--       root_dir = echo_lsp_config.root_dir,
--       filetypes = echo_lsp_config.filetypes,
--       single_file_support = echo_lsp_config.single_file_support,
--       on_attach = echo_lsp_config.on_attach,
--     })
--   end,
-- })
---------- LSP TEST
-- Set updatetime to 3 seconds (3000ms)
-- vim.opt.updatetime = 3000
--
-- -- Create autocommand for cursor hold events
-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--   pattern = "*",
--   callback = function()
--     local clients = vim.lsp.get_clients({ name = "echo_lsp" })
--     if #clients > 0 then
--       local client = clients[1]
--       local bufnr = vim.api.nvim_get_current_buf()
--
--       -- Check if the client is attached to current buffer
--       if vim.lsp.buf_is_attached(bufnr, client.id) then
--         local cursor = vim.api.nvim_win_get_cursor(0)
--         local line = cursor[1] - 1 -- Convert to 0-based indexing
--         local col = cursor[2]
--
--         -- Send a custom request to your LSP server
--         local params = {
--           textDocument = vim.lsp.util.make_text_document_params(bufnr),
--           position = { line = line, character = col },
--           -- Add any custom data you want
--           custom_data = {
--             event = "cursor_hold",
--             timestamp = os.time(),
--           },
--         }
--
--         -- Send custom request (you'll need to handle this in your Python server)
--         client.request("custom/cursorHold", params, function(err, result)
--           if err then
--             print("LSP request error:", vim.inspect(err))
--           else
--             print("LSP response:", vim.inspect(result))
--           end
--         end, bufnr)
--       end
--     end
--   end,
-- })
--
-- -- Optional: Create a command to manually trigger the request
-- vim.api.nvim_create_user_command("EchoLSPCursorHold", function()
--   local clients = vim.lsp.get_clients({ name = "echo_lsp" })
--   if #clients > 0 then
--     vim.cmd("doautocmd CursorHold")
--   else
--     print("Echo LSP server not found")
--   end
-- end, {})

-- local paths_to_check = { "/", "/../" }
-- local is_godot_project = false
-- local godot_project_path = ""
-- local cwd = vim.fn.getcwd()
--
-- -- iterate over paths and check
-- for key, value in pairs(paths_to_check) do
--   if vim.uv.fs_stat(cwd .. value .. "project.godot") then
--     is_godot_project = true
--     godot_project_path = cwd .. value
--     break
--   end
-- end
--
-- -- local pipe_path = godot_project_path .. "server.pipe" -- check if server is already running in godot project path
-- -- local pipe_path = "/tmp/godot_nvim_" .. vim.fn.fnamemodify(godot_project_path, ":t:r") .. ".pipe"
-- local godot_project_folder = vim.fn.fnamemodify(godot_project_path, ":t")
-- local project_name = vim.fn.fnamemodify(godot_project_path:gsub("/$", ""), ":t")
-- -- local temp_godot_project_folder = "/tmp/" .. project_name
-- local temp_godot_project_folder = "/tmp" .. godot_project_path
-- vim.fn.mkdir(temp_godot_project_folder, "p")
-- local pipe_path = temp_godot_project_folder .. "/server.pipe"
--
-- local is_server_running = vim.uv.fs_stat(pipe_path)
-- -- start server, if not already running
-- if is_godot_project and not is_server_running then
--   vim.fn.serverstart(pipe_path)
-- end
--
-- if is_godot_project then
--   vim.lsp.enable("gdscript")
-- end
