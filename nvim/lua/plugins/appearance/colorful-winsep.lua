-- ~/.config/nvim/lua/plugins/appearance/colorful-winsep.luaV

return {
	"nvim-zh/colorful-winsep.nvim",
	event = "WinNew",

	config = function()
		require("colorful-winsep").setup({
			hi = {
				fg = "#fabd2f",
			},
			smooth = true,
			exponential_smoothing = true,
			interval = 30,
			no_exec_files = { "packer", "TelescopePrompt", "mason", "NvimTree", "lazy" },
			symbols = { "─", "│", "╭", "╮", "╰", "╯" },
		})
	end,
}
