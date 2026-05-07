-- ~/.config/yazi/init.lua

-- local greetings = require("greetings")
-- greetings.entry()

-- Topline and bottomline
local tokyo_night_theme = require("yatline-tokyo-night"):setup("night") -- or moon/storm/day
require("yatline"):setup({
	theme = tokyo_night_theme,
	header_line = {
		left = {
			section_a = { { type = "line", name = "tabs" } },
			section_b = { { type = "coloreds", custom = false, name = "symlink" } },
			section_c = {
				-- { type = "coloreds", custom = false, name = "hostname_username" },
			},
		},
		right = {
			section_a = { { type = "string", name = "date", params = { "%A, %d %B" } } },
			section_b = { { type = "coloreds", custom = false, name = "githead" } },
			section_c = {
				-- { type = "string", custom = false, name = "hovered_file_extension", params = { true } },
				{ type = "coloreds", custom = false, name = "page_count" },
			},
		},
	},
})
-- require("yatline-hostname-username"):setup({
-- 	color = "#FFFFFF",
-- 	mode = "both", -- "host", "user", "both"
-- })
require("yatline-symlink"):setup()
require("yatline-page-counter"):setup()
require("yatline-githead"):setup({
	order = {
		"branch",
		"remote",
		"tag",
		"commit",
		"behind_ahead_remote",
		"stashes",
		"state",
		"staged",
		"unstaged",
		"untracked",
	},
	show_numbers = true, -- shows staged, unstaged, untracked, stashes count

	-- Branch
	show_branch = true,
	branch_prefix = "",
	branch_color = tokyo_night_theme.blue,
	branch_symbol = "",
	branch_borders = "",

	show_remote_branch = true, -- only shown if different from local branch
	always_show_remote_branch = true, -- always show remote branch even if it the same as local branch
	always_show_remote_repo = true, -- Adds `origin/` if `always_show_remote_branch` is enabled
	remote_branch_prefix = ":",

	show_tag = true, -- only shown if branch is not available
	always_show_tag = false,
	tag_color = tokyo_night_theme.magenta,
	tag_symbol = "#",
	--
	show_commit = true, -- only shown if branch AND tag are not available
	always_show_commit = false,
	commit_color = tokyo_night_theme.orange,
	commit_symbol = "@",

	-- Status indicators
	show_behind_ahead_remote = true,
	behind_remote_color = tokyo_night_theme.comment,
	behind_remote_symbol = "⇣",
	ahead_remote_color = tokyo_night_theme.purple,
	ahead_remote_symbol = "⇡",
	--
	show_stashes = true,
	stashes_color = tokyo_night_theme.teal,
	stashes_symbol = "$",

	-- State
	show_state = true,
	show_state_prefix = true,
	state_color = tokyo_night_theme.red,
	state_symbol = "~",
	--
	show_staged = true,
	staged_color = tokyo_night_theme.green,
	staged_symbol = "+",
	--
	show_unstaged = true,
	unstaged_color = tokyo_night_theme.yellow,
	unstaged_symbol = "!",
	--
	show_untracked = true,
	untracked_color = tokyo_night_theme.cyan,
	untracked_symbol = "?",
})

-- Bottomline
-- require("yaziline"):setup({
-- 	cut_files_color = "#892E3D",
--
-- 	separator_style = "angly", -- "angly" | "curvy" | "liney" | "empty"
--
-- 	select_symbol = "", -- S
-- 	yank_symbol = "󰆐", -- Y
--
-- 	filename_max_length = 24, -- truncate when filename > 24
-- 	filename_truncate_length = 10, -- leave 6 chars on both sides
-- 	filename_truncate_separator = "...",
-- })

require("duck-radar"):setup({
	-- Extra dirs to search in addition to ~/Downloads, ~/Documents, ~/Desktop, ~/Pictures
	dirs = {
		-- "/path/to/extra/dir",
	},
	-- 'find' or 'fd'
	app = "find",
	-- Time range; when using fd, use its format (e.g. "7d") instead of find's (e.g. "7")
	changedWithin = "7",
	-- Max depth to search. 2 for faster, 4 for deeper search
	maxDepth = "3",
	-- Amount of results to show
	resultLimit = 200,
})

require("current-size"):setup({
	equal_ignore = { "~", "/", "/home" }, -- full path match
	-- sub_ignore = {"~/harshitpd/master","~/harshit/venv"} -- sub path match
})

require("telegram-send"):setup({
	-- command = "telegram-send --file",
	command = "~/.config/yazi/plugins/telegram-send.yazi/telegram-send-env/bin/telegram-send --file",
	notification = true,
})

-- require("copy-file-contents"):setup({
-- 	append_char = "\n",
-- 	notification = true,
-- })

require("font-sample"):setup({
	text = 'ABCDEF abcdef\n0123456789 \noO08 iIlL1 g9qCGQ\n8%& <([{}])>\n.,;: @#$-_="\n== <= >= != ffi\nâéùïøçÃĒÆœ\n및개요これ直楽糸',
	canvas_size = "750x800",
	font_size = 80,
	-- https://imagemagick.org/script/color.php
	bg = "white",
	fg = "black",
})

require("simple-tag"):setup({
	-- UI display mode (icon, text, hidden)
	ui_mode = "icon", -- (Optional)
	-- Disable tag key hints (popup in bottom right corner)
	hints_disabled = false, -- (Optional)
	-- Display tags on the left side or right side.
	left_side = false,
	render_order = 500,
	-- Replace default yazi file/folder icons with tag icons. Only apply if left_side = true and have at least 1 tag.
	-- Look better if it has only 1 tag. -> use function instead of boolean
	replace_default_icon = false, -- (Optional)
	-- Padding for left/right side.
	-- padding_left = " ", -- (Optional, string only)
	-- padding_right = " ", -- (Optional, string only)

	-- Use replace_default_icon as a function instead
	-- tags: list/table of tag keys
	-- file: fs::File. https://yazi-rs.github.io/docs/plugins/context#fs-file

	-- replace_default_icon = function(file, tags) -- (Optional)
	-- 	--return tags[1] == "*" and file.is_hovered -- Only apply to file/folder with tag key * and hovered
	-- 	return #tags == 1 -- Only apply to file/folder with only 1 tag
	-- end,

	-- You can backup/restore this folder within the same OS (Linux, windows, or MacOS).
	-- But you can't restore backed up folder in the different OS because they use difference absolute path.
	-- save_path =  -- full path to save tags folder (Optional)
	--       - Linux/MacOS: os.getenv("HOME") .. "/.config/yazi/tags"
	--       - Windows: os.getenv("APPDATA") .. "\\yazi\\config\\tags"

	-- Set tag colors
	colors = { -- (Optional)
		-- Set this same value with `theme.toml` > [mgr] > hovered > reversed
		-- Default theme use "reversed = true".
		-- More info: https://github.com/sxyazi/yazi/blob/077faacc9a84bb5a06c5a8185a71405b0cb3dc8a/yazi-config/preset/theme-dark.toml#L25
		-- Only need to set this if you use shipped/stable yazi <= v25.5.31 or nightly yazi installed before 11/12/2025
		reversed = true, -- (Optional)

		-- More colors: https://yazi-rs.github.io/docs/configuration/theme#types.color
		-- format: [tag key] = "color"
		["*"] = "#bf68d9", -- (Optional)
		["$"] = "green",
		["!"] = "#cc9057",
		["1"] = "cyan",
		["p"] = "red",
	},

	-- Set tag icons. Only show when ui_mode = "icon".
	-- Any text or nerdfont icons should work as long as you use nerdfont to render yazi.
	-- Default icon from mactag.yazi: ●; Some generic icons: , , 󱈤
	-- More icon from nerd fonts: https://www.nerdfonts.com/cheat-sheet
	icons = { -- (Optional)
		default = "󰚋",

		-- format: [tag key] = "tag icon"
		["*"] = "*",
		["$"] = "",
		["!"] = "",
		["p"] = "",
		["w"] = "This long text also works",
	},
})
