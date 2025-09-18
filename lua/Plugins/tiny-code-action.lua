-- ~/.config/nvim/lua/Plugins/tiny-code-action.lua
return {
	"rachartier/tiny-code-action.nvim",
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
	},
	event = "LspAttach", -- Load the plugin when an LSP client attaches to a buffer
	opts = {
		-- The backend to use for displaying diffs.
		-- Options: "vim", "delta", "difftastic", "diffsofancy"
		backend = "vim",
		-- The picker to use for selecting code actions.
		-- Options: "telescope", "snacks", "select", "buffer"
		picker = "telescope",
		-- Backend-specific options
		backend_opts = {
			delta = {
				-- Number of header lines to remove from delta's output
				header_lines_to_remove = 4,
				-- Arguments to pass to delta
				args = {
					"--line-numbers",
				},
			},
			difftastic = {
				-- Number of header lines to remove from difftastic's output
				header_lines_to_remove = 1,
				-- Arguments to pass to difftastic
				args = {
					"--color=always",
					"--display=inline",
					"--syntax-highlight=on",
				},
			},
			diffsofancy = {
				-- Number of header lines to remove from diffsofancy's output
				header_lines_to_remove = 4,
			},
		},
		-- Custom icons (signs) to use for different code action kinds.
		-- Each entry is a table with the icon string and an optional highlight table.
		-- The highlight can be a link to an existing highlight group (e.g., "DiagnosticWarning")
		-- or a table with nvim_set_hl compatible properties (e.g., { fg = "#FF0000", bold = true }).
		signs = {
			quickfix = { "", { link = "DiagnosticWarning" } },
			others = { "", { link = "DiagnosticWarning" } },
			refactor = { "", { link = "DiagnosticInfo" } },
			["refactor.move"] = { "󰪹", { link = "DiagnosticInfo" } },
			["refactor.extract"] = { "", { link = "DiagnosticError" } },
			["source.organizeImports"] = { "", { link = "DiagnosticWarning" } },
			["source.fixAll"] = { "󰃢", { link = "DiagnosticError" } },
			["source"] = { "", { link = "DiagnosticError" } },
			["rename"] = { "󰑕", { link = "DiagnosticWarning" } },
			["codeAction"] = { "", { link = "DiagnosticWarning" } },
		},
	},
}
