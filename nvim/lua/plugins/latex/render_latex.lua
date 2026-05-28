-- ~/.config/nvim/lua/plugins/latex/render_latex.lua

return {
	"techwizrd/render-latex.nvim",
	enabled = true,
	ft = "markdown",
	cmd = { "RenderLatex" },

	config = function()
		require("render_latex").setup({
			render = {
				preset = "match_text", -- "compact" or "presentation"
				inline = "conceal", -- "content", "highlight", or false
				inline_symbols = true,
				hide_on_cmdline = false,
			},
		})
	end,
}
