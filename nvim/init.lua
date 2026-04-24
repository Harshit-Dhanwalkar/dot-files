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
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

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

-- Highlight when yanking
--  See `:help lua-guide-autocommands` and `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		if vim.o.diff then --except diff mode
			return
		end

		local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
		local last_line = vim.api.nvim_buf_line_count(0)

		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end

		pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
	end,
})

-- Wrap, linebreak and spellcheck on markdown and text files
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

-- Load compiler to file specifically to respective language
require("compiler.init")
