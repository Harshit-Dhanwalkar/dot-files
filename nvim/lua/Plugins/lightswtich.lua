-- ~/.config/nvim/lua/Plugins/lightswtich.lua
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
				-- TODO:
				-- VimTex toggle compilation
			},
		})
	end,
}
