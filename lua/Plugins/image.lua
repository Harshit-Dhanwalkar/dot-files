return {
	"3rd/image.nvim",
	dependencies = {
		"leafo/magick",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("image").setup({
			-- backend = 'ueberzug',
			backend = "kitty",
			kitty_method = "normal",
			integrations = {
				markdown = {
					enabled = true,
					clear_in_insert_mode = true,
					download_remote_images = true,
					only_render_image_at_cursor = true,
					filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto)
				},
				neorg = {
					enabled = true,
					clear_in_insert_mode = false,
					download_remote_images = true,
					only_render_image_at_cursor = false,
					filetypes = { "norg" },
				},
				html = {
					enabled = false,
				},
				css = {
					enabled = false,
				},
			},
			max_width = nil,
			max_height = nil,
			-- max_width_window_percentage = nil,
			-- max_height_window_percentage = 50,
			max_height_window_percentage = math.huge,
			max_width_window_percentage = math.huge,
			-- toggles images when windows are overlapped
			window_overlap_clear_enabled = false,
			window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
			-- auto show/hide images when the editor gains/looses focus
			editor_only_render_when_focused = false,
			-- render image files as images when opened
			hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
		})
	end,
	--    priority = 1000,
}
