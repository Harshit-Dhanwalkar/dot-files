-- ~/.config/nvim/lua/Plugins/appearance/lightswtich.lua
return {
	"markgandolfo/lightswitch.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	config = function()
		require("lightswitch").setup({
			toggles = {
				-- ColorizerToggle
				{
					name = "Colourizer",
					enable_cmd = "ColorizerToggle",
					disable_cmd = "ColorizerToggle",
					state = true, -- Initially enabled
				},
				-- Flash Plugin Toggle
				{
					name = "Flash",
					enable_cmd = "lua require('flash').toggle()",
					disable_cmd = "lua require('flash').toggle()",
					state = true, -- Initially enabled
				},
				-- Twilight Plugin Toggle
				{
					name = "Twilight",
					enable_cmd = "TwilightEnable",
					disable_cmd = "TwilightDisnable",
					state = false, -- Initially enabled
				},
				-- TODO:
				-- VimTex toggle compilation
				{
					name = "VimTeX TOC",
					enable_cmd = "lua if vim.bo.filetype == 'tex' then vim.cmd('VimtexTocToggle') end",
					disable_cmd = "lua if vim.bo.filetype == 'tex' then vim.cmd('VimtexTocToggle') end",
					state = false,
				},
				{
					name = "CSV Viewer",
					enable_cmd = "CsvViewEnable",
					disable_cmd = "CsvViewDisable",
					state = true,
				},
				{
					name = "CSV Mode: Highlight",
					enable_cmd = "CsvViewEnable display_mode=highlight",
					disable_cmd = "CsvViewEnable display_mode=border",
					state = false, -- Replaces delimiters with vertical borders (│)
				},
			},
		})
	end,
}
