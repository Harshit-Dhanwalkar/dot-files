-- ~/.config/nvim/lua/plugins/webdev/colorizer.lua
return {
	-- "norcalli/nvim-colorizer.lua",
	"NvChad/nvim-colorizer.lua",
	config = function()
		require("colorizer").setup({
			"*",
			html = { mode = "foreground" },
			css = { rgb_fn = true },
			lua = { rgb_fn = true },
			markdown = { rgb_fn = true },
		})
	end,
}
