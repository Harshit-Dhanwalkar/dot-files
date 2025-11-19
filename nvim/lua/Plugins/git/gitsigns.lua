-- ~/.config/nvim/lua/Plugins/git/gitsigns.lua
return {
	"lewis6991/gitsigns.nvim",
	opts = {
		signs = {
			add = { text = "+" },
			change = { text = "~" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
		},
		on_attach = function(bufnr)
			local gitsigns = require("gitsigns")
			local function map(mode, l, r, opts)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end
			-- Navigation
			map("n", "]c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]c", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end, { desc = "Jump to next git [c]hange" })
			map("n", "[c", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[c", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end, { desc = "Jump to previous git [c]hange" })
			-- Actions
			-- visual mode
			map("v", "<leader>hs", function()
				gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "stage git hunk" })
			map("v", "<leader>hr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end, { desc = "reset git hunk" })
			-- normal mode
			map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "git [s]tage hunk" })
			map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
			map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "git [S]tage buffer" })
			map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "git [u]ndo stage hunk" })
			map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
			map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
			map("n", "<leader>hb", gitsigns.blame_line, { desc = "git [b]lame line" })
			map("n", "<leader>hd", gitsigns.diffthis, { desc = "git [d]iff against index" })
			map("n", "<leader>hD", function()
				gitsigns.diffthis("@")
			end, { desc = "git [D]iff against last commit" })
			-- Toggles
			map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "[T]oggle git show [b]lame line" })
			map("n", "<leader>tD", gitsigns.toggle_deleted, { desc = "[T]oggle git show [D]eleted" })
		end,
	},
}

-- In `gitsigns.lua`
-- {
-- 	"lewis6991/gitsigns.nvim",
-- 	event = { "BufReadPre", "BufNewFile" },
-- 	opts = {
-- 		on_attach = function(bufnr)
-- 			local gs = package.loaded.gitsigns
-- 			local function map(mode, l, r, desc)
-- 				vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
-- 			end
-- 			-- Navigation
-- 			map("n", "]h", gs.next_hunk, "Next Hunk")
-- 			map("n", "[h", gs.prev_hunk, "Prev Hunk")
-- 			-- Actions
-- 			map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
-- 			map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
--
-- 			map("v", "<leader>gs", function() -- stage selected hunk
-- 				gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
-- 			end, "Stage hunk")
-- 			map("v", "<leader>gr", function() -- reset selected hunk
-- 				gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
-- 			end, "Reset hunk")
-- 			map("n", "<leader>gS", gs.stage_buffer, "Stage buffer") -- stage whole buffer
-- 			map("n", "<leader>gR", gs.reset_buffer, "Reset buffer") -- unstage whole buffer
-- 			map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
-- 			map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
-- 			map("n", "<leader>gbl", function()
-- 				gs.blame_line({ full = true })
-- 			end, "Blame line")
-- 			map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle line blame")
-- 			map("n", "<leader>gd", gs.diffthis, "Diff this")
-- 			map("n", "<leader>gD", function()
-- 				gs.diffthis("~")
-- 			end, "Diff this ~")
-- 			-- Text object
-- 			map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
-- 		end,
-- 	},
-- },
