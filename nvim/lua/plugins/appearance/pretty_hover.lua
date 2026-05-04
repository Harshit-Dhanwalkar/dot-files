-- ~/.config/nvim/lua/plugins/appearance/pretty_hover.lua

return {
	"Fildo7525/pretty_hover",
	event = "LspAttach",

	config = function()
		require("pretty_hover").setup({
			-- Tables grouping the detected strings and using the markdown highlighters.
			header = {
				detect = { "[\\@]class" },
				styler = "###",
			},
			line = {
				detect = { "[\\@]brief" },
				styler = "**",
			},
			listing = {
				detect = { "[\\@]li" },
				styler = " - ",
			},
			references = {
				detect = { "[\\@]ref", "[\\@]c", "[\\@]name" },
				styler = { "**", "`" },
			},
			group = {
				detect = {
					-- ["Group name"] = {"detectors"}
					["Parameters"] = { "[\\@]param", "[\\@]*param*" },
					["Types"] = { "[\\@]tparam" },
					["See"] = { "[\\@]see" },
					["Return Value"] = { "[\\@]retval" },
				},
				styler = "`",
			},

			-- Tables used for cleaner identification of hover segments.
			code = {
				start = { "[\\@]code" },
				ending = { "[\\@]endcode" },
			},
			return_statement = {
				"[\\@]return",
				"[\\@]*return*",
			},

			-- Highlight groups used in the hover method. Feel free to define your own highlight group.
			hl = {
				error = {
					color = "#DC2626",
					detect = { "[\\@]error", "[\\@]bug" },
					line = false, -- Flag detecting if the whole line should be highlighted
				},
				warning = {
					color = "#FBBF24",
					detect = { "[\\@]warning", "[\\@]thread_safety", "[\\@]throw" },
					line = false,
				},
				info = {
					color = "#2563EB",
					detect = { "[\\@]remark", "[\\@]note", "[\\@]notes" },
				},
				-- Here you can set up your highlight groups.
			},

			-- If you use nvim 0.11.0 or higher you can choose, whether you want to use the new
			-- multi lsp support or not. Otherwise this option is ignored.
			multi_server = true,
			border = "rounded",
			wrap = true,
			max_width = nil,
			max_height = nil,
			toggle = false,
		})
	end,
}
