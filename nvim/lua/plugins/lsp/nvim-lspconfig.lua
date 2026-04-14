-- ~/.config/nvim/lua/plugins/lsp/nvim-lspconfig.lua
-- local icons = require("utils.icons") --FIX: fix path
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/nvim-cmp",
		"j-hui/fidget.nvim",
		"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
		"smjonas/inc-rename.nvim",
		"ravibrock/spellwarn.nvim",
		-- "dgagn/diagflow.nvim",
	},
	config = function()
		-- vim.fn.sign_define("DiagnosticSignError", {
		-- 	text = icons.diagnostics.error,
		-- 	texthl = "DiagnosticSignError",
		-- })
		-- vim.fn.sign_define("DiagnosticSignWarn", {
		-- 	text = icons.diagnostics.warning,
		-- 	texthl = "DiagnosticSignWarn",
		-- })
		-- vim.fn.sign_define("DiagnosticSignHint", {
		-- 	text = icons.diagnostics.hint,
		-- 	texthl = "DiagnosticSignHint",
		-- })
		-- vim.fn.sign_define("DiagnosticSignInfo", {
		-- 	text = icons.diagnostics.information,
		-- 	texthl = "DiagnosticSignInfo",
		-- })
		-- Only log actual crashes/errors
		vim.lsp.set_log_level("error") -- 'trace', 'debug', 'info', 'warn', 'error'

		local lsp_modules = require("plugins.lsp.languages")
		local servers = lsp_modules.servers
		local tools = lsp_modules.tools

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
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
							vim.api.nvim_clear_autocmds({ group = highlight_augroup, buffer = event2.buf })
						end,
					})

					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = event.buf,
						callback = function()
							-- This prevents the default LSP formatting
							-- Do nothing - let conform handle it
						end,
					})
				end

				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end

				local diag_config = {
					virtual_text = true, -- appears after the line
					virtual_lines = false, -- appears under the line
					update_in_insert = false,
					underline = true,
					severity_sort = true,
					float = {
						focus = false,
						focusable = false,
						style = "minimal",
						border = "shadow",
						source = "always",
						header = "",
						prefix = "",
					},
					signs = {
						text = {
							[vim.diagnostic.severity.ERROR] = "✘",
							[vim.diagnostic.severity.WARN] = "▲",
							[vim.diagnostic.severity.HINT] = "⚑",
							[vim.diagnostic.severity.INFO] = "»",
							-- FIX: after fixing icon path uncomment below and remove above 4 lines
							-- [vim.diagnostic.severity.ERROR] = icons.diagnostics.error,
							-- [vim.diagnostic.severity.WARN] = icons.diagnostics.warning,
							-- [vim.diagnostic.severity.HINT] = icons.diagnostics.hint,
							-- [vim.diagnostic.severity.INFO] = icons.diagnostics.information,
						},
					},
				}
				vim.diagnostic.config(diag_config)

				local border = { border = "shadow" }
				vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.hover, border)
				vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border)

				-- Global LSP defaults
				vim.lsp.config("*", {
					capabilities = vim.lsp.protocol.make_client_capabilities(),
					flags = {
						debounce_text_changes = 200,
						allow_incremental_sync = true,
					},
				})
			end,
		})

		local capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
			textDocument = {
				foldingRange = {
					dynamicRegistration = false,
					lineFoldingOnly = true,
				},
			},
		}, require("cmp_nvim_lsp").default_capabilities())

		-- Setup Mason and install tools from languages.lua
		-- local mason_ok, mason = pcall(require, "mason")
		-- local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
		-- if mason_ok and mason_lspconfig_ok then
		-- 	mason.setup()
		-- 	mason_lspconfig.setup({
		-- 		ensure_installed = tools,
		-- 		automatic_enable = true,
		-- 	})
		-- end
		require("mason").setup()
		require("mason-tool-installer").setup({ ensure_installed = tools, automatic_installation = true })

		-- Mason-LSPConfig Setup
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

					-- Special handling for clangd
					if server_name == "clangd" then
						-- Store the original on_attach if it exists
						local old_on_attach = server.on_attach
						server.on_attach = function(client, bufnr)
							client.server_capabilities.signatureHelpProvider = false
							if old_on_attach then
								old_on_attach(client, bufnr)
							end
						end
					end

					-- vim.lsp.start(server)
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})

		require("lsp_lines").setup()
		require("inc_rename").setup({
			hl_group = "Substitute",
			preview_empty_name = false,
			show_message = true,
			save_in_cmdline_history = false,
			-- input_buffer_type = "snacks",
		})
		require("spellwarn").setup()
		-- require("diagflow").setup({
		-- 	enable = true,
		-- 	max_width = 60,
		-- 	max_height = 10,
		-- 	severity_colors = {
		-- 		error = "DiagnosticFloatingError",
		-- 		warning = "DiagnosticFloatingWarn",
		-- 		info = "DiagnosticFloatingInfo",
		-- 		hint = "DiagnosticFloatingHint",
		-- 	},
		-- 	format = function(diagnostic)
		-- 		return diagnostic.message
		-- 	end,
		-- 	gap_size = 1,
		-- 	scope = "line", -- cursor/line
		-- 	padding_top = 2,
		-- 	padding_right = 1,
		-- 	text_align = "right",
		-- 	placement = "top",
		-- 	inline_padding_left = 0,
		-- 	toggle_event = {},
		-- 	show_sign = true,
		-- 	update_event = { "DiagnosticChanged", "BufReadPost" },
		-- 	render_event = { "DiagnosticChanged", "CursorMoved" },
		-- 	-- border_chars = icons.borders.diagflow,
		-- 	show_borders = true,
		-- })
	end,
}
