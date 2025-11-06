-- ~/.config/nvim/lua/Plugins/keymaps.lua
-- Telescope keymaps
-- See `:help telescope.builtin`
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })

vim.keymap.set("n", "<leader>/", function()
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>s/", function()
	builtin.live_grep({
		grep_open_files = true,
		prompt_title = "Live Grep in Open Files",
	})
end, { desc = "[S]earch [/] in Open Files" })

vim.keymap.set("n", "<leader>sn", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

-- Nimtree
--vim.keymap.set('n', '<leader>e', ':NvimTreeFindFileToggle<cr>')
vim.api.nvim_set_keymap("n", "\\", ":NvimTreeFindFileToggle<cr>", { noremap = true, silent = true })

-- nvim-comments
vim.keymap.set({ "n", "v" }, "<leader>gc", ":CommentToggle<cr>")

-- neoclip
vim.keymap.set("n", "<leader>p", function()
	require("telescope").extensions.neoclip.default()
end, { desc = "Neoclip (Paste History)" })

-- vimtex
vim.keymap.set({ "n", "v" }, "<leader>lt", ":VimtexTocToggle<cr>")
vim.keymap.set("n", "<leader>ll", ":VimtexCompile<CR>", opts) -- Start compilation
vim.keymap.set("n", "<leader>lk", ":VimtexStop<CR>", opts) -- Stop compilation
vim.keymap.set("n", "<leader>lc", ":VimtexClean<CR>", opts) -- Clean aux files
vim.keymap.set("n", "<leader>lC", ":VimtexClean!<CR>", opts) -- Full clean
vim.keymap.set("n", "<leader>lv", ":VimtexView<CR>", opts) -- Open PDF viewer
vim.keymap.set("n", "<leader>li", ":VimtexInfo<CR>", opts) -- Show project info
vim.keymap.set("n", "<leader>lo", ":VimtexCompileOutput<CR>", opts) -- Compilation output
vim.keymap.set("n", "<leader>ls", ":VimtexStatus<CR>", opts) -- Status
vim.keymap.set("n", "<leader>le", ":VimtexErrors<CR>", opts) -- Errors
vim.keymap.set("n", "<leader>llq", ":VimtexLog<CR>", opts) -- Log messages
vim.keymap.set("n", "<leader>lf", ":VimtexForward<CR>", opts) -- Forward search
vim.keymap.set("n", "<leader>lb", ":VimtexBackward<CR>", opts) -- Backward search

-- noice dissmiss notification
vim.keymap.set("n", "<leader>nd", "<cmd>NoiceDissmiss<CR>", { desc = "Dissmiss Noice Misseage" })

-- -- tiny-code-action.nvim
-- vim.keymap.set({ "n", "x" }, "<leader>ca", function()
-- 	require("tiny-code-action").code_action()
-- end, { noremap = true, silent = true })
--
-- Screenkey keymaps
vim.keymap.set("n", "<leader>so", ":Screenkey toggle<CR>", { desc = "Toggle screenkey" })
