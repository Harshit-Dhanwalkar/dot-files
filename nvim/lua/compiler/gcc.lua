-- ~/.config/nvim/lua/ftplugin/compiler/gcc.lua

local fn = vim.fn
local api = vim.api
local cmd = vim.cmd
local opt = vim.opt
local g = vim.g
local o = vim.bo

if g.current_compiler ~= nil then
	return
end
g.current_compiler = "gcc"

-- compiles current file and creates an executive named 'main'
-- o.makeprg = [[gcc % -o %<]]
-- compiles current file and run an executive named 'main'
o.makeprg = [[gcc % -o %< && ./%<]]

-- Parse GCC error messages specifically to Nvim
o.errorformat = [[%f:%l:%c: %t%*[^:]: %m,%f:%l: %t%*[^:]: %m]]
