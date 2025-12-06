-- ~/.config/nvim/lua/Plugins/lsp/languages.lua
return {
	servers = {
		pyright = { -- Python
			settings = {
				python = {
					analysis = {
						autosearchpaths = true,
						uselibrarycodefortypes = true,
						-- diagnosticseverityoverrides = {
						-- 	reportunusedvariable = "none",
						-- 	reportmissingimports = "warning",
						-- 	reportundefinedvariable = "error",
						-- },
						-- reportgeneraltypeissues = true,
						-- typecheckingmode = "basic", -- "strict", "off"
					},
				},
			},
		},
		-- pylyzer = {}, -- Alternative Python LSP
		svelte = {}, -- Svelte components
		tailwindcss = {}, -- Tailwind CSS classes
		eslint = {}, -- JavaScript/TypeScript linter
		ts_ls = {}, -- TypeScript/JavaScript
		texlab = {}, -- LaTeX LSP and Tex linter
		ltex = {}, -- LanguageTool integration for LaTeX
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
		"stylua",
		"pyright",
		"clangd",
		"clang-format",
		"codelldb", -- For Debugging
		-- "asm-lsp",
	},
}
