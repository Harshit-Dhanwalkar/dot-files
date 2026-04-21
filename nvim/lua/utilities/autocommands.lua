-- ~/.config/nvim/lua/utilities/autocommands.lua

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("custom-filetype", { clear = true }),
	pattern = {
		"bash",
		"c",
		"cpp",
		"html",
		"lua",
		"luadoc",
		"markdown",
		"markdown_inline",
		"python",
		"vim",
		"vimdoc",
	},
	callback = function()
		vim.treesitter.start()
		local new_ft = vim.fn.expand("<amatch>")
		if not vim.tbl_contains({
			"markdown",
			"markdown_inline",
		}, new_ft) then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
		end

		if not vim.tbl_contains({
			"vimdoc",
		}, new_ft) then
			-- For some reason these often get turned off, e.g. when switching
			-- to/from the built-in terminal
			vim.wo.number = true
			vim.wo.relativenumber = true
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("custom-line-numbers", { clear = true }),
	callback = function()
		local use_nums = vim.bo.buftype == ""
		vim.wo.number = use_nums
		vim.wo.relativenumber = use_nums
	end,
})
