-- ~/.config/nvim/lua/plugins/webdev/nvim-ts-autotag.lua

return {
	"windwp/nvim-ts-autotag",

	config = function()
		require("nvim-ts-autotag").setup({
			opts = {
				enable_close = true, -- Auto-close tags
				enable_rename = true, -- Auto-rename pairs
				enable_close_on_slash = false, -- Disable auto-close on trailing `</`
			},
			per_filetype = {
				["html"] = {
					enable_close = true, -- Disable auto-closing for HTML
				},
				["typescriptreact"] = {
					enable_close = true, -- Explicitly enable auto-closing
				},
			},
		})
	end,
}
