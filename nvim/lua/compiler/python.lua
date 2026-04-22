-- ~/.config/nvim/lua/compiler/init.lua

if vim.g.current_compiler ~= nil then
	return
end

vim.g.current_compiler = "python" -- uv

-- local o = vim.go
-- if vim.api.nvim_get_commands({}).CompilerSet.definition:match("^setlocal") ~= nil then
--   o = vim.bo
-- end

local o = vim.bo
o.makeprg = [[python3 %]] -- [[uv run %]]

-- Parse Python tracebacks specifically to Nvim
-- o.errorformat = [[%f:%l: %m]]
o.errorformat = [[%E  File "%f"\, line %l%.%#,%Z%m,%-G%.%#]]
