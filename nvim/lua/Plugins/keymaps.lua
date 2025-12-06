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
map("n", "<leader>g", "<cmd>Telescope live_grep<cr>", { desc = "[G]rep (Live Search)" })

-- telescope extensions
map("n", "<leader>fq", function()
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
map("n", "\\", ":NvimTreeFindFileToggle<cr>", { noremap = true, silent = true, desc = "[\\ ] Toggle NvimTree" })

-- Nvim-comments
map({ "n", "v" }, "<leader>gc", ":CommentToggle<cr>", { desc = "[G]lobal [C]omment Toggle" })

-- Neoclip
map("n", "<leader>p", function()
	require("telescope").extensions.neoclip.default()
end, { desc = "Neoclip (Paste History)" })

-- Vimtex
local opts = { noremap = true, silent = true }
map({ "n", "v" }, "<leader>lt", ":VimtexTocToggle<cr>", { desc = "[L]aTeX [T]oc Toggle" })
map("n", "<leader>ll", ":VimtexCompile<CR>", vim.tbl_deep_extend("force", opts, { desc = "[L]aTeX [L]ive Compile" }))
map("n", "<leader>lk", ":VimtexStop<CR>", vim.tbl_deep_extend("force", opts, { desc = "[L]aTeX Stop [K]ompiling" }))
map("n", "<leader>lc", ":VimtexClean<CR>", vim.tbl_deep_extend("force", opts, { desc = "[L]aTeX [C]lean aux files" }))
map("n", "<leader>lC", ":VimtexClean!<CR>", vim.tbl_deep_extend("force", opts, { desc = "[L]aTeX [C]lean full" }))
map("n", "<leader>lv", ":VimtexView<CR>", vim.tbl_deep_extend("force", opts, { desc = "[L]aTeX [V]iew PDF" }))
map("n", "<leader>li", ":VimtexInfo<CR>", vim.tbl_deep_extend("force", opts, { desc = "[L]aTeX [I]nfo" }))
map(
	"n",
	"<leader>lo",
	":VimtexCompileOutput<CR>",
	vim.tbl_deep_extend("force", opts, { desc = "[L]aTeX Compile [O]utput" })
)
map("n", "<leader>ls", ":VimtexStatus<CR>", vim.tbl_deep_extend("force", opts, { desc = "[L]aTeX [S]tatus" }))
map("n", "<leader>le", ":VimtexErrors<CR>", vim.tbl_deep_extend("force", opts, { desc = "[L]aTeX [E]rrors" }))
map("n", "<leader>llg", ":VimtexLog<CR>", vim.tbl_deep_extend("force", opts, { desc = "[L]aTeX [L]og" }))
map("n", "<leader>lf", ":VimtexForward<CR>", vim.tbl_deep_extend("force", opts, { desc = "[L]aTeX [F]orward Search" }))
map(
	"n",
	"<leader>lb",
	":VimtexBackward<CR>",
	vim.tbl_deep_extend("force", opts, { desc = "[L]aTeX [B]ackward Search" })
)

-- Peek
-- map("n", "<leader>md", ":PeekOpen<CR>")
-- map("n", "<leader>mx", ":PeekClose<CR>")

-- Noice dissmiss notification
map("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "[N]oice [D]ismiss Message" })

-- Tiny-code-action.nvim
map({ "n", "x" }, "<leader>ca", function()
	require("tiny-code-action").code_action()
end, { noremap = true, silent = true, desc = "Code Action" })

-- Screenkey keymaps
-- map("n", "<leader>so", ":Screenkey toggle<CR>", { desc = "Toggle screenkey" })
