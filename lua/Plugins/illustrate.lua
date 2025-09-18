-- ~/.config/nvim/lua/Plugins/illustrate.lua
return {
	"rpapallas/illustrate.nvim",
	dependencies = {
		"rcarriga/nvim-notify", -- Notification plugin for Neovim
		"nvim-lua/plenary.nvim", -- Lua functions library, required by many plugins
		"nvim-telescope/telescope.nvim", -- Fuzzy finder plugin
	},
	keys = function()
		local illustrate = require("illustrate") -- Load illustrate module
		local illustrate_finder = require("illustrate.finder") -- Load illustrate finder module
		return {
			{
				"<leader>is", -- create and open a new SVG file
				function()
					illustrate.create_and_open_svg()
				end,
				desc = "Create and open a new SVG file with provided name.",
			},
			{
				"<leader>ia", -- create and open a new Adobe Illustrator file
				function()
					illustrate.create_and_open_ai()
				end,
				desc = "Create and open a new Adobe Illustrator file with provided name.",
			},
			{
				"<leader>io", -- open a file under the cursor
				function()
					illustrate.open_under_cursor()
				end,
				desc = "Open file under cursor (or file within environment under cursor).",
			},
			{
				"<leader>if", -- search and open illustrations using Telescope
				function()
					illustrate_finder.search_and_open()
				end,
				desc = "Use telescope to search and open illustrations in default app.",
			},
			{
				"<leader>ic", -- search, copy, and open illustrations using Telescope
				function()
					illustrate_finder.search_create_copy_and_open()
				end,
				desc = "Use telescope to search existing file, copy it with new name, and open it in default app.",
			},
			-- {
			--   '<leader>ii', -- Illustration actions
			--   {
			--     { 's', illustrate.create_and_open_svg, desc = 'Create and open a new SVG file' },
			--     { 'a', illustrate.create_and_open_ai, desc = 'Create and open a new AI file' },
			--     { 'o', illustrate.open_under_cursor, desc = 'Open file under cursor' },
			--     { 'f', illustrate_finder.search_and_open, desc = 'Search and open illustrations' },
			--     { 'c', illustrate_finder.search_create_copy_and_open, desc = 'Search, copy, and open illustrations' },
			--   },
			-- },
		}
	end,
	opts = {
		-- Optional configuration options for the illustrate plugin
	},
	-- Custom command to convert SVG to PDF
	--vim.api.nvim_create_user_command('ConvertSvgToPdf', function()
	--    local svg_file = vim.fn.expand '%:p:r' .. '.svg'
	--    local pdf_file = vim.fn.expand '%:p:r' .. '.pdf'
	--    local cmd = 'inkscape ' .. svg_file .. ' --export-type=pdf --export-filename=' .. pdf_file
	--    os.execute(cmd)
	--    print('Converted ' .. svg_file .. ' to ' .. pdf_file)
	--  end, { nargs = 0 })
}
