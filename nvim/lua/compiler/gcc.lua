-- ~/.config/nvim/compiler/gcc.lua

if vim.g.current_compiler ~= nil then
	return
end
vim.g.current_compiler = "gcc"

local o = vim.bo
-- compiles current file and creates an executive named 'main'
-- o.makeprg = [[gcc % -o %<]]
-- compiles current file and run an executive named 'main'
o.makeprg = [[gcc % -o %< && ./%<]]

-- Parse GCC error messages specifically to Nvim
o.errorformat = [[%f:%l:%c: %t%*[^:]: %m,%f:%l: %t%*[^:]: %m]]
