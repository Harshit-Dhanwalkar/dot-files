-- ~/.config/nvim/lua/Plugins/other/image.lua

-- Dependencies : imagemagick libmagickwand-dev

local function choose_backend()
	local term = (vim.env.TERM or ""):lower()
	if term:find("kitty", 1, true) or vim.env.KITTY_WINDOW_ID then
		return "kitty"
	end
	if vim.fn.executable("ueberzug") == 1 or vim.fn.executable("ueberzugpp") == 1 then
		return "ueberzug"
	end
	if vim.fn.has("mac") == 1 and vim.env.TERM_PROGRAM == "WezTerm" then
		return "wezterm"
	end
	return nil
end

local backend = choose_backend()

return {
	"3rd/image.nvim",
	enabled = backend ~= nil,
	ft = {
		"image",
		"png",
		"jpg",
		"jpeg",
		"gif",
		"bmp",
		"svg",
		"webp",
		"markdown",
		"norg",
		"quarto",
		"typst",
		"man",
		"help",
	},

	dependencies = {
		"leafo/magick",
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
	},

	config = function()
		require("image").setup({
			backend = backend or "kitty", -- 'ueberzug', "wezterm"
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
				typst = { enabled = true },
				man = { enabled = true },
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
			-- hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
		})
	end,
	--    priority = 1000,
}
