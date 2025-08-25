local map = vim.keymap.set
-- space leader key
vim.g.mapleader = " "

-- buffers
map("n", "<leader>j", ":bn<cr>")
map("n", "<leader>k", ":bp<cr>")
map("n", "<leader>x", ":bd<cr>")

-- yank to clipboard
map({ "n", "v" }, "<leader>y", [["+y]])

-- Formatting
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true })

-- Split window
map("n", "ss", ":split<Return>", opts)
map("n", "sv", ":vsplit<Return>", opts)

-- Move window
map("n", "sh", "<C-w>h")
map("n", "sk", "<C-w>k")
map("n", "sj", "<C-w>j")
map("n", "sl", "<C-w>l")

--Resize window
map("n", "<C-w><left>", "<C-w><")

-- scrolling remaps
--mapset('n', '<C-j>', 'C-d>zz')
--mapset('n', '<C-k>', 'C-u>zz')

-- automatically close brackets, parentesis and quates
-- map('i', "'", "''<left>")
-- map('i', '"', '""<left>')
-- map('i', '(', '()<left>')
-- map('i', '[', '[]<left>')

-- map <leader>o to preview in Okular
-- map('i', '--[', '-- [\n\n-- ]<Esc>ki\t', { noremap = true, silent = true })
-- map('i', '/*', '/**/<left><left>')

-- move line up and down
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

vim.api.nvim_set_keymap("n", "<leader>o", ":PreviewOkular<CR>", { noremap = true, silent = true })
