-- ~/.config/nvim/lua/Plugins/rust/rust-tools.lua
return {
	"simrat39/rust-tools.nvim",
	ft = "rust",
	opts = {
		server = {
			-- standalone = true, -- rust-analyzer options
			on_attach = function(_, bufnr)
				-- Hover actions
				vim.keymap.set("n", "<C-space>", function()
					require("rust-tools.hover_actions").hover_actions()
				end, { buffer = bufnr })
				-- Code action groups
				vim.keymap.set("n", "<Leader>a", function()
					require("rust-tools.code_action_group").code_action_group()
				end, { buffer = bufnr })
			end,
		},
		dap = {
			adapter = {
				type = "executable",
				command = "lldb-vscode",
				name = "rt_lldb",
			},
		},
		tools = {
			-- 	executor = require("rust-tools.executors").termopen,
			on_initialized = nil,
			reload_workspace_from_cargo_toml = true,
			-- 	inlay_hints = {
			-- 		auto = true,
			-- 		only_current_line = false,
			-- 		show_parameter_hints = true,
			-- 		parameter_hints_prefix = "<- ",
			-- 		other_hints_prefix = "=> ",
			-- 		max_len_align = false,
			-- 		max_len_align_padding = 1,
			-- 		right_align = false,
			-- 		right_align_padding = 7,
			-- 		highlight = "Comment",
			-- 	},
			crate_graph = {
				backend = "x11",
				output = nil,
				full = true,
				enabled_graphviz_backends = {
					"bmp",
					"cgimage",
					"canon",
					"dot",
					"gv",
					"xdot",
					"xdot1.2",
					"xdot1.4",
					"eps",
					"exr",
					"fig",
					"gd",
					"gd2",
					"gif",
					"gtk",
					"ico",
					"cmap",
					"ismap",
					"imap",
					"cmapx",
					"imap_np",
					"cmapx_np",
					"jpg",
					"jpeg",
					"jpe",
					"jp2",
					"json",
					"json0",
					"dot_json",
					"xdot_json",
					"pdf",
					"pic",
					"pct",
					"pict",
					"plain",
					"plain-ext",
					"png",
					"pov",
					"ps",
					"ps2",
					"psd",
					"sgi",
					"svg",
					"svgz",
					"tga",
					"tiff",
					"tif",
					"tk",
					"vml",
					"vmlz",
					"wbmp",
					"webp",
					"xlib",
					"x11",
				},
			},
		},
	},
}
