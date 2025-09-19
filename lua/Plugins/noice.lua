-- ~/.config/nvim/lua/Plugins/noice.lua
return {
	"folke/noice.nvim",
	event = "VeryLazy",
	config = function()
		require("noice").setup({
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			presets = {
				bottom_search = false, -- use a classic bottom cmdline for search
				command_palette = false, -- position cmdline and popupmenu together
				long_message_to_split = true, -- long messages sent to split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
			cmdline = {
				enabled = true,
				view = "cmdline_popup",
				opts = {},
				format = {
					cmdline = { pattern = "^:", icon = "", lang = "vim" },
					search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
					search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
					filter = { pattern = "^:%s*!", icon = "", lang = "bash" },
					lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
					python = {
						pattern = { "^:%s*python%s+", "^:%s*python%s*=%s*", "^:%s*=%s*" },
						icon = "",
						lang = "python",
					},
					replace = {
						pattern = "^:%s*%d*%s*,*%d*%s*s[ubstitute]*%s*/",
						"^:%s/",
						"^:%%?s/",
						icon = "󰛔",
						kind = "substitute",
						lang = "regex",
					},
					global = { pattern = "^:g/", icon = "", lang = "regex" },
					help = { pattern = "^:%s*he?l?p?%s+", icon = "󰞋" },
					input = { view = "cmdline_input", icon = "󰥻" },
				},
			},
			views = {
				cmdline_popup = {
					position = {
						row = "70%",
						col = "50%",
					},
					size = {
						width = 30,
						height = "auto",
					},
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
					},
				},
			},
			messages = {
				enabled = false,
				view = "mini", -- Use 'mini' view instead of 'notify'
				view_error = "split", -- Handle errors in a split
				view_warn = "mini", -- Use mini for warnings
				view_history = "messages",
				view_search = "virtualtext",
			},
			popupmenu = {
				enabled = false,
				backend = "nui",
				kind_icons = {},
			},
			-- notify = {
			-- 	enabled = true,
			-- 	view = "notify",
			-- },
			-- lsp = {
			--   progress = {
			--   enabled = true,
			--   format = 'lsp_progress',
			--   format_done = 'lsp_progress_done',
			--   throttle = 1000 / 30,
			--   view = 'mini',
			-- },
			hover = {
				enabled = true,
				silent = false,
				opts = {},
			},
			signature = {
				enabled = true,
				auto_open = {
					enabled = true,
					trigger = true,
					luasnip = true,
					throttle = 50,
				},
				opts = {},
			},
			documentation = {
				view = "hover",
				opts = {
					lang = "markdown",
					replace = true,
					render = "plain",
					format = { "{message}" },
					win_options = { concealcursor = "n", conceallevel = 3 },
				},
			},
			-- markdown = {
			--   hover = {
			--     ['|(%S-)|'] = vim.cmd.help,
			--     ['%[.-%]%((%S-)%)'] = require('noice.util').open,
			--   },
			--   highlights = {
			--     ['|%S-|'] = '@text.reference',
			--     ['@%S+'] = '@parameter',
			--     ['^%s*(Parameters:)'] = '@text.title',
			--     ['^%s*(Return:)'] = '@text.title',
			--     ['^%s*(See also:)'] = '@text.title',
			--     ['{%S-}'] = '@parameter',
			--   },
			--   health = {
			--     checker = true,
			--   },
			--   throttle = 1000 / 30,
			-- },
			-- message = {
			--   enabled = true,
			--   view = 'notify',
			--   opts = {},
			-- },
			dependencies = {
				"MunifTanjim/nui.nvim",
				-- "rcarriga/nvim-notify",
			},
		})
	end,
}
