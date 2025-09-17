-- -[[ Install `lazy.nvim` plugin manager ]]
--   See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "failed to clone lazy.nvim:\n", "Errormsg" },
			{ out, "Warningmsg" },
			{ "\npress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
-- setup lazy.nvim
require("lazy").setup({
	-- Use `opts = {}` to force a plugin to be loaded.
	-- options to `gitsigns.nvim`. This is equivalent to the following Lua:
	--    require('gitsigns').setup({ ... })
	opts = {
		rocks = {
			hererocks = false, -- Disable LuaRocks
			enabled = false, -- Disable LuaRocks
		},
	},
	-- Detect tabstop and shiftwidth automatically
	{ "tpope/vim-sleuth" },
	-- See `:help gitsigns` to understand what the configuration keys do
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
		},
	},
	-- git integraction like git-history
	{
		"sindrets/diffview.nvim",
		dependencies = "nvim-lua/plenary.nvim", -- Required dependency
		cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" }, -- Lazy-load on commands
		config = function()
			require("diffview").setup({
				view = {
					merge_tool = {
						layout = "diff3_mixed", -- Use a diff3 layout for merge conflicts
					},
				},
				keymaps = {
					view = {
						["<leader>e"] = "<cmd>DiffviewToggleFiles<CR>", -- Toggle file panel
						["<leader>q"] = "<cmd>DiffviewClose<CR>", -- Close Diffview
					},
					file_panel = {
						["1"] = "next_entry", -- Move to next file entry
						["2"] = "prev_entry", -- Move to previous file entry
						["<cr>"] = "select_entry", -- Open file diff
					},
					file_history_panel = {
						["g!"] = "options", -- Toggle diff options
						["<leader>q"] = "<cmd>DiffviewClose<CR>", -- Close Diffview
					},
				},
			})
		end,
	},
	-- Useful plugin to show you pending keybinds.
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},

			-- Document existing key chains
			spec = {
				{ "<leader>c", group = "[C]ode", mode = { "n", "x" } },
				{ "<leader>d", group = "[D]ocument" },
				{ "<leader>r", group = "[R]ename" },
				{ "<leader>s", group = "[S]earch" },
				{ "<leader>w", group = "[W]orkspace" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim", -- required
			"sindrets/diffview.nvim", -- optional - Diff integration
			"nvim-telescope/telescope.nvim", -- optional
		},
		config = true,
	},
	-- Fuzzy Finder (files, lsp, etc)
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",

				cond = function() -- `cond` is a condition used to determine whether this plugin should be installed and loaded.
					return vim.fn.executable("make") == 1
				end,
			},
			{
				"nvim-telescope/telescope-ui-select.nvim",
			},
			{
				"nvim-tree/nvim-web-devicons",
				enabled = vim.g.have_nerd_font,
			},
		},
		config = function()
			-- Two important keymaps to use while in Telescope are:
			--  - Insert mode: <c-/> -- to show keymaps for the current Telescope picker
			--  - Normal mode: ?
			--
			-- [[ Configure Telescope ]]
			-- See `:help telescope` and `:help telescope.setup()`
			require("telescope").setup({
				-- defaults = {
				--   mappings = {
				--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
				--   },
				-- },
				-- pickers = {}
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})
			-- Enable Telescope extensions if they are installed
			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
		end,
	},
	-- LSP Plugins
	{
		-- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins used for completion, annotations and signatures of Neovim apis
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				-- Load luvit types when the `vim.uv` word is found
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"Bilal2453/luvit-meta",
		lazy = true,
	},
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			{ "williamboman/mason.nvim", config = true }, --  Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {} },

			-- Allows extra capabilities provided by nvim-cmp
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					--  To jump back, press <C-t>.
					map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					-- Find references for the word under your cursor.
					map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					-- Jump to the implementation of the word under your cursor.
					map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					-- Jump to the type of the word under your cursor.
					map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
					-- Fuzzy find all the symbols in your current document.
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
					-- Fuzzy find all the symbols in your current workspace.
					map(
						"<leader>ws",
						require("telescope.builtin").lsp_dynamic_workspace_symbols,
						"[W]orkspace [S]ymbols"
					)
					-- Rename the variable under your cursor.
					map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
					-- Execute a code action, usually your cursor needs to be on top of an error or a suggestion from your LSP for this to activate.
					map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("[G]oto [D]eclaration", vim.lsp.buf.declaration, "gD")

					-- The following two autocommands are used to highlight references of the word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})
						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					-- The following code creates a keymap to toggle inlay hints in your code, if the language server you are using supports them
					-- This may be unwanted, since they displace some of your code
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})
			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

			-- Enable the following language servers
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--  For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				pyright = {},
				rust_analyzer = {},
				texlab = {},
				markdown_oxide = {},
				clangd = {},
				-- gopls = {},
				-- ts_ls = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				-- Some languages (like typescript) have entire language plugins that can be useful: `https://github.com/pmizio/typescript-tools.nvim`
				lua_ls = {
					-- cmd = {...},
					-- filetypes = { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							-- diagnostics = { disable = { 'missing-fields' } },
						},
					},
				},
			}
			-- Ensure the servers and tools above are installed
			--  To check the current status of installed tools and/or manually install other tools, you can run
			--    :Mason
			--
			--  You can press `g?` for help in this menu.
			require("mason").setup()
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed by the server configuration above. Useful when disabling certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	{ -- Autoformat
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				vue = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				html = { "prettier" },
				less = { "prettier" },
				jsonc = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				["markdown.mdx"] = { "prettier" },
				graphql = { "prettier" },
				handlebars = { "prettier" },
				json = { "fixjson", "prettier" },
				xml = { "xmlformatter" },
			},
			notify_on_error = false,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't have a well standardized coding style. You can add additional languages here or re-enable it for the disabled ones.
				local disable_filetypes = { c = true, cpp = true }
				local lsp_format_opt
				if disable_filetypes[vim.bo[bufnr].filetype] then
					lsp_format_opt = "never"
				else
					lsp_format_opt = "fallback"
				end
				return {
					timeout_ms = 500,
					lsp_format = lsp_format_opt,
				}
			end,
		},
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({
						async = true,
						lsp_format = "fallback",
						timeout_ms = 3000,
						lsp_fallback = true,
						formatting_options = { tabSize = 2 },
					})
				end,
				mode = { "n", "v" },
				desc = "[F]ormat buffer",
			},
			-- Format Selection
			{
				"<leader>ch",
				function()
					local vstart = vim.fn.getpos("'<")
					local vend = vim.fn.getpos("'>")
					local line_start = vstart[2]
					local line_end = vend[2]
					local lines = vim.fn.getline(line_start, line_end)
					local range = {
						start = line_start,
						["end"] = line_end,
					}
					require("conform").format({
						timeout_ms = 3000,
						lsp_fallback = true,
						formatting_options = { tabSize = 2 },
						range = range,
					})
				end,
				mode = { "v" },
				desc = "Format Selection",
			},
		},
	},
	{ -- Autocompletion
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
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
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-cmdline",
			-- Adds other completion capabilities.
		},
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
					{ name = "path" }, -- file paths
					{ name = "nvim_lsp", keyword_length = 3 }, -- from language server
					{ name = "nvim_lsp_signature_help" }, -- display function signatures with current parameter emphasized
					{ name = "nvim_lua", keyword_length = 2 }, -- complete neovim's Lua runtime API such vim.lsp.*
					{ name = "buffer", keyword_length = 2 }, -- source current buffer
					{ name = "vsnip", keyword_length = 2 }, -- nvim-cmp source for vim-vsnip
					{ name = "calc" }, -- source for math calculation
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
			--
		end,
	},
	{ -- Use `:Telescope colorscheme`.
		"folke/tokyonight.nvim",
		priority = 1000,
		init = function()
			vim.cmd.colorscheme("tokyonight-night")
			vim.cmd.hi("Comment gui=none")
		end,
		opts = {
			transparent = true,
			styles = {
				-- sidebars = 'transparent',
				floats = "transparent",
			},
		},
	},
	-- Highlight todo, notes, etc in comments
	-- FIX: `harshit` todo
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			{
				signs = true, -- show icons in the signs column
				sign_priority = 8, -- sign priority
				-- list of named colors where we try to extract the guifg from the list of hilight groups or use the hex color if hl not found as a fallback
				colors = {
					error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
					warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
					info = { "DiagnosticInfo", "#2563EB" },
					hint = { "DiagnosticHint", "#10B981" },
					default = { "Identifier", "#7C3AED" },
					test = { "Identifier", "#FF00FF" },
					linux = { "Keyword", "#FF323C" },
					custom = { "Comment", "#FFA100" },
					harshit = { "String", "#AFF5B7" }, --'#CBAFF5'
				},
				keywords = {
					FIX = {
						icon = " ",
						color = "error",
						alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
						-- signs = false,
					},
					TODO = { icon = " ", color = "info" },
					HACK = { icon = " ", color = "warning" },
					WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
					PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
					NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
					TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
					PERS = { icon = "⏼", color = "custom", alt = { "PERSONAL", "PRIVATE" } },
					LINUX = { icon = "🐧", color = "linux", alt = { "DISTRO", "TERMINAL", "KERNEL" } },
					HARSHIT = {
						icon = "ह",
						color = "harshit",
						alt = { "Harshit", "HARSHIT PPRASHANT DHANWALKAR", "Harshit Prahant Dhanwalkar" },
					}, -- Ħ Ӣ
					NVIM = { icon = "Ӣ ", color = "info" },
					-- more icon you can find here (https://symbl.cc/en/0126/)
				},
				--
				gui_style = {
					fg = "NONE",
					bg = "BOLD",
				},
				merge_keywords = true, -- when true, custom keywords will be merged with the defaults
				-- highlighting of the line containing the todo comment
				-- * before: highlights before the keyword (typically comment characters)
				-- * keyword: highlights of the keyword
				-- * after: highlights after the keyword (todo text)
				highlight = {
					multiline = true, -- enable multine todo comments
					multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
					multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
					before = "", -- "fg" or "bg" or empty
					keyword = "wide", -- "fg", "bg", "wide" or empty. (wide is the same as bg, but will also highlight surrounding characters)
					after = "fg", -- "fg" or "bg" or empty
					-- pattern can be a string, or a table of regexes that will be checked
					pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlightng (vim regex)
					-- pattern = { [[.*<(KEYWORDS)\s*:]], [[.*\@(KEYWORDS)\s*]] }, -- pattern used for highlightng (vim regex)
					comments_only = true, -- uses treesitter to match keywords in comments only
					max_line_len = 400, -- ignore lines longer than this
					exclude = {}, -- list of file types to exclude highlighting
					throttle = 200,
				},
				search = {
					command = "rg",
					args = {
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
					},
					-- regex that will be used to match keywords.
					-- don't replace the (KEYWORDS) placeholder
					pattern = [[\b(KEYWORDS):]], -- ripgrep regex
					-- pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
				},
			},
		},
	},
	{ -- Collection of various small independent plugins/modules
		"echasnovski/mini.nvim",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()
			-- local statusline = require("mini.statusline")
			-- statusline.setup({ use_icons = vim.g.have_nerd_font })
			-- ---@diagnostic disable-next-line: duplicate-set-field
			-- statusline.section_location = function()
			-- 	return "%2l:%-2v"
			-- end
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		main = "nvim-treesitter.configs",
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`
		opts = {
			ensure_installed = {
				"bash",
				"c",
				"diff",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"query",
				"vim",
				"vimdoc",
				"python",
				"rust",
				"html",
				"css",
				"javascript",
			},
			auto_install = true, -- Autoinstall languages that are not installed
			highlight = {
				enable = true,
				disable = { "latex" }, -- Disable Treesitter highlighting for LaTeX
				additional_vim_regex_highlighting = { "ruby" },
			},
			indent = { enable = true, disable = { "ruby" } },
			rainbow = {
				enable = true,
				extended_mode = true,
				max_file_lines = nil,
			},
		},
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	},
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({
				view = {
					side = "right",
					width = 30,
				},
			})
		end,
	},
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("bufferline").setup({})
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				create_mappings = false,
			})
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		config = function()
			require("Plugins.noice").setup()
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
	},
	{
		"lervag/vimtex",
		lazy = false, -- no lazy load VimTeX
		-- tag = "v2.15",
		ft = "tex", -- Load plugin only for TeX
		config = function()
			vim.g.tex_flavor = "latex"
			vim.g.vimtex_view_method = "zathura"
			vim.g.vimtex_quickfix_mode = 0
			vim.opt.conceallevel = 2
			vim.g.tex_conceal = "abdmg"
			vim.cmd("syntax enable")
			vim.g.vimtex_compiler_latexmk = {
				build_dir = "",
				continuous = 1,
				options = {
					"-ps",
					-- "-pdf",
					"-shell-escape",
					"-interaction=nonstopmode",
					"-synctex=1",
				},
			}
		end,
	},
	{
		"sirver/ultisnips",
		config = function()
			vim.g.UltiSnipsExpandTrigger = "<tab>"
			vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
			vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
			vim.g.UltiSnipsSnippetDirectories = { vim.fn.expand("~/.config/nvim/lua/Plugins/UltiSnips") }
		end,
		event = "InsertEnter",
	},
	-- Add a snippet collection like vim-snippets
	-- {
	-- 	"honza/vim-snippets",
	-- 	lazy = true, -- Load this plugin lazily
	-- },
	-- HACK: for inscape config
	{
		"rpapallas/illustrate.nvim", -- Plugin for managing illustrations
		dependencies = {
			"rcarriga/nvim-notify", -- Notification plugin for Neovim
			"nvim-lua/plenary.nvim", -- Lua functions library, required by many plugins
			"nvim-telescope/telescope.nvim", -- Fuzzy finder plugin
		},
		keys = function()
			local illustrate = require("illustrate") -- Load illustrate module
			local illustrate_finder = require("illustrate.finder") -- Load illustrate finder module
			return {
				{
					"<leader>is", -- create and open a new SVG file
					function()
						illustrate.create_and_open_svg()
					end,
					desc = "Create and open a new SVG file with provided name.",
				},
				{
					"<leader>ia", -- create and open a new Adobe Illustrator file
					function()
						illustrate.create_and_open_ai()
					end,
					desc = "Create and open a new Adobe Illustrator file with provided name.",
				},
				{
					"<leader>io", -- open a file under the cursor
					function()
						illustrate.open_under_cursor()
					end,
					desc = "Open file under cursor (or file within environment under cursor).",
				},
				{
					"<leader>if", -- search and open illustrations using Telescope
					function()
						illustrate_finder.search_and_open()
					end,
					desc = "Use telescope to search and open illustrations in default app.",
				},
				{
					"<leader>ic", -- search, copy, and open illustrations using Telescope
					function()
						illustrate_finder.search_create_copy_and_open()
					end,
					desc = "Use telescope to search existing file, copy it with new name, and open it in default app.",
				},
				-- {
				--   '<leader>ii', -- Illustration actions
				--   {
				--     { 's', illustrate.create_and_open_svg, desc = 'Create and open a new SVG file' },
				--     { 'a', illustrate.create_and_open_ai, desc = 'Create and open a new AI file' },
				--     { 'o', illustrate.open_under_cursor, desc = 'Open file under cursor' },
				--     { 'f', illustrate_finder.search_and_open, desc = 'Search and open illustrations' },
				--     { 'c', illustrate_finder.search_create_copy_and_open, desc = 'Search, copy, and open illustrations' },
				--   },
				-- },
			}
		end,
		opts = {
			-- Optional configuration options for the illustrate plugin
		},
		-- Custom command to convert SVG to PDF
		--vim.api.nvim_create_user_command('ConvertSvgToPdf', function()
		--    local svg_file = vim.fn.expand '%:p:r' .. '.svg'
		--    local pdf_file = vim.fn.expand '%:p:r' .. '.pdf'
		--    local cmd = 'inkscape ' .. svg_file .. ' --export-type=pdf --export-filename=' .. pdf_file
		--    os.execute(cmd)
		--    print('Converted ' .. svg_file .. ' to ' .. pdf_file)
		--  end, { nargs = 0 })
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
		config = function()
			-- require("render-markdown").setup()
			require("render-markdown").setup({ latex = { enabled = false } })
		end,
	},
	-- Image previewer in nvim
	{
		"3rd/image.nvim",
		dependencies = {
			"leafo/magick",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("image").setup({
				-- backend = 'ueberzug',
				backend = "kitty",
				kitty_method = "normal",
				integrations = {
					markdown = {
						enabled = true,
						clear_in_insert_mode = true,
						download_remote_images = true,
						only_render_image_at_cursor = true,
						filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
					},
					neorg = {
						enabled = true,
						clear_in_insert_mode = false,
						download_remote_images = true,
						only_render_image_at_cursor = false,
						filetypes = { "norg" },
					},
					html = {
						enabled = false,
					},
					css = {
						enabled = false,
					},
				},
				max_width = nil,
				max_height = nil,
				-- max_width_window_percentage = nil,
				-- max_height_window_percentage = 50,
				max_height_window_percentage = math.huge,
				max_width_window_percentage = math.huge,
				-- toggles images when windows are overlapped
				window_overlap_clear_enabled = false,
				window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
				-- auto show/hide images when the editor gains/looses focus
				editor_only_render_when_focused = false,
				-- render image files as images when opened
				hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
			})
		end,
		--    priority = 1000,
	},
	{ -- Goto Preview
		"rmagatti/goto-preview",
		event = "BufEnter",
		dependencies = "rmagatti/logger.nvim",
		config = function()
			require("goto-preview").setup({
				default_mappings = true,
			})
			-- Optionally, set custom key mappings if you prefer
			vim.keymap.set(
				"n",
				"gpd",
				"<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
				{ noremap = true, silent = true }
			)
			vim.keymap.set(
				"n",
				"gpr",
				"<cmd>lua require('goto-preview').goto_preview_references()<CR>",
				{ noremap = true, silent = true }
			)
			vim.keymap.set(
				"n",
				"gpi",
				"<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
				{ noremap = true, silent = true }
			)
			vim.keymap.set(
				"n",
				"gP",
				"<cmd>lua require('goto-preview').close_all_win()<CR>",
				{ noremap = true, silent = true }
			)
		end,
	},
	-- tiny-inline-diagnostic.nvim
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy", -- Or `LspAttach`
		priority = 1000, -- needs to be loaded in first
		config = function()
			vim.diagnostic.config({ virtual_text = false })
			require("Plugins.tiny-inline-diagnostic").setup()
		end,
	},
	-- {
	-- 	"mattn/emmet-vim",
	-- 	config = function()
	-- 		vim.g.user_emmet_leader_key = ","
	-- 	end,
	-- },
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup({ "html", "css" })
		end,
	},
	{
		"mg979/vim-visual-multi",
		event = "VeryLazy",
		-- config = function()
		-- require('vim-visual-multi').setup({ keybinds = {} })
		-- end,
	},
	{
		"NStefan002/screenkey.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("screenkey").setup({
				show_leader = true, -- Show the leader key in mappings
				clear_after = 2, -- Clear the display after 2 seconds of inactivity
				compress_after = 3, -- Compress repeated keystrokes after 3 repetitions
				-- hl_groups = {
				-- 	["screenkey.hl.key"] = { link = "DiffAdd" },
				-- 	["screenkey.hl.map"] = { link = "DiffDelete" },
				-- },
			})
		end,
	},
	require("Plugins.tiny-code-action"),
	require("Plugins.rust.crates"),
	require("Plugins.rust.rust-vim"),
	-- TODO:
	-- {
	-- 	"simrat39/rust-tools.nvim",
	-- 	ft = "rust",
	-- },
	-- {
	--   'mfusseneggger/nvim-dap',
	-- },
	-- {
	-- hrsh7th/nvim-cmp",
	--  table.insert(M.sources, {name = 'crates"}))
	-- },
	-- project wise search
	--{
	-- 'mileszs/ack.vim'
	-- }
	require("Plugins.statusline"),
	require("Plugins.debug"),
	require("Plugins.indent_line"),
	require("Plugins.lint"),
	require("Plugins.autopairs"),
	require("Plugins.gitsigns"), -- adds gitsigns recommend keymaps
}, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
