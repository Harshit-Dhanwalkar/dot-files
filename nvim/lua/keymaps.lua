local map = vim.keymap.set

-- leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.have_nerd_font = true

--  See `:help lua-guide-autocommands` and `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- clear highlight after search with Esc
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- buffers
map("n", "<leader>,", ":bn<cr>")
map("n", "<leader>.", ":bp<cr>")
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

--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

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

-- Make previous word first's char caps
map("n", "<leader>t", "bv~")

vim.api.nvim_set_keymap("n", "<leader>o", ":PreviewOkular<CR>", { noremap = true, silent = true })

-- lsp setup
map("n", "K", vim.lsp.buf.hover)
map("n", "gd", vim.lsp.buf.definition)
map("n", "gD", vim.lsp.buf.declaration)
map("n", "gr", function()
	-- trigger the lsp references function and populate the quickfix list
	vim.lsp.buf.references()

	vim.defer_fn(function()
		-- set up an autocmd to remap keys in the quickfix window
		vim.api.nvim_create_autocmd("filetype", {
			pattern = "qf", -- only apply this mapping in quickfix windows
			callback = function()
				-- remap <enter> to jump to the location and close the quickfix window
				vim.api.nvim_buf_set_keymap(0, "n", "<cr>", "<cr>:cclose<cr>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_keymap(0, "n", "q", ":cclose<cr>", { noremap = true, silent = true })

				-- set up <tab> to cycle through quickfix list entries
				map("n", "<tab>", function()
					local current_idx = vim.fn.getqflist({ idx = 0 }).idx
					local qflist = vim.fn.getqflist() -- get the current quickfix list
					if current_idx >= #qflist then
						vim.cmd("cfirst")
						vim.cmd("wincmd p")
					else
						vim.cmd("cnext")
						vim.cmd("wincmd p")
					end
				end, { noremap = true, silent = true, buffer = 0 })

				map("n", "<s-tab>", function()
					local current_idx = vim.fn.getqflist({ idx = 0 }).idx
					if current_idx < 2 then
						vim.cmd("clast")
						vim.cmd("wincmd p")
					else
						vim.cmd("cprev")
						vim.cmd("wincmd p")
					end
				end, { noremap = true, silent = true, buffer = 0 })
			end,
		})
	end, 0)
end)

map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})

-- see error
map("n", "<leader>e", vim.diagnostic.open_float)

-- go to errors
map("n", "[e", vim.diagnostic.goto_next)
map("n", "]e", vim.diagnostic.goto_next)
