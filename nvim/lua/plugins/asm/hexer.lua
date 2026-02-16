-- ~/.config/nvim/lua/Plugins/asm/hexer.lua
return {
	"theKnightsOfRohan/hexer.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	config = function()
		local hexer = require("hexer").setup({
			converters = {}, -- This array will be appended onto the hexer default converter list
			popup_opts = {
				enter = true,
				focusable = true,
				anchor = "SE",
				border = {
					style = "none",
				},
				position = {
					row = "100%",
					col = "100%",
				},
				size = {
					width = 420,
					height = 69,
				},
				buf_options = {
					buftype = "nofile",
					buflisted = false,
					modifiable = false,
				},
			},
			table_opts = {
				bufnr = 0,
				ns_id = "HexerWindow",
			},
		})
	end,
}
