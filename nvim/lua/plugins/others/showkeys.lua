-- ~/.config/nvim/lua/Plugins/others/showkeys.lua
return {
	"nvzone/showkeys",
	cmd = "ShowkeysToggle",
	config = function()
		require("showkeys").setup({
			position = "bottom-right",
			maxkeys = 3,
			show_count = true,
			winopts = {
				focusable = false,
				relative = "editor",
				style = "minimal",
				border = "single",
				height = 1,
				row = 1,
				col = 0,
			},
		})
	end,
}
