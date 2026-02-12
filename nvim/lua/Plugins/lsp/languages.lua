-- ~/.config/nvim/lua/Plugins/lsp/languages.lua
return {
	servers = {
		bashls = {}, -- Bash
		pyright = { -- Python
			settings = {
				python = {
					analysis = {
						autosearchpaths = true,
						uselibrarycodefortypes = true,
						diagnosticMode = "openFilesOnly",
						-- diagnosticseverityoverrides = {
						-- 	reportunusedvariable = "none",
						-- 	reportmissingimports = "warning",
						-- 	reportundefinedvariable = "error",
						-- },
						-- reportgeneraltypeissues = true,
						-- typecheckingmode = "basic", -- "strict", "off"
					},
					venvPath = ".",
					venv = "venv",
				},
			},
		},
		-- pylyzer = {}, -- Alternative Python LSP
		svelte = {}, -- Svelte components
		tailwindcss = {}, -- Tailwind CSS classes
		eslint = {}, -- JavaScript/TypeScript linter
		ts_ls = {}, -- TypeScript/JavaScript
		texlab = {}, -- LaTeX LSP and Tex linter
		ltex = { -- LanguageTool integration for LaTeX
			settings = {
				ltex = {
					disabledRules = {
						["en-US"] = {
							-- "PROPER_NOUN_WITHOUT_DETERMINER",
							"COMMAS_PARENTHESIS_WHITESPACE",
							"UNLIKELY_OPENING_PUNCTUATION",
							"NUMBERS_IN_WORDS",
						},
					},
					dictionary = { ["en-US"] = {} },
				},
			},
		},
		["ltex_plus"] = {}, -- LanguageTool integration for LaTeX
		markdown_oxide = {}, -- Markdown
		clangd = {}, -- C/C++
		lua_ls = { -- Lua
			settings = {
				Lua = {
					completion = { callSnippet = "Replace" },
				},
			},
		},
		-- rust_analyzer = { -- Rust
		--   settings = {
		--   ['rust-analyzer'] = {},
		--   },
		-- },
		-- asm_lsp = {}, -- Assembly
	},

	-- Install LSP & tools via Mason
	tools = {
		"bash-language-server",
		"stylua",
		"ruff", -- for Python
		"black", -- Python formatter
		"pyright",
		"debugpy",
		"clangd",
		"clang-format",
		"codelldb", -- For Debugging
		-- "asm-lsp",
		-- "prettier", -- For JS/TS/CSS/HTML
		-- "goimports",  -- For Go
		-- "rustfmt", -- rust-analyzer
	},
}
