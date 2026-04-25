-- ~/.config/nvim/init.lua

local fn = vim.fn
local api = vim.api
local cmd = vim.cmd
local opt = vim.opt
local g = vim.g

local modules = {
	"options",
	"keymaps",
	"plugins",
	"plugins.keymaps",
	"autocmds",
}

for _, a in ipairs(modules) do
	local ok, err = pcall(require, a)
	if not ok then
		error("Error calling " .. a .. err)
	end
end

-- vim ui2
-- require("vim._core.ui2").enable({
-- 	enable = true,
-- 	msg = {
-- 		target = "cmd",
-- 		pager = { height = 0.5 },
-- 		dialog = { height = 0.5 },
-- 		cmd = { height = 0.5 },
-- 		msg = { height = 0.5, timeout = 4500 },
-- 	},
-- })

-- Disable providers which are not needed
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0

g.python3_host_prog = "/home/linuxbrew/.linuxbrew/bin/python3.11"
cmd("runtime! ftplugin/man.vim")
