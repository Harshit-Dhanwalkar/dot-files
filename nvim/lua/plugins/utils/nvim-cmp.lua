-- ~/.config/nvim/lua/plugins/utils/nvim-cmp.lua
return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	requires = {
		{ "kdheepak/cmp-latex-symbols" }, -- Source for Latex Symbols
		{ "rafamadriz/friendly-snippets", event = "VeryLazy" },
	},
	dependencies = {
		-- Snippet Engine & its associated nvim-cmp source
		"honza/vim-snippets",
		"saadparwaiz1/cmp_luasnip",
		{
			"L3MON4D3/LuaSnip",
			-- build = (function()
			-- 	-- Build Step is needed for regex support in snippets.
			-- 	-- Remove the below condition to re-enable on windows.
			-- 	if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
			-- 		return
			-- 	end
			-- 	return "make install_jsregexp"
			-- end)(),
			dependencies = {
				-- `friendly-snippets` contains a variety of premade snippets.
				--    https://github.com/rafamadriz/friendly-snippets
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
		},
		"quangnguyen30192/cmp-nvim-ultisnips",
		"sirver/ultisnips",
		"hrsh7th/cmp-vsnip",
		"hrsh7th/vim-vsnip",
		-- Color Swatches in the completion menu
		"brenoprata10/nvim-highlight-colors",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-cmdline",
		-- { "hrsh7th/cmp-emoji", dependencies = { "hrsh7th/nvim-cmp" } }
		-- Adds other completion capabilities.
	},
	enabled = true,
	config = function()
		-- See `:help cmp`
		local cmp = require("cmp")
		-- local luasnip = require("luasnip")
		-- luasnip.config.setup({})
		-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see: https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
					require("luasnip.loaders.from_vscode").lazy_load()
					-- vim.fn["vsnip#anonymous"](args.body)
				end,
			},
			preselect = "item",
			completion = {
				completeopt = "menu,menuone,noinsert",
				-- autocomplete = false,
			},
			window = {
				-- completion = cmp.config.window.bordered(),
				completion = {
					border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
					winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
				},
				-- documentation = cmp.config.window.bordered(),
				documentation = {
					border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
				},
			},
			-- `:help ins-completion` for mapping help
			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-p>"] = cmp.mapping.select_prev_item(),
				-- Scroll the documentation window [b]ack / [f]orward
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				-- Accept ([y]es) the completion.
				--  This will expand snippets if the LSP sent a snippet.
				["<C-y>"] = cmp.mapping.confirm({ select = true }),
				-- tab support
				["<Tab>"] = cmp.mapping.select_next_item(),
				-- ['<Tab>'] = cmp.mapping(function(fallback)
				--       local luasnip = require('luasnip')
				--       local col = vim.fn.col('.') - 1
				--       if cmp.visible() then
				--         cmp.select_next_item({behavior = 'select'})
				--       elseif luasnip.expand_or_locally_jumpable() then
				--         luasnip.expand_or_jump()
				--       elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
				--         fallback()
				--       else
				--         cmp.complete()
				--       end
				--     end, {'i', 's'}),
				["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = "select" }),
				-- ["<S-Tab>"] = cmp.mapping.select_prev_item(),
				-- ['<S-Tab>'] = cmp.mapping(function(fallback)
				--       local luasnip = require('luasnip')
				--       if cmp.visible() then
				--         cmp.select_prev_item({behavior = 'select'})
				--       elseif luasnip.locally_jumpable(-1) then
				--         luasnip.jump(-1)
				--       else
				--         fallback()
				--       end
				--     end, {'i', 's'}),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<C-e>"] = cmp.mapping.close(),
				-- Manually trigger a completion from nvim-cmp.
				["<C-Space>"] = cmp.mapping.complete({}),
				-- <c-l> will move you to the right of each of the expansion locations.
				-- <c-h> is similar, except moving you backwards.
				["<C-l>"] = cmp.mapping(function(fallback)
					if vim.fn["vsnip#available"](1) == 1 then
						vim.fn.feedkeys(
							vim.api.nvim_replace_termcodes("<Plug>(vsnip-expand-or-jump)", true, true, true),
							""
						)
					else
						fallback()
					end
				end, { "i", "s" }),
				["<C-h>"] = cmp.mapping(function(fallback)
					if vim.fn["vsnip#jumpable"](-1) == 1 then
						vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-prev)", true, true, true), "")
					else
						fallback()
					end
				end, { "i", "s" }),
				-- ["<C-t>"] = cmp.mapping(function()
				-- 	cmp.complete({
				-- 		config = {
				-- 			sources = {
				-- 				{
				-- 					name = "path",
				-- 					option = {
				-- 						trailing_slash = true,
				-- 						-- This forces it to look at your current working directory
				-- 						get_cwd = function()
				-- 							return vim.fn.getcwd()
				-- 						end,
				-- 					},
				-- 				},
				-- 			},
				-- 		},
				-- 	})
				-- end, { "i", "s" }),
			}),
			sources = {
				{
					name = "lazydev",
					-- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
					group_index = 0,
				},
				{ name = "luasnip" },
				-- { name = "vsnip" },
				{ name = "cmp-nvim-ultisnips" },
				{ name = "ultisnips" },
				{
					name = "latex_symbols",
					option = {
						strategy = 0, -- mixed
					},
				},
				{ name = "path" }, -- file paths
				-- { name = "nvim_lsp" },
				{ name = "nvim_lsp", keyword_length = 3 }, -- from language server
				{ name = "nvim_lsp_signature_help" }, -- display function signatures with current parameter emphasized
				{ name = "nvim_lua", keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
				{ name = "treesitter" },
				{ name = "buffer", keyword_length = 2 }, -- source current buffer
				{ name = "calc" }, -- source for math calculation
				{ name = "nasm_registers" },
				{ name = "nasm_instructions" },
				{ name = "spell", keyword_length = 3 },
				-- { name = "emoji" },
			},
			formatting = {
				fields = { "menu", "abbr", "kind" },
				format = function(entry, item)
					item = require("nvim-highlight-colors").format(entry, item)
					local menu_icon = {
						nvim_lsp = "λ",
						luasnip = "l",
						vsnip = "v",
						ultisnips = "u",
						buffer = "Ω",
						path = "🖫",
						nvim_lua = "Π",
					}
					item.menu = menu_icon[entry.source.name] or ""
					return item
				end,
				expandable_indicator = function(_, item)
					if item.kind == "Snippet" then
						return "⋗" -- Snippet items will show an arrow to indicate they are expandable
					end
					return "" -- No indicator for other kinds
				end,
			},
		})
		--  '/' cmdline setup
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})
		-- `:` cmdline setup
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" }, -- File paths
			}, {
				{ name = "cmdline", option = { ignore_cmds = { "Man", "!" } } },
			}),
		})
	end,
}
