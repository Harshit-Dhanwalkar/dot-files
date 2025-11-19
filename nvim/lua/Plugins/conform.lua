-- ~/.config/nvim/lua/Plugins/conform.lua
-- Autoformatter
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	config = function()
		require("conform").setup({
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
				html = { "prettier" }, -- html_beautify
				less = { "prettier" },
				jsonc = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" }, -- mdformat, mdsf (for code blocks)
				["markdown.mdx"] = { "prettier" },
				tex = { "tex-fmt" },
				rust = { "rustfmt", lsp_format = "fallback" },
				java = { "google-java-format", lsp_format = "fallback" },
				-- julia = { "runic" },
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
		})
	end,
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({
					async = true,
					timeout_ms = 3000,
					lsp_fallback = true,
					-- formatting_options = { tabSize = 2 },
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
}
