-- ~/.config/nvim/lua/plugins/lsp/languages.lua

-- Helper to detect Deno projects
local util = require("lspconfig.util")

return {
	servers = {
		asm_lsp = {}, -- Assembly
		bashls = { -- Bash
			root_dir = function(on_attach)
				return {
					on_attach = function(client, bufnr)
						on_attach(client, bufnr)
					end,
					cmd = { "bash-language-server", "start" },
					cmd_env = {
						GLOB_PATTERN = "*@(.sh|.inc|.bash|.command|.zsh)",
					},
					settings = {
						bashIde = {
							globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command|.zsh)",
						},
					},
					filetypes = { "sh", "zsh" },
					root_dir = util.find_git_ancestor,
					single_file_support = true,
				}
			end,
		},
		clangd = { -- C/C++
			root_dir = function(fname)
				-- local util = require("lspconfig").util
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
				-- "--fallback-style=llvm",
				"--fallback-style=Google",
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
		-- codebook = {}, -- spell checker
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
		ruff = {}, -- Python
		-- pylsp = {}, --Python
		-- pylyzer = {}, -- Alternative Python LSP
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
		json_lsp = {},
		tflint = {},
		yamlls = {},
		denols = { -- TSX, JSX, TypeScript and JavaScript
			root_dir = util.root_pattern("deno.json", "deno.jsonc"),
		},
		html = {},
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
		tailwindcss = { -- Tailwind CSS classes
			vim.lsp.config("tailwindcss", {
				cmd = { "tailwindcss-language-server", "--stdio" },
				filetypes = {
					"astro",
					"astro-markdown",
					"blade",
					"clojure",
					"django-html",
					"htmldjango",
					"edge",
					"gohtml",
					"haml",
					"handlebars",
					"hbs",
					"html",
					"html-eex",
					"heex",
					"jade",
					"leaf",
					"liquid",
					"markdown",
					"mdx",
					"mustache",
					"njk",
					"nunjucks",
					"razor",
					"slim",
					"twig",
					"css",
					"less",
					"postcss",
					"sass",
					"scss",
					"stylus",
					"sugarss",
					"reason",
					"rescript",
					"vue",
					"svelte",
				},
				init_options = {
					userLanguages = { eelixir = "html-eex", eruby = "erb" },
				},
				root_dir = util.root_pattern(
					"tailwind.config.js",
					"tailwind.config.cjs",
					"tailwind.config.mjs",
					"tailwind.config.ts",
					"postcss.config.js",
					"postcss.config.cjs",
					"postcss.config.mjs",
					"postcss.config.ts",
					"package.json",
					"node_modules",
					".git"
				),
				single_file_support = true,
				settings = {
					tailwindCSS = {
						classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
						lint = {
							cssConflict = "warning",
							invalidApply = "error",
							invalidConfigPath = "error",
							invalidScreen = "error",
							invalidTailwindDirective = "error",
							invalidVariant = "error",
							recommendedVariantOrder = "warning",
						},
						validate = true,
					},
				},
			}),
			vim.lsp.enable("tailwindcss"),
		},
		terraform_ls = {},
		lua_ls = { -- Lua
			settings = {
				Lua = {
					completion = { callSnippet = "Replace" },
				},
			},
		},
		emmylua_ls = {},
		-- rust_analyzer = { -- Rust
		--   settings = {
		--   ['rust-analyzer'] = {},
		--   },
		-- },
		docker_ls = {},
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
		"cpplint",
		"clang-format",
		"codelldb", -- For Debugging
		"denols", -- TSX/JSX/TS/JS
		"eslint-lsp",
		-- "prettier", -- For JS/TS/CSS/HTML
		"typescript-language-server",
		"tailwindcss-language-server",
		"stylua",
		"json-lsp",
		-- "asm-lsp",
		-- "goimports",  -- For Go
		-- "rustfmt", -- rust-analyzer
	},
}
