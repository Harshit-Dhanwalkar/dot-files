-- ~/.config/nvim/lua/Plugins/ai/copilot-cmp.lua
return {
	"zbirenbaum/copilot-cmp",
	dependencies = {
		"zbirenbaum/copilot.lua",
	},
	config = function()
		require("copilot_cmp").setup({
			formatters = {
				insert_text = require("copilot_cmp.format").remove_existing,
			},
		})
	end,
}
