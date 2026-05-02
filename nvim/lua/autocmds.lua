-- ~/.config/nvim/lua/autocmds.lua

local fn = vim.fn
local api = vim.api
local cmd = vim.cmd
local opt = vim.opt
local g = vim.g
local opt_local = vim.opt_local

local augroup = api.nvim_create_augroup("user_cmds", { clear = true })

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
api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Return to last cursor position
api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	desc = "Restore last cursor position",
	callback = function()
		-- if vim.o.diff:get() then --except diff mode (returns boolean)
		if opt.diff:get() then --except diff mode (return table)
			return
		end

		local last_pos = api.nvim_buf_get_mark(0, '"') -- {line, col}
		local last_line = api.nvim_buf_line_count(0)

		local row = last_pos[1]
		if row < 1 or row > last_line then
			return
		end

		pcall(api.nvim_win_set_cursor, 0, last_pos)
	end,
})

-- Wrap, linebreak and spellcheck on markdown and text files
api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		opt_local.wrap = true
		opt_local.linebreak = true
		opt_local.spell = true
	end,
})

-- For Python
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python3",
	callback = function()
		vim.cmd("compiler python3")
	end,
})

-- For C
vim.api.nvim_create_autocmd("FileType", {
	pattern = "c",
	callback = function()
		vim.cmd("compiler gcc")
	end,
})

-- vim.api.nvim_create_autocmd("FileType", {
-- 	group = vim.api.nvim_create_augroup("custom-filetype", { clear = true }),
-- 	pattern = {
-- 		"bash",
-- 		"c",
-- 		"cpp",
-- 		"html",
-- 		"lua",
-- 		"luadoc",
-- 		"markdown",
-- 		"markdown_inline",
-- 		"python",
-- 		"vim",
-- 		"vimdoc",
-- 	},
-- 	callback = function()
-- 		vim.treesitter.start()
-- 		local new_ft = vim.fn.expand("<amatch>")
-- 		if not vim.tbl_contains({
-- 			"markdown",
-- 			"markdown_inline",
-- 		}, new_ft) then
-- 			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
-- 		end
--
-- 		if not vim.tbl_contains({
-- 			"vimdoc",
-- 		}, new_ft) then
-- 			-- For some reason these often get turned off, e.g. when switching
-- 			-- to/from the built-in terminal
-- 			vim.wo.number = true
-- 			vim.wo.relativenumber = true
-- 		end
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd("FileType", {
-- 	group = vim.api.nvim_create_augroup("custom-line-numbers", { clear = true }),
-- 	callback = function()
-- 		local use_nums = vim.bo.buftype == ""
-- 		vim.wo.number = use_nums
-- 		vim.wo.relativenumber = use_nums
-- 	end,
-- })
