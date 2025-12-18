-- ~/.config/nvim/lua/Plugins/mini.lua
return {
	{
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()
			-- local statusline = require("mini.statusline")
			-- statusline.setup({ use_icons = vim.g.have_nerd_font })
			-- ---@diagnostic disable-next-line: duplicate-set-field
			-- statusline.section_location = function()
			-- 	return "%2l:%-2v"
			-- end
		end,
	},
	{
		"echasnovski/mini.comment",
		version = false,
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			-- disable the autocommand from ts-context-commentstring
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})

			require("mini.comment").setup({
				-- tsx, jsx, html , svelte comment support
				options = {
					custom_commentstring = function()
						return require("ts_context_commentstring.internal").calculate_commentstring({
							key = "commentstring",
						}) or vim.bo.commentstring
					end,
				},
			})
		end,
	},
	{
		"echasnovski/mini.trailspace",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local miniTrailspace = require("mini.trailspace")
			miniTrailspace.setup({
				only_in_normal_buffers = true,
			})
			vim.keymap.set("n", "<leader>cw", function()
				miniTrailspace.trim()
			end, { desc = "Erase Whitespace" })
			-- Ensure highlight never reappears by removing it on CursorMoved
			vim.api.nvim_create_autocmd("CursorMoved", {
				pattern = "*",
				callback = function()
					require("mini.trailspace").unhighlight()
				end,
			})
		end,
	},
	{
		-- 'nvim-mini/mini.nvim',
		"echasnovski/mini.nvim",
		config = function()
			require("mini.jump2d").setup({
				view = {
					n_steps_ahead = 3,
				},
				allowed_lines = {
					blank = false,
				},
			})

			-- The function itself, copy only the below part if you already have mini.jump2d configured
			local custom_2d_jump = function(opts)
				vim.opt.scrolloff = 0
				local count = opts.repeatable and vim.v.count1 or 1
				if opts.preaction then
					vim.cmd("normal! " .. count .. opts.preaction)
				end
				if opts.mark then
					vim.cmd("normal! m" .. opts.mark)
				end
				local bufnr = vim.api.nvim_get_current_buf()
				MiniJump2d.start({
					labels = opts.homerow and "asdfghjkl" or "alksdjfgheivbcmnopqrtuwxyz",
					spotter = opts.spotter,
					hooks = {
						after_jump = function()
							if opts.end_in_insert then
								vim.api.nvim_feedkeys(count .. opts.action, "n", true)
							else
								if opts.norepeat_action then
									vim.cmd("normal! " .. opts.norepeat_action)
								end
								vim.cmd("normal! " .. count .. opts.action)
								if opts.action2 then
									vim.cmd("normal! " .. count .. opts.action2)
								end
								if opts.mark then
									local cur_bufnr = vim.api.nvim_get_current_buf()
									if cur_bufnr ~= bufnr then
										local keys = vim.api.nvim_replace_termcodes("<C-w><C-p>", true, false, true)
										vim.api.nvim_feedkeys(keys, "n", true)
									else
										vim.cmd("normal! `" .. opts.mark)
										if opts.afteraction then
											vim.cmd("normal! " .. opts.afteraction)
										end
									end
								end
							end
							vim.opt.scrolloff = 10
						end,
					},
				})
			end

			-- Copying a Word (yiW) without moving your cursor there
			vim.keymap.set("n", ";y", function()
				custom_2d_jump({
					mark = "w",
					spotter = MiniJump2d.gen_spotter.pattern("[^%s][^%s]+"),
					action = "yiW",
				})
			end)

			-- Yank an entire line (see how counts may come in handy?)
			vim.keymap.set("n", "yl", function()
				custom_2d_jump({
					mark = "l",
					repeatable = true,
					homerow = true,
					spotter = MiniJump2d.builtin_opts.line_start.spotter,
					action = "yy",
				})
			end)

			-- Yank a paragraph
			vim.keymap.set("n", "yp", function()
				custom_2d_jump({
					mark = "p",
					repeatable = true,
					homerow = true,
					spotter = MiniJump2d.builtin_opts.line_start.spotter,
					action = "yip",
				})
			end)

			-- Yank a word (yiw)
			vim.keymap.set("n", ";w", function()
				custom_2d_jump({
					mark = "w",
					spotter = MiniJump2d.gen_spotter.pattern("[^%s%p]+"),
					action = "yiw",
				})
			end)

			-- Below is just a bunch of functions for yanking contents of parenthesis/brackets/quotes
			vim.keymap.set("n", ";'", function()
				custom_2d_jump({
					mark = "q",
					spotter = MiniJump2d.gen_spotter.pattern("'.[^']"),
					action = "yi'",
				})
			end)

			vim.keymap.set("n", ';"', function()
				custom_2d_jump({
					mark = "q",
					spotter = MiniJump2d.gen_spotter.pattern('".[^"]'),
					action = 'yi"',
				})
			end)

			vim.keymap.set("n", ";(", function()
				custom_2d_jump({
					mark = "b",
					spotter = MiniJump2d.gen_spotter.union(
						MiniJump2d.gen_spotter.pattern("%("),
						MiniJump2d.gen_spotter.pattern("%)")
					),
					action = "yi(",
				})
			end)

			vim.keymap.set("n", ";{", function()
				custom_2d_jump({
					mark = "c",
					spotter = MiniJump2d.gen_spotter.union(
						MiniJump2d.gen_spotter.pattern("%{"),
						MiniJump2d.gen_spotter.pattern("%}")
					),
					action = "yi{",
				})
			end)

			vim.keymap.set("n", ";[", function()
				custom_2d_jump({
					mark = "b",
					spotter = MiniJump2d.gen_spotter.union(
						MiniJump2d.gen_spotter.pattern("%["),
						MiniJump2d.gen_spotter.pattern("%]")
					),
					action = "yi[",
				})
			end)

			-- Keymaps below are for changing stuff
			-- Jump and do ciW on a word
			vim.keymap.set("n", ";c", function()
				custom_2d_jump({
					spotter = MiniJump2d.gen_spotter.pattern("[^%s][^%s]+"),
					action = "ciW",
					end_in_insert = true,
				})
			end)

			-- Delete a paragraph
			vim.keymap.set("n", "dp", function()
				custom_2d_jump({
					mark = "d",
					repeatable = true,
					homerow = true,
					spotter = MiniJump2d.builtin_opts.line_start.spotter,
					action = "dip",
				})
			end)

			-- This here is for changing the line you currently hover at, with a line that you jump to. And then return to where you were in the first place
			vim.keymap.set("n", "rl", function()
				custom_2d_jump({
					mark = "l",
					repeatable = true,
					homerow = true,
					spotter = MiniJump2d.builtin_opts.line_start.spotter,
					preaction = "dd",
					norepeat_action = "P",
					action = "j",
					action2 = "dd",
					afteraction = "P",
				})
			end)
		end,
	},
	{
		"echasnovski/mini.files",
		config = function()
			local MiniFiles = require("mini.files")
			MiniFiles.setup({
				mappings = {
					go_in = "<CR>", -- Map both Enter and L to enter directories or open files
					go_in_plus = "L",
					go_out = "-",
					go_out_plus = "H",
				},
			})
			vim.keymap.set("n", "<leader>ee", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" }) -- toggle file explorer
			vim.keymap.set("n", "<leader>ef", function()
				MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
				MiniFiles.reveal_cwd()
			end, { desc = "Toggle into currently opened file" })
		end,
	},
	{
		"echasnovski/mini.surround",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			-- For more information see `:h MiniSurround.config`.
			custom_surroundings = nil,
			-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
			highlight_duration = 300,
			-- Module mappings. Use `''` (empty string) to disable one.
			-- INFO:
			-- saiw surround with no whitespace
			-- saw surround with whitespace
			mappings = {
				add = "sa", -- Add surrounding in Normal and Visual modes
				delete = "ds", -- Delete surrounding
				find = "sf", -- Find surrounding (to the right)
				find_left = "sF", -- Find surrounding (to the left)
				highlight = "sh", -- Highlight surrounding
				replace = "sr", -- Replace surrounding
				update_n_lines = "sn", -- Update `n_lines`

				suffix_last = "l", -- Suffix to search with "prev" method
				suffix_next = "n", -- Suffix to search with "next" method
			},
			-- Number of lines within which surrounding is searched
			n_lines = 20,
			-- Whether to respect selection type:
			-- - Place surroundings on separate lines in linewise mode.
			-- - Place surroundings on each line in blockwise mode.
			respect_selection_type = false,
			-- How to search for surrounding (first inside current line, then inside
			-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
			-- 'cover_or_nearest', 'next', 'prev', 'nearest'. For more details,
			-- see `:h MiniSurround.config`.
			search_method = "cover",
			-- Whether to disable showing non-error feedback
			silent = false,
		},
	},
	{
		"echasnovski/mini.splitjoin",
		config = function()
			local miniSplitJoin = require("mini.splitjoin")
			miniSplitJoin.setup({
				mappings = { toggle = "" }, -- Disable default mapping
			})
			vim.keymap.set({ "n", "x" }, "sj", function()
				miniSplitJoin.join()
			end, { desc = "Join arguments" })
			vim.keymap.set({ "n", "x" }, "sk", function()
				miniSplitJoin.split()
			end, { desc = "Split arguments" })
		end,
	},
}
