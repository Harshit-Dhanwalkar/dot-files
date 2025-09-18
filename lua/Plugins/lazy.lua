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
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			-- Enable the following language servers
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
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
			-- :Mason --  You can press `g?` for help in this menu.
			require("mason").setup()
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- format Lua code
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	require("Plugins.autoformat"),
	require("Plugins.autocomplete"),
	require("Plugins.colorscheme"),
	require("Plugins.todo-comments"),
	require("Plugins.mini"),
	require("Plugins.telescope"),
	require("Plugins.nvim-tree"),
	-- require("Plugins.neotree"),
	require("Plugins.bufferline"),
	require("Plugins.comment"),
	require("Plugins.noice"),
	require("Plugins.vimtex"),
	-- {
	-- 	"sirver/ultisnips",
	-- 	config = function()
	-- 		vim.g.UltiSnipsExpandTrigger = -"<tab>"
	-- 		vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
	-- 		vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
	-- 		vim.g.UltiSnipsSnippetDirectories = { vim.fn.expand("~/.config/nvim/lua/Plugins/UltiSnips") }
	-- 	end,
	-- 	event = "InsertEnter",
	-- },
	-- Add a snippet collection like vim-snippets
	-- {
	-- 	"honza/vim-snippets",
	-- 	lazy = true, -- Load this plugin lazily
	-- },
	require("Plugins.render-markdown"),
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
	require("Plugins.vim-visual-multi"),
	require("Plugins.tiny-inline-diagnostic"),
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
	require("Plugins.indent-blackline"),
	require("Plugins.lint"),
	require("Plugins.autopairs"),
	require("Plugins.gitsigns"),
	-- require("Plugins.screenkey"),
	-- require("Plugins.webdev.emmet"),
	require("Plugins.webdev.colorizer"),
	require("Plugins.illustrate"),
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
