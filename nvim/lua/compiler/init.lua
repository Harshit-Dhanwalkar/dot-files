-- ~/.config/nvim/compiler/init.lua

-- For Python
vim.api.nvim_create_autocmd("FileType", {
	pattern = "python",
	callback = function()
		vim.cmd("compiler python")
	end,
})

-- For C
vim.api.nvim_create_autocmd("FileType", {
	pattern = "c",
	callback = function()
		vim.cmd("compiler gcc")
	end,
})
