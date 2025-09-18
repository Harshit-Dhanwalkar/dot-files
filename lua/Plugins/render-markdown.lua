-- ~/.config/nvim/lua/Plugins/render-markdown.lua
return {
	"MeanderingProgrammer/render-markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim", "nvim-tree/nvim-web-devicons" },
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {},
	config = function()
		require("render-markdown").setup({
			latex = { enabled = false },
			code = {
				-- Turn on / off code block & inline code rendering
				enabled = true,
				-- Turn on / off any sign column related rendering
				sign = true,
				-- Determines how code blocks & inline code are rendered:
				--  none:     disables all rendering
				--  normal:   adds highlight group to code blocks & inline code, adds padding to code blocks
				--  language: adds language icon to sign column if enabled and icon + name above code blocks
				--  full:     normal + language
				style = "full",
				-- Determines where language icon is rendered:
				--  right: right side of code block
				--  left:  left side of code block
				position = "right",
				-- Amount of padding to add around the language
				-- If a floating point value < 1 is provided it is treated as a percentage of the available window space
				language_pad = 0.5,
				-- Whether to include the language name next to the icon
				language_name = false, -- true,
				-- A list of language names for which background highlighting will be disabled
				-- Likely because that language has background highlights itself
				-- Or a boolean to make behavior apply to all languages
				-- Borders above & below blocks will continue to be rendered
				disable_background = { "diff" },
				-- Width of the code block background:
				--  block: width of the code block
				--  full:  full width of the window
				width = "full",
				-- Amount of margin to add to the left of code blocks
				-- If a floating point value < 1 is provided it is treated as a percentage of the available window space
				-- Margin available space is computed after accounting for padding
				left_margin = 0,
				-- Amount of padding to add to the left of code blocks
				-- If a floating point value < 1 is provided it is treated as a percentage of the available window space
				left_pad = 0.3,
				-- Amount of padding to add to the right of code blocks when width is 'block'
				-- If a floating point value < 1 is provided it is treated as a percentage of the available window space
				right_pad = 0.3,
				-- Minimum width to use for code blocks when width is 'block'
				min_width = 0,
				-- Determines how the top / bottom of code block are rendered:
				--  thick: use the same highlight as the code body
				--  thin:  when lines are empty overlay the above & below icons
				border = "thin",
				-- Used above code blocks for thin border
				above = "▄",
				-- Used below code blocks for thin border
				below = "▀",
				-- Highlight for code blocks
				highlight = "RenderMarkdownCode",
				-- Highlight for inline code
				highlight_inline = "RenderMarkdownCodeInline",
				-- Highlight for language, overrides icon provider value
				highlight_language = nil,
			},
			bullet = {
				-- Turn on / off list bullet rendering
				enabled = true,
				-- Replaces '-'|'+'|'*' of 'list_item'
				-- How deeply nested the list is determines the 'level' which is used to index into the list using a cycle
				-- The item number in the list is used to index into the value using a clamp if the value is also a list
				-- If the item is a 'checkbox' a conceal is used to hide the bullet instead
				icons = { "●", "○", "◆", "◇" },
				-- Replaces 'n.'|'n)' of 'list_item'
				-- How deeply nested the list is determines the 'level' which is used to index into the list using a cycle
				-- The item number in the list is used to index into the value using a clamp if the value is also a list
				ordered_icons = {},
				-- Padding to add to the left of bullet point
				left_pad = 0,
				-- Padding to add to the right of bullet point
				right_pad = 0,
				-- Highlight for the bullet icon
				highlight = "RenderMarkdownBullet",
			},
			-- Checkboxes are a special instance of a 'list_item' that start with a 'shortcut_link'
			-- There are two special states for unchecked & checked defined in the markdown grammar
			checkbox = {
				-- Turn on / off checkbox state rendering
				enabled = true,
				-- Determines how icons fill the available space:
				--  inline:  underlying text is concealed resulting in a left aligned icon
				--  overlay: result is left padded with spaces to hide any additional text
				position = "inline",
				unchecked = {
					-- Replaces '[ ]' of 'task_list_marker_unchecked'
					icon = "󰄱 ",
					-- Highlight for the unchecked icon
					highlight = "RenderMarkdownUnchecked",
					-- Highlight for item associated with unchecked checkbox
					scope_highlight = nil,
				},
				checked = {
					-- Replaces '[x]' of 'task_list_marker_checked'
					icon = "󰱒 ",
					-- Highlight for the checked icon
					highlight = "RenderMarkdownChecked",
					-- Highlight for item associated with checked checkbox
					scope_highlight = nil,
				},
				-- Define custom checkbox states, more involved as they are not part of the markdown grammar as a result this requires neovim >= 0.10.0 since it relies on 'inline' extmarks can specify as many additional states as you like following the 'todo' pattern below
				--   The key in this case 'todo' is for healthcheck and to allow users to change its values
				--   'raw':             Matched against the raw text of a 'shortcut_link'
				--   'rendered':        Replaces the 'raw' value when rendering
				--   'highlight':       Highlight for the 'rendered' icon
				--   'scope_highlight': Highlight for item associated with custom checkbox
				custom = {
					todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo", scope_highlight = nil },
				},
			},
			quote = {
				-- Turn on / off block quote & callout rendering
				enabled = true,
				-- Replaces '>' of 'block_quote'
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
				-- Turn on / off pipe table rendering
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
				-- Turn on / off sign rendering
				enabled = true,
				-- Applies to background of sign text
				highlight = "RenderMarkdownSign",
			},
			-- Mimic org-indent-mode behavior by indenting everything under a heading based on the level of the heading. Indenting starts from level 2 headings onward.
			indent = {
				-- Turn on / off org-indent-mode
				enabled = false,
				-- Amount of additional padding added for each heading level
				per_level = 2,
				-- Heading levels <= this value will not be indented
				-- Use 0 to begin indenting from the very first level
				skip_level = 1,
				-- Do not indent heading titles, only the body
				skip_heading = false,
			},
		})
	end,
}
