-- ~/.config/nvim/lua/plugins/utils/backout.lua
return {
	"AgusDOLARD/backout.nvim",
	event = { "InsertEnter", "CmdlineEnter" },
	opts = {
		chars = "(){}[]`'\"<>",
		multiLine = true,
	},
	keys = {
		{
			"<C-,>",
			function()
				require("backout").back()
			end,
			mode = { "i", "c" },
			desc = "Back out of pair",
		},
		{
			"<C-.>",
			function()
				require("backout").out()
			end,
			mode = { "i", "c" },
			desc = "Go out of pair",
		},
		config = function(_, opts)
			require("backout").setup(opts)
		end,
	},
}
