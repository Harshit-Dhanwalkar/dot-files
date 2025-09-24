-- ~/.config/nvim/lua/Plugins/render-markdown.lua
return {
	"MeanderingProgrammer/render-markdown.nvim",
	enabled = true,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"echasnovski/mini.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	---@module 'render-markdown'
	---@type render.md.UserConfig
	init = function()
		-- Define colors
		local color1_bg = "#ff757f"
		local color2_bg = "#4fd6be"
		local color3_bg = "#7dcfff"
		local color4_bg = "#ff9e64"
		local color5_bg = "#7aa2f7"
		local color6_bg = "#c0caf5"
		local color_fg = "#1F2335"

		-- Heading background
		-- vim.cmd(string.format([[highlight Headline1Bg guifg=%s guibg=%s gui=bold]], color_fg, color1_bg))
		-- vim.cmd(string.format([[highlight Headline2Bg guifg=%s guibg=%s gui=bold]], color_fg, color2_bg))
		-- vim.cmd(string.format([[highlight Headline3Bg guifg=%s guibg=%s gui=bold]], color_fg, color3_bg))
		-- vim.cmd(string.format([[highlight Headline4Bg guifg=%s guibg=%s gui=bold]], color_fg, color4_bg))
		-- vim.cmd(string.format([[highlight Headline5Bg guifg=%s guibg=%s gui=bold]], color_fg, color5_bg))
		-- vim.cmd(string.format([[highlight Headline6Bg guifg=%s guibg=%s gui=bold]], color_fg, color6_bg))

		-- Heading fg
		-- vim.cmd(string.format([[highlight Headline1Fg guifg=%s gui=bold]], colors.color1_bg))
		-- vim.cmd(string.format([[highlight Headline2Fg guifg=%s gui=bold]], colors.color2_bg))
		-- vim.cmd(string.format([[highlight Headline3Fg guifg=%s gui=bold]], colors.color3_bg))
		-- vim.cmd(string.format([[highlight Headline4Fg guifg=%s gui=bold]], colors.color4_bg))
		-- vim.cmd(string.format([[highlight Headline5Fg guifg=%s gui=bold]], colors.color5_bg))
		-- vim.cmd(string.format([[highlight Headline6Fg guifg=%s gui=bold]], colors.color6_bg))
	end,
	opts = {
		-- config = function()
		-- 	require("render-markdown").setup({
		latex = { enabled = false },
		code = {
			enabled = false,
			sign = true,
			style = "full",
			position = "right",
			language_pad = 0.5,
			language_name = true,
			disable_background = { "diff" },
			width = "full", -- block
			left_margin = 0.5, -- 0
			left_pad = 0.3,
			right_pad = 1, -- 0.3
			min_width = 0,
			border = "thin", -- thick
			above = "▄",
			below = "▀",
			highlight = "RenderMarkdownCode",
			highlight_inline = "RenderMarkdownCodeInline",
			highlight_language = nil,
		},
		bullet = {
			enabled = true,
			icons = { "●", "○", "◆", "◇" },
			ordered_icons = {},
			left_pad = 0,
			right_pad = 0,
			highlight = "RenderMarkdownBullet",
		},
		checkbox = {
			enabled = true,
			position = "inline",
			unchecked = {
				icon = "󰄱 ",
				highlight = "RenderMarkdownUnchecked",
				scope_highlight = nil,
			},
			checked = {
				icon = "󰱒 ",
				highlight = "RenderMarkdownChecked",
				scope_highlight = nil,
			},
			--   'raw':             Matched against the raw text of a 'shortcut_link'
			--   'rendered':        Replaces the 'raw' value when rendering
			--   'highlight':       Highlight for the 'rendered' icon
			--   'scope_highlight': Highlight for item associated with custom checkbox
			custom = {
				todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
			},
		},
		quote = {
			enabled = true,
			icon = "▋",
			-- Whether to repeat icon on wrapped lines. Requires neovim >= 0.10. This will obscure text if
			-- not configured correctly with :h 'showbreak', :h 'breakindent' and :h 'breakindentopt'. A
			-- combination of these that is likely to work is showbreak = '  ' (2 spaces), breakindent = true,
			-- breakindentopt = '' (empty string). These values are not validated by this plugin. If you want
			-- to avoid adding these to your main configuration then set them in win_options for this plugin.
			repeat_linebreak = false,
			-- Highlight for the quote icon
			highlight = "RenderMarkdownQuote",
		},
		pipe_table = {
			enabled = true,
			-- Pre configured settings largely for setting table border easier
			--  heavy:  use thicker border characters
			--  double: use double line border characters
			--  round:  use round border corners
			--  none:   does nothing
			preset = "none",
			-- Determines how the table as a whole is rendered:
			--  none:   disables all rendering
			--  normal: applies the 'cell' style rendering to each row of the table
			--  full:   normal + a top & bottom line that fill out the table when lengths match
			style = "full",
			-- Determines how individual cells of a table are rendered:
			--  overlay: writes completely over the table, removing conceal behavior and highlights
			--  raw:     replaces only the '|' characters in each row, leaving the cells unmodified
			--  padded:  raw + cells are padded to maximum visual width for each column
			--  trimmed: padded except empty space is subtracted from visual width calculation
			cell = "padded",
			-- Amount of space to put between cell contents and border
			padding = 1,
			-- Minimum column width to use for padded or trimmed cell
			min_width = 0,
				-- Characters used to replace table border correspond to top(3), delimiter(3), bottom(3), vertical, & horizontal
				-- stylua: ignore
				border = {
				    '┌', '┬', '┐',
				    '├', '┼', '┤',
				    '└', '┴', '┘',
				    '│', '─',
				},
			-- Gets placed in delimiter row for each column, position is based on alignment
			alignment_indicator = "━",
			-- Highlight for table heading, delimiter, and the line above
			head = "RenderMarkdownTableHead",
			-- Highlight for everything else, main table rows and the line below
			row = "RenderMarkdownTableRow",
			-- Highlight for inline padding used to add back concealed space
			filler = "RenderMarkdownTableFill",
		},
		-- Callouts are a special instance of a 'block_quote' that start with a 'shortcut_link' can specify as many additional values as you like following the pattern from any below, such as 'note' the key in this case 'note' is for healthcheck and to allow users to change its values :
		--   'raw':        Matched against the raw text of a 'shortcut_link', case insensitive
		--   'rendered':   Replaces the 'raw' value when rendering
		--   'highlight':  Highlight for the 'rendered' text and quote markers
		--   'quote_icon': Optional override for quote.icon value for individual callout
		callout = {
			note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
			tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
			important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
			warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
			caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
			-- Obsidian: https://help.obsidian.md/Editing+and+formatting/Callouts
			abstract = { raw = "[!ABSTRACT]", rendered = "󰨸 Abstract", highlight = "RenderMarkdownInfo" },
			summary = { raw = "[!SUMMARY]", rendered = "󰨸 Summary", highlight = "RenderMarkdownInfo" },
			tldr = { raw = "[!TLDR]", rendered = "󰨸 Tldr", highlight = "RenderMarkdownInfo" },
			info = { raw = "[!INFO]", rendered = "󰋽 Info", highlight = "RenderMarkdownInfo" },
			todo = { raw = "[!TODO]", rendered = "󰗡 Todo", highlight = "RenderMarkdownInfo" },
			hint = { raw = "[!HINT]", rendered = "󰌶 Hint", highlight = "RenderMarkdownSuccess" },
			success = { raw = "[!SUCCESS]", rendered = "󰄬 Success", highlight = "RenderMarkdownSuccess" },
			check = { raw = "[!CHECK]", rendered = "󰄬 Check", highlight = "RenderMarkdownSuccess" },
			done = { raw = "[!DONE]", rendered = "󰄬 Done", highlight = "RenderMarkdownSuccess" },
			question = { raw = "[!QUESTION]", rendered = "󰘥 Question", highlight = "RenderMarkdownWarn" },
			help = { raw = "[!HELP]", rendered = "󰘥 Help", highlight = "RenderMarkdownWarn" },
			faq = { raw = "[!FAQ]", rendered = "󰘥 Faq", highlight = "RenderMarkdownWarn" },
			attention = { raw = "[!ATTENTION]", rendered = "󰀪 Attention", highlight = "RenderMarkdownWarn" },
			failure = { raw = "[!FAILURE]", rendered = "󰅖 Failure", highlight = "RenderMarkdownError" },
			fail = { raw = "[!FAIL]", rendered = "󰅖 Fail", highlight = "RenderMarkdownError" },
			missing = { raw = "[!MISSING]", rendered = "󰅖 Missing", highlight = "RenderMarkdownError" },
			danger = { raw = "[!DANGER]", rendered = "󱐌 Danger", highlight = "RenderMarkdownError" },
			error = { raw = "[!ERROR]", rendered = "󱐌 Error", highlight = "RenderMarkdownError" },
			bug = { raw = "[!BUG]", rendered = "󰨰 Bug", highlight = "RenderMarkdownError" },
			example = { raw = "[!EXAMPLE]", rendered = "󰉹 Example", highlight = "RenderMarkdownHint" },
			quote = { raw = "[!QUOTE]", rendered = "󱆨 Quote", highlight = "RenderMarkdownQuote" },
			cite = { raw = "[!CITE]", rendered = "󱆨 Cite", highlight = "RenderMarkdownQuote" },
		},
		link = {
			-- Turn on / off inline link icon rendering
			enabled = true,
			-- Inlined with 'image' elements
			image = "󰥶 ",
			-- Inlined with 'email_autolink' elements
			email = "󰀓 ",
			-- Fallback icon for 'inline_link' elements
			hyperlink = "󰌹 ",
			-- Applies to the fallback inlined icon
			highlight = "RenderMarkdownLink",
			-- Applies to WikiLink elements
			wiki = { icon = "󱗖 ", highlight = "RenderMarkdownWikiLink" },
			-- Define custom destination patterns so icons can quickly inform you of what a link
			-- contains. Applies to 'inline_link' and wikilink nodes.
			-- Can specify as many additional values as you like following the 'web' pattern below
			--   The key in this case 'web' is for healthcheck and to allow users to change its values
			--   'pattern':   Matched against the destination text see :h lua-pattern
			--   'icon':      Gets inlined before the link text
			--   'highlight': Highlight for the 'icon'
			custom = {
				web = { pattern = "^http[s]?://", icon = "󰖟 ", highlight = "RenderMarkdownLink" },
			},
		},
		sign = {
			enabled = true,
			highlight = "RenderMarkdownSign",
		},
		-- Mimic org-indent-mode behavior by indenting everything under a heading based on the level of the heading. Indenting starts from level 2 headings onward.
		indent = {
			enabled = false,
			per_level = 2,
			skip_level = 1,
			skip_heading = false,
		},
	},
	-- 	end,
}
