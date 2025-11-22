-- ~/.config/nvim/lua/Plugins/render-markdown.lua
return {
	"MeanderingProgrammer/render-markdown.nvim",
	enabled = true,
	ft = { "markdown", "vimwiki" },
	cmd = { "RenderMarkdown" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"echasnovski/mini.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("render-markdown").setup({
			-- render_mode = { "n", "c", "t" },
			render_mode = { "n" },
			latex = { enabled = true },
			code = {
				enabled = true,
				sign = true,
				style = "full", -- compact
				position = "left",
				language_pad = 0.01,
				language_name = true,
				disable_background = { "diff" },
				width = "full", -- block
				left_margin = 0,
				left_pad = 0.02,
				right_pad = 0.02,
				-- min_width = 0,
				border = "thick", -- thin
				-- above = "▄",
				-- below = "▀",
				highlight = "RenderMarkdownCode",
				highlight_inline = "RenderMarkdownCodeInline",
				highlight_language = nil,
			},
			bullet = {
				enabled = true,
				-- icons = { "●", "○", "◆", "◇" },  --defualts
				icons = { "●", "○", "◆", "◇", "󰫢", "󰫣", "󰫤", "󰫥" },
				ordered_icons = {},
				left_pad = 0,
				right_pad = 0,
				highlight = "RenderMarkdownBullet",
			},
			checkbox = {
				enabled = true,
				position = "inline",
				unchecked = {
					-- icon = "󰄱 ", --default
					icon = "󰄰 ", -- 󰄱
					highlight = "RenderMarkdownUnchecked",
					scope_highlight = nil,
				},
				checked = {
					-- icon = "󰱒 ", --default
					icon = "󰗠 ", --   󰄴 󱤧
					highlight = "RenderMarkdownChecked",
					scope_highlight = nil,
				},
				--   'raw':             Matched against the raw text of a 'shortcut_link'
				--   'rendered':        Replaces the 'raw' value when rendering
				--   'highlight':       Highlight for the 'rendered' icon
				--   'scope_highlight': Highlight for item associated with custom checkbox
				custom = {
					todo = {
						raw = "[-]",
						rendered = "󰀡 ", -- 󰦕 󰾨 󰥔
						highlight = "RenderMarkdownTodo",
						scope_highlight = nil,
					},
					-- Number sequence
					-- num1 = { raw = "[1]", rendered = "󰎠 ", highlight = "RenderMarkdownNumber" },
					-- num2 = { raw = "[2]", rendered = "󰎡 ", highlight = "RenderMarkdownNumber" },
					-- num3 = { raw = "[3]", rendered = "󰎢 ", highlight = "RenderMarkdownNumber" },
					-- num4 = { raw = "[4]", rendered = "󰎣 ", highlight = "RenderMarkdownNumber" },
					-- num5 = { raw = "[5]", rendered = "󰎤 ", highlight = "RenderMarkdownNumber" },
					-- num6 = { raw = "[6]", rendered = "󰎥 ", highlight = "RenderMarkdownNumber" },
					-- num7 = { raw = "[7]", rendered = "󰎦 ", highlight = "RenderMarkdownNumber" },
					-- num8 = { raw = "[8]", rendered = "󰎧 ", highlight = "RenderMarkdownNumber" },
					-- num9 = { raw = "[9]", rendered = "󰎨 ", highlight = "RenderMarkdownNumber" },
					-- num10 = { raw = "[10]", rendered = "󰎩 ", highlight = "RenderMarkdownNumber" },
				},
			},
			quote = {
				enabled = true,
				-- Replaces '>' of 'block_quote'.
				icon = "▋",
				-- Additional modes to render quotes.
				render_modes = false,
				-- Whether to repeat icon on wrapped lines. Requires neovim >= 0.10. This will obscure text if
				-- not configured correctly with :h 'showbreak', :h 'breakindent' and :h 'breakindentopt'. A
				-- combination of these that is likely to work is showbreak = '  ' (2 spaces), breakindent = true,
				-- breakindentopt = '' (empty string). These values are not validated by this plugin. If you want
				-- to avoid adding these to your main configuration then set them in win_options for this plugin.
				repeat_linebreak = false,
				-- Highlight for the quote icon
				-- If a list is provided output is evaluated by `cycle(value, level)`.
				highlight = {
					"RenderMarkdownQuote1",
					"RenderMarkdownQuote2",
					"RenderMarkdownQuote3",
					"RenderMarkdownQuote4",
					"RenderMarkdownQuote5",
					"RenderMarkdownQuote6",
				},
			},
			pipe_table = {
				enabled = true,
				-- Additional modes to render pipe tables.
				render_modes = false,
				-- Pre configured settings largely for setting table border easier
				--  heavy:  use thicker border characters
				--  double: use double line border characters
				--  round:  use round border corners
				--  none:   does nothing
				preset = "none",
				-- Determines how individual cells of a table are rendered:
				--  overlay: writes completely over the table, removing conceal behavior and highlights
				--  raw:     replaces only the '|' characters in each row, leaving the cells unmodified
				--  padded:  raw + cells are padded to maximum visual width for each column
				--  trimmed: padded except empty space is subtracted from visual width calculation
				cell = "padded",
				-- Adjust the computed width of table cells using custom logic.
				cell_offset = function()
					return 0
				end,
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
				-- Turn on / off top & bottom lines.
				border_enabled = true,
				-- Always use virtual lines for table borders instead of attempting to use empty lines.
				-- Will be automatically enabled if indentation module is enabled.
				border_virtual = false,
				-- Gets placed in delimiter row for each column, position is based on alignment.
				alignment_indicator = "━",
				-- Highlight for table heading, delimiter, and the line above
				head = "RenderMarkdownTableHead",
				-- Highlight for everything else, main table rows and the line below
				row = "RenderMarkdownTableRow",
				-- Highlight for inline padding used to add back concealed space
				filler = "RenderMarkdownTableFill",
				-- Determines how the table as a whole is rendered.
				-- | none   | { enabled = false }        |
				-- | normal | { border_enabled = false } |
				-- | full   | uses all default values    |
				style = "full",
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
				enabled = true,
				-- Additional modes to render links.
				render_modes = false,
				-- Inlined with 'image' elements
				-- How to handle footnote links, start with a '^'.
				footnote = {
					enabled = true,
					-- Inlined with content.
					icon = "󰯔 ",
					-- Replace value with superscript equivalent.
					superscript = true,
					-- Added before link content.
					prefix = "",
					-- Added after link content.
					suffix = "",
				},
				image = "󰥶 ",
				-- Inlined with 'email_autolink' elements
				email = "󰀓 ",
				-- Fallback icon for 'inline_link' elements
				hyperlink = "󰌹 ",
				-- Applies to the fallback inlined icon
				highlight = "RenderMarkdownLink",
				-- Applies to WikiLink elements
				wiki = {
					icon = "󱗖 ",
					body = function()
						return nil
					end,
					highlight = "RenderMarkdownWikiLink",
					scope_highlight = nil,
				},
				-- Define custom destination patterns so icons can quickly inform you of what a link
				-- contains. Applies to 'inline_link' and wikilink nodes.
				-- Can specify as many additional values as you like following the 'web' pattern below
				--   The key in this case 'web' is for healthcheck and to allow users to change its values
				--   'pattern':   Matched against the destination text see :h lua-pattern
				--   'icon':      Gets inlined before the link text
				--   'highlight': Highlight for the 'icon'
				custom = {
					web = { pattern = "^http", icon = "󰖟 " },
					discord = { pattern = "discord%.com", icon = "󰙯 " },
					github = { pattern = "github%.com", icon = "󰊤 " },
					gitlab = { pattern = "gitlab%.com", icon = "󰮠 " },
					google = { pattern = "google%.com", icon = "󰊭 " },
					neovim = { pattern = "neovim%.io", icon = " " },
					reddit = { pattern = "reddit%.com", icon = "󰑍 " },
					stackoverflow = { pattern = "stackoverflow%.com", icon = "󰓌 " },
					wikipedia = { pattern = "wikipedia%.org", icon = "󰖬 " },
					youtube = { pattern = "youtube%.com", icon = "󰗃 " },
				},
			},
			sign = {
				enabled = true,
				-- Applies to background of sign text.
				highlight = "RenderMarkdownSign",
			},
			-- Mimic org-indent-mode behavior by indenting everything under a heading based on the level of the heading. Indenting starts from level 2 headings onward.
			indent = {
				-- Turn on / off org-indent-mode.
				enabled = false,
				-- Additional modes to render indents.
				render_modes = false,
				-- Amount of additional padding added for each heading level.
				per_level = 2,
				-- Heading levels <= this value will not be indented.
				-- Use 0 to begin indenting from the very first level.
				skip_level = 1,
				-- Do not indent heading titles, only the body.
				skip_heading = false,
				-- Prefix added when indenting, one per level.
				icon = "▎",
				-- Priority to assign to extmarks.
				priority = 0,
				-- Applied to icon.
				highlight = "RenderMarkdownIndent",
			},
		})
	end,
}
