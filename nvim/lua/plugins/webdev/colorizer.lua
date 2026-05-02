-- ~/.config/nvim/lua/plugins/webdev/colorizer.lua

return {
	-- "norcalli/nvim-colorizer.lua",
	"NvChad/nvim-colorizer.lua",
	event = "BufReadPre",

	config = function()
		require("colorizer").setup({

			-- user_default_options = {
			-- 	RGB = true,
			-- 	RRGGBB = true,
			-- 	names = false,
			-- 	RRGGBBAA = true,
			-- 	rgb_fn = true,
			-- 	hsl_fn = true,
			-- 	css = true,
			-- 	css_fn = true,
			-- 	mode = "background",
			-- },

			"*",
			html = { mode = "foreground" },
			css = { rgb_fn = true },
			lua = { rgb_fn = true },
			markdown = { rgb_fn = true },
		})
	end,
}
