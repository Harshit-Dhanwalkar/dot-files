-- ~/.config/nvim/lua/Plugins/mini.lua
return {
	{
		"echasnovski/mini.comment",
		version = false,
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
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
		"echasnovski/mini.jump2d",
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
			-- vim.keymap.set("n", "rl", function()
			-- 	custom_2d_jump({
			-- 		mark = "l",
			-- 		repeatable = true,
			-- 		homerow = true,
			-- 		spotter = MiniJump2d.builtin_opts.line_start.spotter,
			-- 		preaction = "dd",
			-- 		norepeat_action = "P",
			-- 		action = "j",
			-- 		action2 = "dd",
			-- 		afteraction = "P",
			-- 	})
			-- end)
		end,
	},
	{
		"echasnovski/mini.files",
		config = function()
			require("mini.files").setup({
				mappings = {
					go_in = "<CR>", -- Enter and L to enter directories or open files
					go_in_plus = "L",
					go_out = "-",
					go_out_plus = "H",
				},
			})
			-- layout preferences
			local widths = {
				math.floor(vim.o.columns * 0.45),
				math.floor(vim.o.columns * 0.25),
				math.floor(vim.o.columns * 0.15),
			}
			local ensure_center_layout = function(ev)
				local state = MiniFiles.get_explorer_state()
				if state == nil then
					return
				end
				-- Compute "depth offset" - how many windows are between this and focused
				local path_this = vim.api.nvim_buf_get_name(ev.data.buf_id):match("^minifiles://%d+/(.*)$")
				local depth_this
				for i, path in ipairs(state.branch) do
					if path == path_this then
						depth_this = i
					end
				end
				if depth_this == nil then
					return
				end
				local depth_focus = state.depth_focus
				local depth_offset = depth_this - depth_focus
				-- Adjust config of this event's window
				local i = math.abs(depth_offset) + 1
				local win_config = vim.api.nvim_win_get_config(ev.data.win_id)
				-- Use specific width if defined, otherwise use the last value in widths table
				win_config.width = widths[i] or widths[#widths]

				-- -- Calculate horizontal position (col)
				-- -- Start at the center for the focused window
				-- win_config.col = math.floor(0.5 * (vim.o.columns - widths[1]))
				--
				-- -- Offset side windows
				-- for j = 1, math.abs(depth_offset) do
				-- 	local sign = depth_offset > 0 and 1 or -1
				-- 	-- prev_width needs to account for the width of windows between center and this one
				-- 	local prev_width = widths[j] or widths[#widths]
				-- 	win_config.col = win_config.col + sign * prev_width
				-- end
				-- Anchor focused window at center
				local center_col = math.floor((vim.o.columns - widths[1]) / 2)
				if depth_offset == 0 then
					-- Focused panel
					win_config.col = center_col
				else
					-- Panels to the left/right stack tightly
					local sign = depth_offset > 0 and 1 or -1
					local offset = 0
					for j = 1, math.abs(depth_offset) do
						offset = offset + (widths[j] or widths[#widths])
					end
					win_config.col = center_col + sign * offset
				end
				-- Adjust height and vertical position (row)
				win_config.height = depth_offset == 0 and 25 or 20
				win_config.row = math.floor(0.5 * (vim.o.lines - win_config.height))
				-- Apply custom border
				win_config.border = depth_offset == 0 and { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
					or "single"
				vim.api.nvim_win_set_config(ev.data.win_id, win_config)
			end
			vim.api.nvim_create_autocmd("User", {
				pattern = "MiniFilesWindowUpdate",
				callback = ensure_center_layout,
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
		config = function()
			require("mini.surround").setup({
				-- For more information see `:h MiniSurround.config`.
				custom_surroundings = nil,
				-- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
				highlight_duration = 300,
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
					suffix_last = "p", -- Suffix to search with "prev" method
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
			})
		end,
	},
	{
		"echasnovski/mini.splitjoin",
		config = function()
			miniSplitJoin = require("mini.splitjoin")
			miniSplitJoin.setup({
				mappings = { toggle = "" }, -- Disable default mapping
			})
			vim.keymap.set({ "n", "x" }, "mj", function()
				miniSplitJoin.join()
			end, { desc = "Join arguments" })
			vim.keymap.set({ "n", "x" }, "mk", function()
				miniSplitJoin.split()
			end, { desc = "Split arguments" })
		end,
	},
	-- {
	-- 	"echasnovski/mini.map",
	-- 	config = function()
	-- 		require("mini.map").setup({
	-- 			integrations = nil,
	-- 			symbols = {
	-- 				encode = nil,
	-- 				scroll_line = "█",
	-- 				scroll_view = "┃",
	-- 			},
	-- 			window = {
	-- 				focusable = false,
	-- 				side = "right",
	-- 				show_integration_count = true,
	-- 				width = 10,
	-- 				winblend = 25,
	-- 				zindex = 10,
	-- 			},
	-- 		})
	-- 		vim.keymap.set("n", "<leader>-", function()
	-- 			require("mini.map").toggle()
	-- 		end, { desc = "Toggle mini.map" })
	-- 	end,
	-- },
	--
	-- require("mini.statusline")
	-- statusline.setup({ use_icons = vim.g.have_nerd_font })
	-- ---@diagnostic disable-next-line: duplicate-set-field
	-- statusline.section_location = function()
	-- 	return "%2l:%-2v"
	--
	-- require("mini.ai").setup({ n_lines = 500 })
	-- -- Add/delete/replace surroundings (brackets, quotes, etc.)
	-- -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
	-- -- - sd'   - [S]urround [D]elete [']quotes
	-- -- - sr)'  - [S]urround [R]eplace [)] [']
	--
	{
		"echasnovski/mini.operators",
		event = "VeryLazy",
		config = function()
			require("mini.operators").setup({})
		end,
	},
	{
		"echasnovski/mini.align",
		event = "VeryLazy",
		config = function()
			require("mini.align").setup({})
		end,
	},
}
