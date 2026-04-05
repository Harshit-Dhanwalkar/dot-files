-- ~/.config/nvim/lua/plugins/lsp/languages.lua

-- Helper to detect Deno projects
local util = require("lspconfig.util")

return {
	servers = {
		bashls = {}, -- Bash
		-- codebook = {}, -- spell checker
		ruff = {}, -- Python
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
		denols = { -- TSX, JSX, TypeScript and JavaScript
			root_dir = util.root_pattern("deno.json", "deno.jsonc"),
		},
		ts_ls = { -- JavaScript  and TypeScript
			root_dir = function(fname)
				local deno_root = util.root_pattern("deno.json", "deno.jsonc")(fname)
				if deno_root then
					return nil
				end
				return util.root_pattern("package.json", "tsconfig.json", ".git")(fname)
			end,
			single_file_support = false,
		},
		eslint = {}, -- JavaScript and TypeScript linter
		svelte = {}, -- Svelte components
		tailwindcss = {}, -- Tailwind CSS classes
		texlab = {}, -- LaTeX LSP and Tex linter
		ltex = { -- LanguageTool integration for LaTeX
			filetypes = {
				"tex",
				"bib",
				"markdown",
				"org",
				"gitcommit",
				"restructuredtext",
			},
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
		clangd = { -- C/C++
			root_dir = function(fname)
				local util = require("lspconfig").util
				-- Look for common C/C++ project markers
				return util.root_pattern(
					".clangd",
					".clang-tidy",
					".clang-format",
					"compile_commands.json",
					"compile_flags.txt",
					"configure.ac",
					".git"
				)(fname) or util.path.dirname(fname)
			end,
			-- Additional clangd arguments
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=iwyu",
				"--completion-style=detailed",
				"--function-arg-placeholders",
				"--fallback-style=llvm",
			},
			-- This will help with include paths
			init_options = {
				usePlaceholders = true,
				completeUnimported = true,
				clangdFileStatus = true,
			},
			-- NOTE: For global cland config:
			-- cat > ~/.clangd << EOF
			-- CompileFlags:
			--   Add: [-Wall, -Wextra]
			--   Remove: []
			-- Index:
			--   Background: Build
			-- Diagnostics:
			--   UnusedIncludes: Strict
			--   MissingIncludes: Strict
			-- EOF
		},
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
		-- "codebook", -- Spell checker
		"ruff", -- Python, format
		-- "black", -- Python formatter
		"pyright",
		"debugpy",
		"clangd",
		"clang-format",
		"codelldb", -- For Debugging
		"denols", -- TSX/JSX/TS/JS
		"eslint-lsp",
		-- "prettier", -- For JS/TS/CSS/HTML
		"typescript-language-server",
		"tailwindcss-language-server",
		"stylua",
		-- "asm-lsp",
		-- "goimports",  -- For Go
		-- "rustfmt", -- rust-analyzer
	},
}
