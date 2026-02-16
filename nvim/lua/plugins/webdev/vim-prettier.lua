-- ~/.config/nvim/lua/Plugins/webdev/vim-prettier.lua
return {
	{
		"prettier/vim-prettier",
		-- run = "yarn install --frozen-lockfile --production",
		run = "npm install --production",
		ft = {
			"javascript",
			"typescript",
			"css",
			"scss",
			"json",
			"graphql",
			"markdown",
			"vue",
			"yaml",
			"html",
		},
	},
	{
		"MunifTanjim/prettier.nvim",
		dependencies = { "nvim-lspconfig" },
	},
}
