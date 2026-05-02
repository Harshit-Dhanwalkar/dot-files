-- ~/.config/nvim/lua/ftplugin/compiler/python.lua

local fn = vim.fn
local api = vim.api
local cmd = vim.cmd
local opt = vim.opt
local g = vim.g
local o = vim.bo

g.python3_host_prog = "/home/linuxbrew/.linuxbrew/bin/python3.11"

if g.current_compiler ~= nil then
	return
end
vim.g.current_compiler = "python" -- uv

-- local o = vim.go
-- if vim.api.nvim_get_commands({}).CompilerSet.definition:match("^setlocal") ~= nil then
--   o = vim.bo
-- end

o.makeprg = [[python3 %]] -- [[uv run %]]

-- Parse Python tracebacks specifically to Nvim
-- o.errorformat = [[%f:%l: %m]]
o.errorformat = [[%E  File "%f"\, line %l%.%#,%Z%m,%-G%.%#]]
