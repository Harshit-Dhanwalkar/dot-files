-- ~/.config/nvim/lua/Plugins/carrot.lua
-- (Run :TSInstall markdown and :TSInstall markdown_inline manually)
return {
	"jbyuki/carrot.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	ft = "markdown",
	-- event = { "BufReadPost *.md", "BufNewFile *.md" },
	config = function()
		-- local carrot_ok, carrot = pcall(require, "carrot")
		-- if not carrot_ok then
		-- 	return
		-- end
		-- carrot.setup({
		-- 	timeout = 5000,
		-- 	hl_group = "Normal",
		-- 	border_hl = "Question",
		-- 	result_suffix = " 💡 ",
		-- })
	end,
}
