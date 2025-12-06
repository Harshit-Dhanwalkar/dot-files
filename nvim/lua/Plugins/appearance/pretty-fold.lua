-- ~/.config/nvim/lua/Plugins/appearance/pretty-fold.lua
return {
	"anuvyklack/pretty-fold.nvim",
	config = function()
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		vim.opt.foldcolumn = "1" -- Show the fold column
		vim.opt.foldlevel = 0

		require("pretty-fold").setup({
			config = {
				sections = {
					left = {
						"content",
					},
					right = {
						" ",
						"number_of_folded_lines",
						": ",
						"percentage",
						" ",
						function(config)
							return config.fill_char:rep(3)
						end,
					},
				},
				fill_char = "•",
				remove_fold_markers = true,
				keep_indentation = true,
				-- Possible values:
				-- "delete" : Delete all comment signs from the fold string.
				-- "spaces" : Replace all comment signs with equal number of spaces.
				-- false    : Do nothing with comment signs.
				process_comment_signs = "spaces",
				-- Comment signs additional to the value of `&commentstring` option.
				comment_signs = {},
				-- List of patterns that will be removed from content foldtext section.
				stop_words = {
					"@brief%s*", -- (for C++) Remove '@brief' and all spaces after.
				},
				add_close_pattern = true, -- true, 'last_line' or false
				matchup_patterns = {
					-- General
					{ "^%s*{", "^%s*}" },
					{ "^%s*%(", "^%s*%)" },
					{ "^%s*%[", "^%s*%]" },
					-- { "{", "}" },
					-- { "%(", ")" }, -- % to escape lua pattern char
					-- { "%[", "]" }, -- % to escape lua pattern char
					-- Lua
					{ "^%s*do$", "end" },
					{ "^%s*if", "end" },
					{ "^%s*for", "end" },
					{ "function%s*%(", "end" },
					-- LaTeX
					{ "\\begin%s*{%a+}", "\\end%s*{%a+}" },
					{ "\\begin%s*%[%a+%]", "\\end%s*%[%a+%]" },
					-- HTML/XML
					{ "<%a+[%s/>]", "</%a+>" },
					-- JavaScript/TypeScript
					{ "^%s*class%s+[%w_]+%s*{", "}" },
					{ "^%s*function%s+[%w_]+%s*%(", "}" },
					-- Python
					{ "^%s*def%s+[%w_]+%s*%(", "}" },
					{ "^%s*class%s+[%w_]+%s*%(", "}" },
					-- C/C++
					{ "^%s*#if", "#endif" },
					{ "^%s*#region", "#endregion" },
					-- Markdown
					{ "^%s*```%a*", "^%s*```" },
					-- Rust
					{ "^%s*impl%s+[%w_]+%s*{", "}" },
					{ "^%s*trait%s+[%w_]+%s*{", "}" },
					{ "^%s*struct%s+[%w_]+%s*{", "}" },
					{ "^%s*enum%s+[%w_]+%s*{", "}" },
				},
				ft_ignore = { "neorg" },
				ft_setup = {
					"cpp",
					{
						process_comment_signs = false,
					},
					comment_signs = {
						"///",
						"//!",
						"/**",
					},
					stop_words = {
						"@brief%s*",
					},
				},
			},
		})
		vim.opt.foldtext = "v:lua.require('pretty-fold').foldtext()"
	end,
}
