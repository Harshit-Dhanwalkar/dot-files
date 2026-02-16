-- ~/.config/nvim/lua/Plugins/appearance/undo-glow.lua
return {
	"y3owk1n/undo-glow.nvim",
	keys = {
		-- Undo
		{
			"u",
			function()
				-- You can use vim.cmd("undo") here or the library function
				vim.cmd("undo")
				require("undo-glow").undo()
			end,
			mode = "n",
			desc = "Undo with highlight",
		},
		-- Redo
		{
			"<C-r>", -- Using default <C-r> for redo is more conventional than 'U'
			function()
				vim.cmd("redo")
				require("undo-glow").redo()
			end,
			mode = "n",
			desc = "Redo with highlight",
		},
		-- Paste below
		{
			"p",
			function()
				require("undo-glow").paste_below()
			end,
			mode = "n",
			desc = "Paste below with highlight",
		},
		-- Paste above
		{
			"P",
			function()
				require("undo-glow").paste_above()
			end,
			mode = "n",
			desc = "Paste above with highlight",
		},
		-- Search next
		{
			"n",
			function()
				require("undo-glow").search_next({
					animation = {
						animation_type = "strobe",
					},
				})
			end,
			mode = "n",
			desc = "Search next with highlight",
		},
		-- Search prev
		{
			"N",
			function()
				require("undo-glow").search_prev({
					animation = {
						animation_type = "strobe",
					},
				})
			end,
			mode = "n",
			desc = "Search prev with highlight",
		},
		-- Search star
		{
			"*",
			function()
				require("undo-glow").search_star({
					animation = {
						animation_type = "strobe",
					},
				})
			end,
			mode = "n",
			desc = "Search star with highlight",
		},
		-- Search hash
		{
			"#",
			function()
				require("undo-glow").search_hash({
					animation = {
						animation_type = "strobe",
					},
				})
			end,
			mode = "n",
			desc = "Search hash with highlight",
		},
		-- Toggle comment (n and x modes)
		{
			"gc",
			function()
				-- This is an implementation to preserve the cursor position
				local pos = vim.fn.getpos(".")
				vim.schedule(function()
					vim.fn.setpos(".", pos)
				end)
				return require("undo-glow").comment()
			end,
			mode = { "n", "x" },
			desc = "Toggle comment with highlight",
			expr = true, -- expr is required for this type of mapping
		},
		-- Comment textobject (o mode)
		{
			"gc",
			function()
				require("undo-glow").comment_textobject()
			end,
			mode = "o",
			desc = "Comment textobject with highlight",
		},
		-- Toggle comment line
		{
			"gcc",
			function()
				return require("undo-glow").comment_line()
			end,
			mode = "n",
			desc = "Toggle comment line with highlight",
			expr = true, -- expr is required for this type of mapping
		},
	},

	config = function()
		require("undo-glow").setup({
			animation = {
				enabled = true,
				duration = 300,
				animation_type = "zoom",
				window_scoped = true,
			},
			highlights = {
				undo = {
					hl_color = { bg = "#693232" }, -- Dark muted red
				},
				redo = {
					hl_color = { bg = "#2F4640" }, -- Dark muted green
				},
				yank = {
					hl_color = { bg = "#7A683A" }, -- Dark muted yellow
				},
				paste = {
					hl_color = { bg = "#325B5B" }, -- Dark muted cyan
				},
				search = {
					hl_color = { bg = "#5C475C" }, -- Dark muted purple
				},
				comment = {
					hl_color = { bg = "#7A5A3D" }, -- Dark muted orange
				},
				cursor = {
					hl_color = { bg = "#793D54" }, -- Dark muted pink
				},
			},
			priority = 2048 * 3,
		})
	end,

	init = function()
		-- Yank (copy) highlight
		vim.api.nvim_create_autocmd("TextYankPost", {
			desc = "Highlight when yanking (copying) text",
			callback = function()
				require("undo-glow").yank()
			end,
		})

		-- Cursor move highlight
		vim.api.nvim_create_autocmd("CursorMoved", {
			desc = "Highlight when cursor moved significantly",
			callback = function()
				require("undo-glow").cursor_moved({
					animation = {
						animation_type = "slide",
					},
				})
			end,
		})

		-- Search cmdline highlight
		vim.api.nvim_create_autocmd("CmdLineLeave", {
			pattern = { "/", "?" },
			desc = "Highlight when search cmdline leave",
			callback = function()
				require("undo-glow").search_cmd({
					animation = {
						animation_type = "fade",
					},
				})
			end,
		})
	end,
}
