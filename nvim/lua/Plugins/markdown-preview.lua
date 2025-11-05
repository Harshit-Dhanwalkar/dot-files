-- ~/.config/nvim/lua/Plugins/markdown-preview.lua
return {
	-- install without yarn or npm
	-- FAILs
	-- {
	--     "iamcco/markdown-preview.nvim",
	--     cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	--     ft = { "markdown" },
	--     build = function() vim.fn["mkdp#util#install"]() end,
	-- }

	-- install with yarn or npm
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && npm install",
		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	},
}
