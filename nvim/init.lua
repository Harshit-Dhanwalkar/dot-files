fn = vim.fn
api = vim.api
cmd = vim.cmd
opt = vim.opt
g = vim.g

local modules = {
	"settings",
	"keymaps",
	"lazy-plugins",
	"plugins.keymaps",
}

for _, a in ipairs(modules) do
	local ok, err = pcall(require, a)
	if not ok then
		error("Error calling " .. a .. err)
	end
end

g.python3_host_prog = "/home/linuxbrew/.linuxbrew/bin/python3.11"
cmd("runtime! ftplugin/man.vim")

-- Auto commands
api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, {
	pattern = "term://*",
	command = "setlocal nonumber norelativenumber signcolumn=no | setfiletype term",
})

api.nvim_create_autocmd("BufEnter", {
	pattern = "term://*",
	command = "startinsert",
})

api.nvim_create_autocmd("VimLeave", {
	command = "set guicursor=a:ver20",
})
