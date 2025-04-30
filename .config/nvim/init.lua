-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.opt.laststatus = 0

vim.keymap.set("n", "<leader>ac", ":Augment chat<CR>", { noremap = true, silent = true })
vim.keymap.set("v", "<leader>ac", ":Augment chat<CR>", { noremap = true, silent = true })

-- vim.g.augment_workspace_folders = { "~/workspace" }
vim.g.augment_workspace_folders = { "~/.local/share/godot/projects/" }

local paths_to_check = { "/", "/../" }
local is_godot_project = false
local godot_project_path = ""
local cwd = vim.fn.getcwd()

-- iterate over paths and check
for key, value in pairs(paths_to_check) do
  if vim.uv.fs_stat(cwd .. value .. "project.godot") then
    is_godot_project = true
    godot_project_path = cwd .. value
    break
  end
end

-- local pipe_path = godot_project_path .. "server.pipe" -- check if server is already running in godot project path
-- local pipe_path = "/tmp/godot_nvim_" .. vim.fn.fnamemodify(godot_project_path, ":t:r") .. ".pipe"
local godot_project_folder = vim.fn.fnamemodify(godot_project_path, ":t")
local project_name = vim.fn.fnamemodify(godot_project_path:gsub("/$", ""), ":t")
-- local temp_godot_project_folder = "/tmp/" .. project_name
local temp_godot_project_folder = "/tmp" .. godot_project_path
vim.fn.mkdir(temp_godot_project_folder, "p")
local pipe_path = temp_godot_project_folder .. "/server.pipe"

local is_server_running = vim.uv.fs_stat(pipe_path)
-- start server, if not already running
if is_godot_project and not is_server_running then
  vim.fn.serverstart(pipe_path)
end

if is_godot_project then
  vim.lsp.enable("gdscript")
end
