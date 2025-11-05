-- ~/.config/nvim/lua/Plugins/webdev/colorizer.lua
return {
	"norcalli/nvim-colorizer.lua",
	config = function()
		require("colorizer").setup({
			"*",
			"html",
			css = { rgb_fn = true },
		})
	end,
}
