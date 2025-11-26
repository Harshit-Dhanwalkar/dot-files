-- ~/.config/nvim/lua/Plugins/nvim-cmp.lua
return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	requires = {
		{ "kdheepak/cmp-latex-symbols" },
	},
	dependencies = {
		-- Snippet Engine & its associated nvim-cmp source
		{
			"L3MON4D3/LuaSnip",
			build = (function()
				-- Build Step is needed for regex support in snippets.
				-- Remove the below condition to re-enable on windows.
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
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
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-vsnip",
		"hrsh7th/vim-vsnip",
		"hrsh7th/cmp-cmdline",
		-- Adds other completion capabilities.
	},
	enabled = true,
	config = function()
		-- See `:help cmp`
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		luasnip.config.setup({})

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = { completeopt = "menu,menuone,noinsert" },
			window = {
				completion = {
					border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
					winhighlight = "Normal:CmpPmenu,FloatBorder:CmpPmenuBorder,CursorLine:PmenuSel,Search:None",
				},
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
				["<S-Tab>"] = cmp.mapping.select_prev_item(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<C-e>"] = cmp.mapping.close(),
				-- Manually trigger a completion from nvim-cmp.
				--  Generally you don't need this, because nvim-cmp will display completions whenever it has completion options available.
				["<C-Space>"] = cmp.mapping.complete({}),
				-- <c-l> will move you to the right of each of the expansion locations.
				-- <c-h> is similar, except moving you backwards.
				["<C-l>"] = cmp.mapping(function()
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					end
				end, { "i", "s" }),
				["<C-h>"] = cmp.mapping(function()
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					end
				end, { "i", "s" }),
				-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
			}),
			sources = {
				{
					name = "lazydev",
					-- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
					group_index = 0,
				},
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{
					name = "latex_symbols",
					option = {
						strategy = 0, -- mixed
					},
				},
				{ name = "path" }, -- file paths
				{ name = "nvim_lsp", keyword_length = 3 }, -- from language server
				{ name = "nvim_lsp_signature_help" }, -- display function signatures with current parameter emphasized
				{ name = "nvim_lua", keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
				{ name = "buffer", keyword_length = 2 }, -- source current buffer
				{ name = "vsnip", keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
				{ name = "calc" }, -- source for math calculation
				{ name = "nasm_registers" },
				{ name = "nasm_instructions" },
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
		-- formatting = {
		--   fields = { 'menu', 'abbr', 'kind' },
		--   format = function(entry, item)
		--     local menu_icon = {
		--       nvim_lsp = 'λ',
		--       vsnip = '⋗',
		--       buffer = 'Ω',
		--       path = '🖫',
		--     }
		--     item.menu = menu_icon[entry.source.name] or ''
		--     return item
		--   end,
		--   expandable_indicator = function(_, item)
		--     if item.kind == "Snippet" then
		--       return "⋗"  -- Snippet items will show an arrow to indicate they are expandable
		--     end
		--     return ""  -- No indicator for other kinds
		--   end,
		--       },
	end,
}
