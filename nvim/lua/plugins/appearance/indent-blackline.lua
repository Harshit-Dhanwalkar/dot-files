-- ~/.config/nvim/lua/plugins/appearance/indent-blackline.lua

-- Minimal version with dim colors
vim.api.nvim_set_hl(0, "DimIndent", { fg = "#555555" }) -- Dark gray

-- return {
-- 	"lukas-reineke/indent-blankline.nvim",
-- 	main = "ibl",
-- 	config = function()
-- 		require("ibl").setup({
-- 			indent = {
-- 				char = "▏",
-- 				highlight = "DimIndent",
-- 			},
-- 			whitespace = {
-- 				highlight = "Whitespace",
-- 				remove_blankline_trail = false,
-- 			},
-- 			scope = { enabled = false },
-- 		})
-- 	end,
-- }

-- Subtle indents
return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	event = { "BufReadPost", "BufNewFile" },
	opts = {
		indent = {
			char = "▏",
			highlight = "Comment",
		},
		whitespace = {
			highlight = "Whitespace",
			remove_blankline_trail = false,
		},
		scope = {
			enabled = true, -- false
			show_start = true,
			show_end = false,
			highlight = { "Function", "Label" },
		},
		exclude = {
			filetypes = {
				"help",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"lazy",
				"mason",
				"toggleterm",
				"terminal",
				"nofile",
				"prompt",
			},
		},
	},

	config = function(_, opts)
		require("ibl").setup(opts)
	end,
}
