-- ~/.config/nvim/lua/plugins/lsp/nvim-lspconfig.lua
vim.lsp.set_log_level("error") -- Only log actual crashes/errors
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/nvim-cmp",
		"j-hui/fidget.nvim",
	},
	config = function()
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
		require("mason").setup()
		require("mason-tool-installer").setup({ ensure_installed = tools })

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

		-- --  Completion
		-- local cmp = require("cmp")
		--
		-- -- some icons
		-- local kind_icons = {
		-- 	Text = "",
		-- 	Method = "m",
		-- 	Function = "",
		-- 	Constructor = "",
		-- 	Field = "",
		-- 	Variable = "",
		-- 	Class = "",
		-- 	Interface = "",
		-- 	Module = "",
		-- 	Property = "",
		-- 	Unit = "",
		-- 	Value = "",
		-- 	Enum = "",
		-- 	Keyword = "",
		-- 	Snippet = "",
		-- 	Color = "",
		-- 	File = "",
		-- 	Reference = "",
		-- 	Folder = "",
		-- 	EnumMember = "",
		-- 	Constant = "",
		-- 	Struct = "",
		-- 	Event = "",
		-- 	Operator = "",
		-- 	TypeParameter = "",
		-- }
		-- -- find more here: https://www.nerdfonts.com/cheat-sheet
		--
		-- cmp.setup({
		-- 	sources = {
		-- 		{ name = "nvim_lsp" },
		-- 	},
		--
		-- 	mapping = {
		-- 		["<C-k>"] = cmp.mapping.select_prev_item(),
		-- 		["<C-j>"] = cmp.mapping.select_next_item(),
		-- 		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
		-- 		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
		-- 		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		-- 		["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
		-- 		["<C-e>"] = cmp.mapping({
		-- 			i = cmp.mapping.abort(),
		-- 			c = cmp.mapping.close(),
		-- 		}),
		-- 		-- Accept currently selected item. If none selected, `select` first item.
		-- 		-- Set `select` to `false` to only confirm explicitly selected items.
		-- 		["<CR>"] = cmp.mapping.confirm({ select = false }),
		-- 		["<Tab>"] = cmp.mapping(function(fallback)
		-- 			if cmp.visible() then
		-- 				cmp.select_next_item()
		-- 			else
		-- 				fallback()
		-- 			end
		-- 		end, {
		-- 			"i",
		-- 			"s",
		-- 		}),
		-- 		["<S-Tab>"] = cmp.mapping(function(fallback)
		-- 			if cmp.visible() then
		-- 				cmp.select_prev_item()
		-- 			else
		-- 				fallback()
		-- 			end
		-- 		end, {
		-- 			"i",
		-- 			"s",
		-- 		}),
		-- 	},
		--
		-- 	formatting = {
		-- 		fields = { "kind", "abbr", "menu" },
		-- 		format = function(entry, vim_item)
		-- 			-- Kind icons
		-- 			vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
		-- 			-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
		-- 			vim_item.menu = ({
		-- 				nvim_lsp = "[LSP]",
		-- 				--nvim_lsp_signature_help = "[LSP-Signature]",
		-- 				buffer = "[Buffer]",
		-- 				path = "[Path]",
		-- 			})[entry.source.name]
		-- 			return vim_item
		-- 		end,
		-- 	},
		-- })
	end,
}
