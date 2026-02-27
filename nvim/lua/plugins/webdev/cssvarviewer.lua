-- ~/.config/nvim/lua/plugins/webdev/cssvarviewer.lua
return {
	"farias-hecdin/CSSVarViewer",
	ft = "css",
	config = function()
		require("CSSVarViewer").setup({
			parent_search_limit = 5, -- number of levels to search upwards
			filename_to_track = "style",
			disable_keymaps = false,
		})
	end,
}
