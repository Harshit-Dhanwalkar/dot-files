-- ~/.config/nvim/lua/Plugins/others/csvview.lua
return {
	"hat0uma/csvview.nvim",
	config = function()
		require("csvview").setup({
			cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
			view = {
				header_lnum = true, -- Auto-detect header (1 -> for one line header, false -> disable header)
				sticky_header = {
					separator = "═", -- Double line
					-- separator = false, -- No separator
				},
				display_mode = "border", -- "highlight"
				-- min_column_width = 5,  -- Minimum width for each column
				-- spacing = 2,           -- Space between columns
				max_lookahead = 50, -- Maximum lines to search for closing quotes
			},
			parser = {
				comments = { "#", "//", "--" }, -- Lines starting with these are ignored
				-- " Specific delimiters
				-- :CsvViewEnable delimiter=,
				-- :CsvViewEnable delimiter=\t
				-- " Special characters (use escape sequences)
				-- :CsvViewEnable delimiter=\   " Space
				-- :CsvViewEnable delimiter=\t  " Tab
				delimiter = {
					ft = {
						csv = ",", -- Always use comma for .csv files
						tsv = "\t", -- Always use tab for .tsv files
					},
				},
				fallbacks = { -- Try these delimiters in order for other files
					",", -- Comma (most common)
					"\t", -- Tab
					";", -- Semicolon
					"|", -- Pipe
					":", -- Colon
					" ", -- Space
				},
				keymaps = {
					-- Select field content (inner)
					textobject_field_inner = { "if", mode = { "o", "x" } },
					-- Select field including delimiter (outer)
					textobject_field_outer = { "af", mode = { "o", "x" } },
					-- Horizontal navigation
					jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
					jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
					-- Vertical navigation
					jump_next_row = { "<Enter>", mode = { "n", "v" } },
					jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
				},
			},
		})
	end,
}
