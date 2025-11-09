-- ~/.config/nvim/lua/Plugins/markdown/markdown-table-mode.lua
-- Run the :Mtm command to toggle markdown table mode.
return {
	"Kicamon/markdown-table-mode.nvim",
	ft = "markdown",
	config = function()
		require("markdown-table-mode").setup({
			filetype = {
				"*.md",
			},
			options = {
				insert = true, -- when typing "|"
				insert_leave = true, -- when leaving insert
				pad_separator_line = false, -- add space in separator line
				alig_style = "default", -- default, left, center, right
			},
		})
	end,
}
