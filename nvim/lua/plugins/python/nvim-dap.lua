-- ~/.config/nvim/lua/Plugins/python/nvim-dap.lua

return {
	"mfussenegger/nvim-dap",
	optional = true,
	dependencies = {
		"mfussenegger/nvim-dap-python",
		keys = {
			{
				"<leader>dPt",
				function()
					require("dap-python").test_method()
				end,
				desc = "Debug Method",
				ft = "python",
			},
			{
				"<leader>dPc",
				function()
					require("dap-python").test_class()
				end,
				desc = "Debug Class",
				ft = "python",
			},
		},

		config = function()
			local mason_registry = require("mason-registry")

			-- Check if debugpy is installed via Mason
			if mason_registry.is_installed("debugpy") then
				local pkg = mason_registry.get_package("debugpy")
				local install_path = pkg:get_install_path()

				local python_path
				if vim.fn.has("win32") == 1 then
					python_path = install_path .. "/venv/Scripts/pythonw.exe"
				else
					python_path = install_path .. "/venv/bin/python"
				end

				require("dap-python").setup(python_path)
			else
				-- Fallback to system python if Mason package isn't found
				require("dap-python").setup("python3")
			end
		end,
	},
}
