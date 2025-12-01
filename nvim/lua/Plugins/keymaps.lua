-- ~/.config/nvim/lua/Plugins/keymaps.lua

local map = vim.keymap.set

-- Telescope keymaps
-- See `:help telescope.builtin`
local builtin = require("telescope.builtin")
map("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
map("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
map("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
map("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
map("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
map("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
map("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
map("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
map("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
map("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })

-- telescope grep string
map("n", "<leader>g", "<cmd>Telescope live_grep<cr>")

-- telescope extensions
map("n", "<leader>ff", function()
	require("telescope").extensions.frecency.frecency()
end, { desc = "Find Files (Frecency)" })
map("n", "<leader>gh", function()
	require("telescope").extensions.heading.heading()
end, { desc = "Telescope: Go to Heading" })

map("n", "<leader>/", function()
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
		winblend = 10,
		previewer = false,
	}))
end, { desc = "[/] Fuzzily search in current buffer" })

map("n", "<leader>s/", function()
	builtin.live_grep({
		grep_open_files = true,
		prompt_title = "Live Grep in Open Files",
	})
end, { desc = "[S]earch [/] in Open Files" })

map("n", "<leader>sn", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

-- Nvimtree
--map('n', '<leader>e', ':NvimTreeFindFileToggle<cr>')
map("n", "\\", ":NvimTreeFindFileToggle<cr>", { noremap = true, silent = true })

-- Nvim-comments
map({ "n", "v" }, "<leader>gc", ":CommentToggle<cr>")

-- Neoclip
map("n", "<leader>p", function()
	require("telescope").extensions.neoclip.default()
end, { desc = "Neoclip (Paste History)" })

-- Vimtex
local opts = { noremap = true, silent = true }
map({ "n", "v" }, "<leader>lt", ":VimtexTocToggle<cr>")
map("n", "<leader>ll", ":VimtexCompile<CR>", opts) -- Start compilation
map("n", "<leader>lk", ":VimtexStop<CR>", opts) -- Stop compilation
map("n", "<leader>lc", ":VimtexClean<CR>", opts) -- Clean aux files
map("n", "<leader>lC", ":VimtexClean!<CR>", opts) -- Full clean
map("n", "<leader>lv", ":VimtexView<CR>", opts) -- Open PDF viewer
map("n", "<leader>li", ":VimtexInfo<CR>", opts) -- Show project info
map("n", "<leader>lo", ":VimtexCompileOutput<CR>", opts) -- Compilation output
map("n", "<leader>ls", ":VimtexStatus<CR>", opts) -- Status
map("n", "<leader>le", ":VimtexErrors<CR>", opts) -- Errors
map("n", "<leader>llg", ":VimtexLog<CR>", opts) -- Log messages
map("n", "<leader>lf", ":VimtexForward<CR>", opts) -- Forward search
map("n", "<leader>lb", ":VimtexBackward<CR>", opts) -- Backward search

-- Peek
-- map("n", "<leader>md", ":PeekOpen<CR>")
-- map("n", "<leader>mx", ":PeekClose<CR>")

-- Noice dissmiss notification
map("n", "<leader>nd", "<cmd>NoiceDissmiss<CR>", { desc = "Dissmiss Noice Misseage" })

-- Tiny-code-action.nvim
map({ "n", "x" }, "<leader>ca", function()
	require("tiny-code-action").code_action()
end, { noremap = true, silent = true, desc = "Code Action" })

-- Screenkey keymaps
-- map("n", "<leader>so", ":Screenkey toggle<CR>", { desc = "Toggle screenkey" })
