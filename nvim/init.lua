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
}

for _, a in ipairs(modules) do
	local ok, err = pcall(require, a)
	if not ok then
		error("Error calling " .. a .. err)
	end
end

-- vim ui2
require("vim._core.ui2").enable({
	enable = true,
	msg = {
		target = "cmd",
		pager = { height = 0.5 },
		dialog = { height = 0.5 },
		cmd = { height = 0.5 },
		msg = { height = 0.5, timeout = 4500 },
	},
})

g.python3_host_prog = "/home/linuxbrew/.linuxbrew/bin/python3.11"
cmd("runtime! ftplugin/man.vim")

-- Auto commands
api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
	pattern = "term://*",
	command = "setlocal nonumber norelativenumber signcolumn=no | setfiletype term",
})

api.nvim_create_autocmd("BufEnter", {
	pattern = "term://*",
	command = "startinsert",
})

api.nvim_create_autocmd("VimLeave", {
	command = "set guicursor=a:ver20",
})

-- Load compiler to file specifically to respective language
require("compiler.init")
