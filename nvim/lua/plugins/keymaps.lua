-- ~/.config/nvim/lua/plugins/keymaps.lua
local map = vim.keymap.set

local builtin = require("telescope.builtin")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
-- TODO:
-- local I = {} -- Table for "Injection" tools
-- -- Helper function to register tables
-- local function register_maps(map_table)
--     for _, map_item in ipairs(map_table) do
--         map(map_item[1], map_item[2], map_item[3], { desc = map_item[4] })
--     end
-- end
-- e.g.:
-- register_maps(I.python)
-- register_maps(I.git)

-- Nvimtree
--map('n', '<leader>e', ':NvimTreeFindFileToggle<cr>')
map("n", "\\", ":NvimTreeFindFileToggle<cr>", { noremap = true, silent = true, desc = "[\\ ] Toggle NvimTree" })
-- map("n", "\\", ":NeoTree<cr>", { noremap = true, silent = true, desc = "[\\ ] Toggle NeoTree" })

-- Nvim-comments
map({ "n", "v" }, "<leader>gc", ":CommentToggle<cr>", { desc = "[G]lobal [C]omment Toggle" })

-- Neoclip
map("n", "<leader>p", function()
	require("telescope").extensions.neoclip.default()
end, { desc = "Neoclip (Paste History)" })

-- Markdown
map("n", "<bs>", ":edit #<cr>", { silent = true }) -- follow-md-links

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

-- Telescope keymaps
-- See `:help telescope.builtin`
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
map("n", "<leader>g", "<cmd>Telescope live_grep<cr>", { desc = "[G]rep (Live Search)" })

-- Telescope extensions
map("n", "<leader>fq", function()
	require("telescope").extensions.frecency.frecency()
end, { desc = "Find Files (Frecency)" })
map("n", "<leader>gh", function()
	require("telescope").extensions.heading.heading()
end, { desc = "Telescope: Go to Heading" })

map("n", "<leader>/", function()
	builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ winblend = 15, previewer = false }))
end, { desc = "[/] Fuzzily search in current buffer" })

map("n", "<leader>s/", function()
	builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
end, { desc = "[S]earch [/] in Open Files" })

map("n", "<leader>sn", function()
	builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[S]earch [N]eovim files" })

-- Telescope Custom
map("n", "<leader>ip", function()
	require("telescope.builtin").find_files({
		prompt_title = "Insert File Path",
		cwd = vim.fn.getcwd(),
		attach_mappings = function(prompt_bufnr, map)
			actions.select_default:replace(function()
				actions.close(prompt_bufnr)
				local selection = action_state.get_selected_entry()
				local path = selection[1]
				vim.api.nvim_put({ path }, "", true, true)
			end)
			return true
		end,
	})
end, { desc = "[I]nsert [P]ath at cursor" })

-- TODO:
-- Mini keymaps

-- Tiny-term
-- Toggle shell terminal
vim.keymap.set("n", "<leader>m", function()
	require("tiny-term").toggle()
end, { desc = "Toggle terminal" })

-- -- Toggle terminal with count
-- vim.keymap.set("n", "<leader>.", function()
-- 	local count = vim.v.count1
-- 	require("tiny-term").toggle(nil, { count = count })
-- end, { desc = "Toggle terminal with count" })

-- FIX: error opening picker
-- $VIRTUAL_ENV or database URLs
map("n", "<leader>ie", function()
	local env_vars = {}
	for k, v in pairs(vim.fn.environ()) do
		table.insert(env_vars, string.format("%s=%s", k, v))
	end
	pickers
		.new({}, {
			prompt_title = "Environment Variables",
			finder = finders.new_table({ results = env_vars }),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					-- Extract only the value after the '='
					local value = selection[1]:match("=(.*)$")
					vim.api.nvim_put({ value }, "", true, true)
				end)
				return true
			end,
		})
		:find()
end, { desc = "[I]nsert [E]nv Variable" })

-- Venv Executable Picker
map("n", "<leader>iv", function()
	local env_vars = {}
	for k, v in pairs(vim.fn.environ()) do
		table.insert(env_vars, string.format("%s=%s", k, v))
	end
	pickers
		.new(require("telescope.themes").get_dropdown({}), {
			prompt_title = "Insert Env Value",
			finder = finders.new_table({ results = env_vars }),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					local value = selection[1]:match("=(.*)$")
					vim.schedule(function()
						if selection then
							local value = selection[1]:match("=(.*)$") or ""
							vim.api.nvim_put({ value }, "", true, true)
						end
					end)
				end)
				return true
			end,
		})
		:find()
end, { desc = "[I]nsert [E]nv Value" })

-- Insert boilerplate templates
-- map("n", "<leader>it", function()
-- 	local template_dir = vim.fn.expand("~/.config/nvim/templates/")
-- 	require("telescope.builtin").find_files({
-- 		cwd = template_dir,
-- 		attach_mappings = function(prompt_bufnr, _)
-- 			actions.select_default:replace(function()
-- 				local selection = action_state.get_selected_entry()
-- 				actions.close(prompt_bufnr)
-- 				local lines = vim.fn.readfile(template_dir .. selection[1])
-- 				vim.api.nvim_put(lines, "l", true, true)
-- 			end)
-- 			return true
-- 		end,
-- 	})
-- end, { desc = "[I]nsert [T]emplate" })

-- Import
map("n", "<leader>ii", function()
	require("telescope.builtin").find_files({
		prompt_title = "Insert Python Import",
		attach_mappings = function(prompt_bufnr, _)
			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				local path = selection[1]
				-- Convert path to python module notation
				local module = path:gsub("/", "."):gsub(".py$", "")
				vim.api.nvim_put({ "import " .. module }, "", true, true)
			end)
			return true
		end,
	})
end, { desc = "[I]nsert [I]mport statement" })

-- Insert its name for module from requirements.txt
map("n", "<leader>ir", function()
	local req_files = vim.fs.find("requirements.txt", {
		upward = true,
		stop = vim.loop.os_homedir(),
		path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
	})
	if #req_files == 0 then
		print("No requirements.txt found in project tree")
		return
	end
	local req_file = req_files[1]
	local lines = vim.fn.readfile(req_file)
	require("telescope.pickers")
		.new(require("telescope.themes").get_dropdown({}), {
			prompt_title = "Insert Requirement (from root)",
			finder = require("telescope.finders").new_table({ results = lines }),
			sorter = require("telescope.config").values.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					vim.api.nvim_put({ selection[1] }, "", true, true)
				end)
				return true
			end,
		})
		:find()
end, { desc = "[I]nsert [R]equirement from Root" })

-- Grab a class name from another file to write a type hint
map("n", "<leader>ic", function()
	require("telescope.builtin").lsp_dynamic_workspace_symbols({
		attach_mappings = function(prompt_bufnr, _)
			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				local text = selection.text or selection.display
				vim.api.nvim_put({ text }, "", true, true)
			end)
			return true
		end,
	})
end, { desc = "[I]nsert [S]ymbol" })

-- Choose preferred documentation style.
map("n", "<leader>id", function()
	local styles = {
		{
			name = "Google",
			lines = {
				'"""Summary.',
				"",
				"Args:",
				"    param1: Description.",
				"",
				"Returns:",
				"    Description.",
				'"""',
			},
		},
		{
			name = "NumPy",
			lines = {
				'"""Summary.',
				"",
				"Parameters",
				"----------",
				"param1 : type",
				"    Description.",
				"",
				"Returns",
				"-------",
				"type",
				"    Description.",
				'"""',
			},
		},
		{
			name = "Sphinx",
			lines = {
				'"""Summary.',
				"",
				":param param1: Description.",
				":type param1: type",
				":returns: Description.",
				":rtype: type",
				'"""',
			},
		},
	}
	vim.ui.select(styles, {
		prompt = "Select Docstring Style:",
		format_item = function(item)
			return item.name
		end,
	}, function(choice)
		if choice then
			vim.api.nvim_put(choice.lines, "l", true, true)
		end
	end)
end, { desc = "[I]nsert [D]ocstring" })

-- From models.py and cursor is on class User, find (or creates) tests/test_models.py and injects a test skeleton for that specific class.
map("n", "<leader>it", function()
	local ts_utils = require("nvim-treesitter.ts_utils")
	local node = ts_utils.get_node_at_cursor()
	while node and node:type() ~= "class_definition" do
		node = node:parent()
	end
	if node then
		local class_name = vim.treesitter.get_node_text(node:child(1), 0)
		local test_skeleton = {
			string.format("	  def test_%s_initialization():", class_name:lower()),
			string.format("      # TODO: Implement test for %s", class_name),
			"   assert True",
		}
		vim.api.nvim_put(test_skeleton, "l", true, true)
	else
		print("Cursor not inside a Python class")
	end
end, { desc = "[I]nsert [T]est Skeleton" })

map("n", "<leader>il", function()
	local ts_utils = require("nvim-treesitter.ts_utils")
	local node = ts_utils.get_node_at_cursor()
	-- Navigate up to find an identifier if we are on a sub-node
	while node and node:type() ~= "identifier" and node:type() ~= "attribute" do
		node = node:parent()
	end
	if not node then
		print("No valid Python variable found at cursor")
		return
	end
	local var_name = vim.treesitter.get_node_text(node, 0)
	local line = string.format('print(f"DEBUG: { %s = }")', var_name)
	-- Insert on the line below
	vim.api.nvim_put({ line }, "l", true, true)
end, { desc = "[I]nsrt Python [L]og" })

-- Variable/function select and insert
map("n", "<leader>is", function()
	local params = vim.lsp.util.make_position_params()
	vim.lsp.buf_request(0, "textDocument/documentSymbol", params, function(err, result, _, _)
		if err or not result then
			print("No symbols found or LSP not ready")
			return
		end
		local symbols = {}
		local function flatten(items)
			for _, item in ipairs(items) do
				-- Filter for Variables, Constants, and Functions (standard LSP Kinds)
				if item.kind == 6 or item.kind == 12 or item.kind == 13 then
					table.insert(symbols, item.name)
				end
				if item.children then
					flatten(item.children)
				end
			end
		end
		flatten(result)
		-- Using vim.ui.select
		-- vim.ui.select(symbols, {
		-- 	prompt = "Select variable/function to inject:",
		-- }, function(choice)
		-- 	if choice then
		-- 		vim.api.nvim_put({ choice }, "", true, true)
		-- 	end
		-- end)

		-- Using Telescope
		pickers
			.new({}, { -- Empty table {} uses the standard large layout
				prompt_title = "LSP Symbols",
				finder = finders.new_table({ results = symbols }),
				sorter = conf.generic_sorter({}),
				-- Make the window taller
				layout_config = {
					width = 0.5,
					height = 0.8, -- Shows much more than 5 lines
				},
				attach_mappings = function(prompt_bufnr, _)
					actions.select_default:replace(function()
						local selection = action_state.get_selected_entry()
						actions.close(prompt_bufnr)
						vim.schedule(function()
							if selection then
								vim.api.nvim_put({ selection[1] }, "", true, true)
							end
						end)
					end)
					return true
				end,
			})
			:find()
	end)
end, { desc = "[I]nject [S]ymbol" })

-- Git
local gitlinker = require("gitlinker")
map({ "n", "v" }, "<leader>gl", function()
	local mode = string.lower(vim.fn.mode())
	gitlinker.get_buf_range_url(mode)
end, {
	silent = true,
	desc = "get git permlink",
})

map("n", "<leader>gbr", function()
	gitlinker.get_repo_url({
		action_callback = gitlinker.actions.open_in_browser,
	})
end, {
	silent = true,
	desc = "browse git repo in browser",
})

-- Git Branch / Commit Hash Injector
map("n", "<leader>ig", function()
	require("telescope.builtin").git_commits({
		attach_mappings = function(prompt_bufnr, _)
			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				vim.api.nvim_put({ selection.value }, "", true, true)
			end)
			return true
		end,
	})
end, { desc = "[I]nsert [G]it Commit Hash" })

--  Citation Injector
map("n", "<leader>ic", function()
	local bib_files = vim.fs.find(function(name)
		return name:match("%.bib$")
	end, {
		upward = true,
		stop = vim.loop.os_homedir(),
		path = vim.fs.dirname(vim.api.nvim_buf_get_name(0)),
	})
	if #bib_files == 0 then
		return print("No .bib files found")
	end
	local entries = {}
	for _, file in ipairs(bib_files) do
		local f = io.open(file, "r")
		if f then
			local content = f:read("*all")
			f:close()
			-- Regex to find @type{key, and try to find title
			for type, key, fields in content:gmatch("@(%w+){%s*([^,]+),([^@]+)") do
				local title = fields:match('title%s*=%s*["{]([^"}]+)["}]') or "No Title"
				table.insert(entries, {
					key = key,
					type = type,
					title = title:gsub("%s+", " "),
					file = vim.fn.fnamemodify(file, ":t"),
				})
			end
		end
	end
	vim.ui.select(entries, {
		prompt = "Cite Paper:",
		format_item = function(item)
			return string.format("[%s] %s — %s", item.file, item.key, item.title)
		end,
	}, function(choice)
		if choice then
			vim.api.nvim_put({ "\\cite{" .. choice.key .. "}" }, "", true, true)
		end
	end)
end, { desc = "[I]nsert [C]itation" })

-- -- Greek Symbol Picker
-- map("i", "<C-l>g", function()
-- 	local symbols = {
-- 		"alpha",
-- 		"beta",
-- 		"gamma",
-- 		"delta",
-- 		"epsilon",
-- 		"zeta",
-- 		"eta",
-- 		"theta",
-- 		"iota",
-- 		"kappa",
-- 		"lambda",
-- 		"mu",
-- 		"xi",
-- 		"pi",
-- 		"rho",
-- 		"sigma",
-- 		"tau",
-- 		"phi",
-- 		"chi",
-- 		"psi",
-- 		"omega",
-- 	}
-- 	vim.ui.select(symbols, { prompt = "Greek Symbol:" }, function(choice)
-- 		if choice then
-- 			vim.api.nvim_put({ "\\" .. choice .. " " }, "", true, true)
-- 		end
-- 	end)
-- end, { desc = "Insert Greek Symbol" })
--
-- Insert Image
-- map("n", "<leader>if", function()
-- 	local img_dirs = { "images", "assets", "figures", "Figures" }
-- 	local target_dir = "."
-- 	local cwd = vim.fn.getcwd()
-- 	for _, d in ipairs(img_dirs) do
-- 		if vim.fn.isdirectory(cwd .. "/" .. d) == 1 then
-- 			target_dir = d
-- 			break
-- 		end
-- 	end
-- 	require("telescope.builtin").find_files({
-- 		prompt_title = "Insert Image Path",
-- 		cwd = target_dir,
-- 		attach_mappings = function(prompt_bufnr, _)
-- 			actions.select_default:replace(function()
-- 				local entry = action_state.get_selected_entry()
-- 				actions.close(prompt_bufnr)
-- 				if not entry then
-- 					return
-- 				end
--
-- 				local path = entry.value or entry[1]
-- 				if target_dir ~= "." then
-- 					path = target_dir .. "/" .. path
-- 				end
--
-- 				local cmd = "\\includegraphics{" .. path .. "}"
-- 				vim.api.nvim_put({ cmd }, "", true, true)
-- 			end)
-- 			return true
-- 		end,
-- 	})
-- end, { desc = "[I]nsert [I]mage Command" })
--
-- -- Usepackage Picker
-- map("n", "<leader>iu", function()
-- 	local common = { "amsmath", "amssymb", "graphicx", "hyperref", "geometry", "xcolor", "tikz", "cleveref" }
-- 	vim.ui.select(common, { prompt = "Use Package:" }, function(c)
-- 		if c then
-- 			vim.api.nvim_put({ "\\usepackage{" .. c .. "}" }, "l", true, true)
-- 		end
-- 	end)
-- end, { desc = "[I]nsert [U]sepackage" })
