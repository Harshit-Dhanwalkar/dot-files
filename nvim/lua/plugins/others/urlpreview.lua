-- ~/.config/nvim/lua/plugins/others/urlpreview.lua

return {
	"wurli/urlpreview.nvim",

	config = function()
		require("urlpreview").setup({
			-- `vim.opt.updatetime = 500`.
			auto_preview = true,
			max_window_width = 100,
			hl_group_title = "@markup.heading",
			hl_group_description = "@markup.quote",
			hl_group_url = "Underlined",
			-- See `:h nvim_open_win()` for more options
			window_border = "none",
			keymap = "<leader>K",
		})
	end,
}
