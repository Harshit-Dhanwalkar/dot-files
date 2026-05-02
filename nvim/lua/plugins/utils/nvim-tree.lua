-- ~/.config/nvim/lua/plugins/utils/nvim-tree.lua

return {
	"nvim-tree/nvim-tree.lua",
	lazy = false,
	cmd = { "NvimTreeToggle", "NvimTreeFocus" },
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		require("nvim-tree").setup({
			disable_netrw = true,
			hijack_netrw = true,
			sort_by = "case_sensitive",
			sync_root_with_cwd = true,
			view = {
				side = "right",
				width = 32,
				number = false,
				relativenumber = false,
				cursorline = true,
			},
			-- Directory fold icons
			renderer = {
				group_empty = true,
				highlight_git = true,
				highlight_opened_files = "all",
				-- root_folder_label = ":t",
				indent_width = 2,
				indent_markers = {
					enable = true,
					inline_arrows = true,
					icons = { corner = "╰", edge = "│", item = "├", bottom = "─", none = " " },
				},
				icons = {
					padding = " ",
					git_placement = "signcolumn",
					-- web_devicons = {
					-- 	file = {
					-- 		enable = true,
					-- 		color = true,
					-- 	},
					-- 	folder = {
					-- 		enable = true,
					-- 		color = true,
					-- 	},
					-- },
					glyphs = {
						default = "󰈙",
						symlink = "",
						bookmark = "󰆤",
						folder = {
							default = "󰉋",
							empty = "󰉖",
							empty_open = "󰷏",
							open = "󰝰",
							symlink = "󰉒",
							symlink_open = "󰉒",
							arrow_closed = "→",
							arrow_open = "↓",
						},
					},
				},
				special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md", "package.json" },
			},
			git = { enable = true, ignore = false },
			-- git = {
			-- 	unstaged = "●",
			-- 	staged = "✓",
			-- 	unmerged = "",
			-- 	renamed = "~",
			-- 	untracked = "◌",
			-- 	deleted = "󰍵",
			-- 	ignored = "◌",
			-- },
			filters = { dotfiles = false, custom = { "^.git$", "node_modules", ".cache" } },
			actions = { open_file = { quit_on_open = false, window_picker = { enable = true } } },
		})
	end,
}
