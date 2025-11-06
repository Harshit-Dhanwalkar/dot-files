-- ~/.config/nvim/lua/Plugins/mini.lua
local function is_whitespace(line)
	return vim.fn.match(line, [[^\s*$]]) ~= -1
end

local function all(tbl, check)
	for _, entry in ipairs(tbl) do
		if not check(entry) then
			return false
		end
	end
	return true
end

return {
	"AckslD/nvim-neoclip.lua",
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
		-- {'ibhagwan/fzf-lua'},
	},
	config = function()
		require("neoclip").setup({
			-- telescope = require("telescope.themes").get_dropdown({
			-- 	layout_strategy = "horizontal",
			-- 	layout_config = {
			-- 		horizontal = {
			-- 			width = 150,
			-- 			height = 20,
			-- 			preview_width = 25,
			-- 		},
			-- 	},
			-- }),
			history = 1000,
			enable_persistent_history = false,
			length_limit = 1048576,
			continuous_sync = false,
			-- db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3", --Specify database path
			filter = function(data)
				return not all(data.event.regcontents, is_whitespace)
			end,
			preview = true,
			content_spec_column = true,
			prompt = nil,
			default_register = '"',
			default_register_macros = "q",
			enable_macro_history = true,
			disable_keycodes_parsing = false,
			dedent_picker_display = false,
			initial_mode = "insert",
			on_select = {
				move_to_front = false,
				close_telescope = true,
			},
			on_paste = {
				set_reg = false,
				move_to_front = false,
				close_telescope = true,
			},
			on_replay = {
				set_reg = false,
				move_to_front = false,
				close_telescope = true,
			},
			on_custom_action = {
				close_telescope = true,
			},
			keys = {
				telescope = {
					i = {
						select = "<cr>",
						paste = "<c-p>",
						paste_behind = "<c-k>",
						replay = "<c-q>", -- replay a macro
						delete = "<c-d>", -- delete an entry
						edit = "<c-e>", -- edit an entry
						custom = {},
					},
					n = {
						select = "<cr>",
						paste = "p",
						-- paste = { 'p', '<c-p>' },
						paste_behind = "P",
						replay = "q",
						delete = "d",
						edit = "e",
						custom = {},
					},
				},
				-- fzf = {
				-- 	select = "default",
				-- 	paste = "ctrl-p",
				-- 	paste_behind = "ctrl-k",
				-- 	custom = {},
				-- },
			},
		})
	end,
}
