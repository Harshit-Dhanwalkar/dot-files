local map = vim.keymap.set

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Use nerd font for icons
vim.g.have_nerd_font = true

-- Remove flickering in the statusline when saving a file
-- map("n", ":w", "<cmd>silent write<cr>") -- fixed by noice plugin

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
map("n", "<leader>.", ":bn<cr>")
map("n", "<leader>,", ":bp<cr>")
map("n", "<leader>x", ":bd<cr>")

-- Yank to clipboard
map({ "n", "v" }, "<leader>y", [["+y]])

-- Formatting
map("n", "<leader>f", "<cmd>lua vim.lsp.buf.format()<CR>", { noremap = true, silent = true })

-- Split window
map("n", "ss", ":split<Return>", opts)
map("n", "sv", ":vsplit<Return>", opts)

-- Move window
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

--Resize window
map("n", "<C-w><left>", "<C-w><")
map("n", "<A-k>", ":resize +2<CR>")
map("n", "<A-j>", ":resize -2<CR>")
map("n", "<A-l>", ":vertical resize +2<CR>")
map("n", "<A-h>", ":vertical resize -2<CR>")

-- insert mode keymaps
map("i", "<C-c>", "<Esc>", { noremap = true, silent = true })

-- Scrolling remaps
--mapset('n', '<C-j>', 'C-d>zz')
--mapset('n', '<C-k>', 'C-u>zz')

-- Automatically close brackets, parentesis and quotes
-- map('i', "'", "''<left>")
-- map('i', '"', '""<left>')
-- map('i', '(', '()<left>')
-- map('i', '[', '[]<left>')

-- Better navigation with wrap support
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move line up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Make previous word first's char caps
map("n", "<leader>t", "bv~")

-- tabs
map("n", "tn", ":tabn<CR>")
map("n", "tp", ":tabp<CR>")
map("n", "td", ":tabclose<CR>")

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- center after search
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- close all quickfix, loclist and diagnostic
-- map("n", "<leader>ca", ":cclose<CR>:lclose<CR>", { desc = "Close All Quickfix/Loclist" })

-- LSP setup
-- local map = function(keys, func, desc, mode)
-- 	mode = mode or "n"
-- 	vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
-- end
map("n", "K", vim.lsp.buf.hover)
map("n", "gd", vim.lsp.buf.definition)
map("n", "gD", vim.lsp.buf.declaration)
map({ "n", "v" }, "<leader>gc", ":CommentToggle<cr>", { desc = "Toggle Comment" })
-- map("n", "gr", vim.lsp.buf.references, {})
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
end, { desc = "Go to [R]eferences" })
map("n", "<leader>e", vim.diagnostic.open_float)

-- move to end of word while keeping the cursor in the same column for the next line
map("n", "k", "gk")
map("n", "j", "gj")

-- Go to errors
map("n", "[e", vim.diagnostic.goto_next)
map("n", "]e", vim.diagnostic.goto_next)

-- Folding Keymaps
map("n", "za", "za", { desc = "[Z]old [A]lternate/Toggle fold" })
map("n", "zc", "zc", { desc = "[Z]old [C]lose fold" })
map("n", "zo", "zo", { desc = "[Z]old [O]pen fold" })
map("n", "zM", "zM", { desc = "[Z]old [M]ore: Close ALL folds" })
map("n", "zR", "zR", { desc = "[Z]old [R]eveal: Open ALL folds" })
map("n", "zC", "zC", { desc = "[Z]old [C]lose fold recursively" })

-- disable vimtex maps
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_view_method = "skim"

-- Custom utilities
-- Datejumps
do
	local datejumps = require("utilities.datejumps")

	map("n", "]d", datejumps.next_date, { desc = "Jump to Next Date (DD/MM/YYYY)" })
	map("n", "[d", datejumps.prev_date, { desc = "Jump to Previous Date (DD/MM/YYYY)" })
end

-- Open pdf in zathura
require("utilities.openpdf")
map("n", "<leader>oz", ":ZathuraOpen<CR>", { desc = "Open PDF in Zathura" })
