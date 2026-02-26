-- 把 leader 改为空格（放在文件最顶端）
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- 禁用 Space 本身（普通+可视）
vim.keymap.set({'n','v'}, '<Space>', '<Nop>', { silent = true })

-- 打开文件时自动切换到该文件所在目录
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		local argc = vim.fn.argc()
		if argc == 0 then return end
		local dir = vim.fn.expand("%:p:h")
		if dir == "" then return end
		vim.cmd("lcd "..vim.fn.fnameescape(dir))
	end,
})

--------------------------lazy.nvim begin----------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			opts = {},
		},
		{
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			opts = {},
		},
		{
			"sainnhe/gruvbox-material",
			priority = 1000 ,
			config = true,
			opts ={},
			config = function()
				vim.g.gruvbox_material_background = "soft" -- 背景风格：soft/hard/medium
				vim.g.gruvbox_material_foreground = "original" -- 前景风格：mix/original/flat
			end
		},
		{
			"nvim-treesitter/nvim-treesitter",
			lazy = false,
			build = ':TSUpdate',
			opts = {
				ensure_installed = {
					"lua",
					"javascript",
					"typescript",
					"python",
					"vim",
				},
			},
			config = function()
				require('nvim-treesitter').install({ 'lua', 'javascript' })
			end
		},
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			opts = {},
			keys = {
				{
				  "<leader>?",
				  function()
					require("which-key").show({ global = false })
				  end,
				  desc = "Buffer Local Keymaps (which-key)",
				},
			},
		},
		{
			"folke/flash.nvim",
			event = "VeryLazy",
			opts = {},
			keys = {
				{ "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
				{ "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
				{ "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
				{ "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
				{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
			},
		},
		{
			"folke/snacks.nvim",
			priority = 1000,
			lazy = false,
			opts = {
				bigfile = { enabled = true },
				dashboard = { enabled = true },
				explorer = { enabled = true },
				indent = { enabled = true },
				input = { enabled = true },
				picker = {
					enabled = true,
					ui_select = true,
					cycle = false,
					layout = {
						preset = "vertical",
					},
					matcher = {
						fuzzy = true,
						smart_case = true,
					},
					win = {
						input = {
							keys = {
								['<c-v>'] = { '<c-r>+', mode = 'i', expr = true, desc = "paste" },
							},
						},
					},
				},
				notifier = { enabled = true, timeout = 10000},
				quickfile = { enabled = true },
				scope = { enabled = true },
			},
			keys = {
				-- Top Pickers & Explorer
				{ "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
				{ "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
				{ "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
				{ "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
				{ "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
				{ "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
				-- find
				{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
				{ "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
				{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
				{ "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
				{ "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
				{ "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
				-- Grep
				{ "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
				{ "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
				{ "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
				{ "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
				-- search
				{ '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
				{ '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
				{ "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
				{ "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
				{ "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
				{ "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
				{ "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
				{ "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
				{ "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
				{ "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
				{ "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
				{ "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
				{ "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
				{ "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
				{ "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
				{ "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
				{ "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
				{ "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
				{ "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
				{ "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
				{ "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
				-- LSP
				{ "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
				{ "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
				{ "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
				{ "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
				{ "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
				{ "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
				{ "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
				{ "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
				{ "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
				-- Other
				{ "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
				{ "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
				{ "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
				{ "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
				{ "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
				{ "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
				{ "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
				{ "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
				{ "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
				{ "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
				{ "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
				{ "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
				{ "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
				{ "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },

				{ "<c-e>", function() Snacks.explorer() end, desc = "File Explorer" },
				{ "<c-p>", function() Snacks.picker.files() end, desc = "Find Files" },
				{ "<c-g>", function() Snacks.picker.resume() end, desc = "Resume" },
				{ "<c-f>", function() Snacks.picker.grep() end, desc = "Grep" },
				{ "<a-f>", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
			},
		},
		{
			"folke/persistence.nvim",
			event = "BufReadPre", -- this will only start session saving when an actual file was opened
			opts = {},
			keys = {
				-- load the session for the current directory
				{"<leader>qs", mode = "n", function() require("persistence").load() end, desc = "load session for current dir" },
				-- select a session to load
				{"<leader>qS", mode = "n", function() require("persistence").select() end, desc = "select session to load" },
				-- load the last session
				{"<leader>ql", mode = "n", function() require("persistence").load({ last = true }) end, desc = "load last session" },
				-- stop Persistence => session won't be saved on exit
				{"<leader>qd", mode = "n", function() require("persistence").stop() end, desc = "stop persistence" },
			}
		},
		--[[
		{
		  'saghen/blink.cmp',
		  dependencies = { 'rafamadriz/friendly-snippets' },
		  version = 'v1.9.1',
		  opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = 'super-tab' },
			appearance = { nerd_font_variant = 'mono' },
			completion = { documentation = { auto_show = false } },
			sources = {
				default = { 'lsp', 'buffer' },
			},
			fuzzy = { implementation = "lua" }
		  },
		  opts_extend = { "sources.default" }
		},
		--]]
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"hrsh7th/cmp-vsnip",
				"hrsh7th/vim-vsnip",
			},
			config = function()
				local cmp = require("cmp")
				cmp.setup({
					snippet = {
						expand = function(args)
							vim.fn["vsnip#anonymous"](args.body)
						end,
					},
					window = {
						completion = cmp.config.window.bordered(),
						documentation = cmp.config.window.bordered(),
					},
					mapping = cmp.mapping.preset.insert({
						['<C-b>'] = cmp.mapping.scroll_docs(-4),
						['<C-f>'] = cmp.mapping.scroll_docs(4),
						["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
						["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
						['<C-Space>'] = cmp.mapping.complete(),
						['<C-e>'] = cmp.mapping.abort(),
						['<CR>'] = cmp.mapping.confirm({ select = true }),
					}),
					sources = cmp.config.sources({
						{ name = 'nvim_lsp' },
						{ name = 'vsnip' },
					},
					{
						{ name = 'buffer' },
						{ name = 'path' },
					}),
				})
			end,
		},
		{
			"github/copilot.vim",
			config = function()
				vim.keymap.set('i', '<C-j>', 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
				vim.keymap.set('i', '<C-k>', '<Plug>(copilot-accept-word)')
				vim.keymap.set('i', '<C-l>', '<Plug>(copilot-accept-line)')
				vim.keymap.set('i', '<C-h>', '<Plug>(copilot-dismiss)')
				vim.keymap.set('i', '<A-n>', '<Plug>(copilot-next)')
				vim.keymap.set('i', '<A-p>', '<Plug>(copilot-previous)')
				vim.g.copilot_no_tab_map = true
				vim.g.copilot_workspace_folders = {"H:/L10/server/game", "H:/L10/Development/QnMobile/Assets/Scripts/lua"}
			end,
		},
		{
			"CopilotC-Nvim/CopilotChat.nvim",
			dependencies = {
				"github/copilot.vim",
				"nvim-lua/plenary.nvim"
			},
			opts = {
				model = "gpt-4o"
			},
			keys = {
				{ "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat: Toggle" },
				{ "<leader>cr", "<cmd>CopilotChatReset<cr>",  desc = "CopilotChat: Reset" },
				{ "<leader>cs", "<cmd>CopilotChatStop<cr>",   desc = "CopilotChat: Stop" },
				{ "<leader>cp", "<cmd>CopilotChatPrompts<cr>",  desc = "CopilotChat: Prompts" },

				-- Send selection to chat (visual mode)
				{ "<leader>ce", mode = "v", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat: Explain selection" },
				{ "<leader>cf", mode = "v", "<cmd>CopilotChatFix<cr>",     desc = "CopilotChat: Fix selection" },
				{ "<leader>co", mode = "v", "<cmd>CopilotChatOptimize<cr>", desc = "CopilotChat: Optimize selection" },
				{ "<leader>cv", mode = "v", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat: Review selection" },
				{ "<leader>ct", mode = "v", "<cmd>CopilotChatTests<cr>",   desc = "CopilotChat: Tests for selection" },
			},
		},
		--[[
		{
			"ludovicchabant/vim-gutentags",
			config = function()
				local cache_dir = vim.fn.stdpath('cache')
				vim.fn.mkdir(cache_dir .. '/tags', 'p')

				--vim.g.gutentags_enabled = 0
				vim.g.gutentags_cache_dir = cache_dir .. '/tags'
				vim.g.gutentags_modules = {'ctags'}
				vim.g.gutentags_ctags_executable = 'ctags'
				vim.g.gutentags_ctags_extra_args = {'--languages=Lua', '--fields=+niazSk', '--extras=+q', '--lua-kinds=+mvfgtc', '--sort=no'}
				vim.g.gutentags_file_list_command = 'rg --files --hidden --glob "!.git" --glob "!.svn" --glob "!node_modules" --glob "*.lua"'
				vim.g.gutentags_project_root = {'.project'}

				--vim.g.gutentags_generate_on_new	         = 0
				--vim.g.gutentags_generate_on_write        = 0
				--vim.g.gutentags_generate_on_missing      = 0
				--vim.g.gutentags_generate_on_empty_buffer = 0

				vim.keymap.set('n', '<leader>tu', function()
					--vim.g.gutentags_enabled = 1
					vim.cmd('GutentagsUpdate')
					--vim.g.gutentags_enabled = 0
					vim.notify('Tags update manually', vim.log.levels.INFO)
				end, { desc = 'Gutentags Update' })
			end,
		},
		--]]
		{
			"neovim/nvim-lspconfig",
			dependencies = {
				{ "mason-org/mason.nvim", opts = {} },
				"WhoIsSethDaniel/mason-tool-installer.nvim",
			},
			config = function()
				-- 1. 初始化 mason（确保语言服务器已安装）
				require("mason").setup()

				-- 2. 通用诊断配置（行内提示）
				vim.diagnostic.config({ virtual_text = true })

				-- 3. 定义各语言服务器的配置
				local servers = { pyright = {}, clangd = {} }
				local ensure_installed = vim.tbl_keys(servers)
				vim.list_extend(ensure_installed, {
					"lua-language-server",
					"stylua"
				})
				require("mason-tool-installer").setup { ensure_installed = ensure_installed }

				--local capabilities = require("cmp_nvim_lsp").default_capabilities()
				for name, server in pairs(servers) do
					--server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					vim.lsp.config(name, server)
					vim.lsp.enable(name)
				end

				vim.lsp.config("lua_ls", {
					filetypes = { "lua" },
					root_markers = { ".project", ".luarc.json", ".luarc.jsonc" },
					settings = {
						Lua = {
							runtime = { version = "LuaJIT", path = vim.split(package.path, ";") }, -- Lua 运行时
							diagnostics = { globals = { "vim" } }, -- 忽略全局变量 vim 的警告
							workspace = {
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
								preloadFileSize = 1500, -- 文件大小阈值
								maxPreload = 500, -- 预加载文件数量
								ignoreDir = { "node_modules", "engine", "implib" },
							},
							telemetry = { enable = false },
						},
					},
				})
				vim.lsp.enable("lua_ls")
			end,
		},
	},
	install = {},
	checker = {
		enabled = false,
		notify = false,
	},
})
--------------------------lazy.nvim end----------------------------

--------------------------ctags begin----------------------------
vim.api.nvim_create_user_command("GenerateTags", function()
	local root_dir = vim.fn.getcwd()
	local tags_dir = vim.fn.stdpath("cache") .. "/ctags"
	local project_name = vim.fn.fnamemodify(root_dir, ":t")
	local tags_path = vim.fn.expand(tags_dir .. "/" .. project_name .. ".tags")
	if not vim.loop.fs_stat(tags_dir) then
		vim.fn.mkdir(tags_dir, "p") -- "p" 表示递归创建父目录
	end

	vim.notify("Tags generating: " .. root_dir, vim.log.levels.INFO)

	local stdout = vim.loop.new_pipe(false)
	local stderr = vim.loop.new_pipe(false)

	vim.loop.spawn("ctags", {
		args = { "-R", "--fields=+niazSkS", "--extras=+q", "--lua-kinds=+f", "--exclude=.svn", "--exclude=node_modules", "-f", tags_path, root_dir },
		stdio = { nil, stdout, stderr },
		cwd = root_dir,
	}, function(code, signal)
		stdout:close()
		stderr:close()
		vim.schedule(function()
			if code == 0 then
				if not vim.o.tags:find(tags_path, 1, true) then
					vim.o.tags = tags_path .. "," .. vim.o.tags
				end
				vim.notify("Tags generated successfully: " .. tags_path, vim.log.levels.INFO)
			else
				vim.notify("Failed to generate tags", vim.log.levels.WARN)
			end
		end)
	end)

	vim.loop.read_start(stderr, function(err, data)
		vim.schedule(function()
			if err then
				vim.api.nvim_echo({{"Ctags error: " .. err, "WarningMsg"}}, false, {})
			elseif data then
				vim.api.nvim_echo({{"Ctags error data: " .. data, "WarningMsg"}}, false, {})
			end
		end)
	end)
end, { desc = "Manually generate Ctags" })

vim.api.nvim_create_user_command("AddTags", function()
	local root_dir = vim.fs.dirname(vim.fn.getcwd())
	local tags_dir = vim.fn.stdpath("cache") .. "/ctags"
	local project_name = vim.fn.fnamemodify(root_dir, ":t")
	local tags_path = vim.fn.expand(tags_dir .. "/" .. project_name .. ".tags")
	if vim.loop.fs_stat(tags_path) then
		if vim.o.tags:find(tags_path, 1, true) then
			vim.notify("Tags already added: " .. tags_path, vim.log.levels.INFO)
		else
			vim.o.tags = tags_path .. "," .. vim.o.tags
			vim.notify("Tags added successfully: " .. tags_path, vim.log.levels.INFO)
		end
	else
		vim.notify("Tags file not found: " .. tags_path, vim.log.levels.WARN)
	end
end, { desc = "Manually add Ctags" })

vim.keymap.set("n", "<leader>tg", ":GenerateTags<CR>", { noremap = true, silent = true, desc = "Manually generate tags" })
vim.keymap.set("n", "<leader>ta", ":AddTags<CR>", { noremap = true, silent = true, desc = "Manually add tags" })
--------------------------ctags end----------------------------

--------------------------options begin----------------------------
vim.opt.number = true
vim.opt.cursorline = true
--vim.opt.cursorcolumn = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"

vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.smartindent = true

vim.opt.laststatus = 2

vim.opt.foldmethod = "indent"
vim.opt.foldenable = false

vim.opt.encoding = "utf-8"
vim.opt.fileencodings = "ucs-bom,utf-8,chinese"
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = false

vim.opt.signcolumn = "yes"

vim.opt.backspace = "indent,eol,start"

vim.opt.lines = 50
vim.opt.columns = 200
vim.opt.linespace = 1

vim.cmd.colorscheme("gruvbox-material")
vim.opt.termguicolors = true
vim.o.background = "dark"
vim.o.guifont = "JetBrainsMono Nerd Font Mono:h11"
--vim.o.guifont = "Consolas:h12"
vim.opt.title = true

vim.opt.autoread = true

if vim.g.neovide then
	vim.g.neovide_cursor_animation_length = 0
	vim.g.neovide_cursor_trail_size = 0.0
	vim.g.neovide_scroll_animation_length = 0.05
	vim.g.neovide_scroll_animation_far_lines = 1
	vim.g.neovide_position_animation_length = 0.05
	vim.g.neovide_cursor_vfx_mode = ""
	vim.g.neovide_cursor_vfx_opacity = 0.0
end
--------------------------options end----------------------------

--------------------------keymaps begin----------------------------
-- n normal, v visual, x visual block, i insert, c command
--vim.keymap.set('x', 'p', '"0p', {silent = true, noremap = true})
vim.keymap.set('x', 'p', 'pgvy', {silent = true, noremap = true})
vim.keymap.set('v', '<c-x>', '"+x', {silent = true, noremap = true})
vim.keymap.set('v', '<c-c>', '"+y', {silent = true, noremap = true})
vim.keymap.set('n', '<c-v>', '"+P', {silent = true, noremap = true})
vim.keymap.set('v', '<c-v>', '"_dP', {silent = true, noremap = true})
vim.keymap.set('c', '<c-v>', '<c-r>+', {noremap = true})
--vim.keymap.set('i', '<c-v>', '<c-r>+', {noremap = true})
vim.keymap.set('i', '<c-v>', function()
    vim.o.paste = true
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<c-r>+', true, true, true), 'n', false)
    vim.defer_fn(function() vim.o.paste = false end, 10)
end, {silent = true, noremap = true, desc = "paste with auto paste mode"})
vim.keymap.set('n', '<c-a>', 'ggVG', {silent = true, noremap = true})

vim.keymap.set({'n', 'v'}, '<c-j>', ':resize +5<cr>', {silent = true, noremap = true, desc = "Resize window"})
vim.keymap.set({'n', 'v'}, '<c-k>', ':resize -5<cr>', {silent = true, noremap = true, desc = "Resize window"})
vim.keymap.set({'n', 'v'}, '<c-h>', ':vertical resize -10<cr>', {silent = true, noremap = true, desc = "Resize window"})
vim.keymap.set({'n', 'v'}, '<c-l>', ':vertical resize +10<cr>', {silent = true, noremap = true, desc = "Resize window"})

vim.keymap.set('i', '<a-j>', '<Down>', {silent = true, noremap = true, desc = "Move cursor"})
vim.keymap.set('i', '<a-k>', '<Up>', {silent = true, noremap = true, desc = "Move cursor"})
vim.keymap.set('i', '<a-h>', '<Left>', {silent = true, noremap = true, desc = "Move cursor"})
vim.keymap.set('i', '<a-l>', '<Right>', {silent = true, noremap = true, desc = "Move cursor"})

vim.keymap.set('n', '<c-t>', ':tabnew<cr>', {silent = true, noremap = true, desc = "New Tab"})

vim.keymap.set('n', '<a-e>', function()
	local dir = vim.fn.fnameescape(vim.fn.expand("%:p:h"))
	dir = string.gsub(dir, "/", "\\")
	vim.cmd("silent :!start explorer " .. dir)
    --vim.cmd("silent :!start explorer.exe %:p:h")
end, {silent = true, noremap = true, desc = "Open file folder"})

vim.keymap.set('n', '<a-i>', function()
	local name = vim.fn.expand("%")
	if name and name:find("Inc%.lua$") then
		local newname = name:gsub("Inc%.lua$", ".lua", 1)
		vim.cmd("edit " .. vim.fn.fnameescape(newname))
	elseif name and name:find("%.lua$") then
		local newname = name:gsub("%.lua$", "Inc.lua", 1)
		vim.cmd("edit " .. vim.fn.fnameescape(newname))
	end
end, {silent = true, noremap = true, desc = "Toggle inc file"})

vim.keymap.set('n', '<a-r>', function()
	local processes = { "master", "gas", "login", "ship", "house_db", "database" }
	local path = vim.fn.expand("%:p")
	local file = vim.fn.expand("%:t")
	for _, process in ipairs(processes) do
		if path:find(process, 1, true) then
			vim.cmd("!reload " .. process .. " " .. file)
			return
		end
	end
end, {silent = true, noremap = true, desc = "Reload file"})

vim.keymap.set('n', '<a-c>', function()
	local processes = { "master", "gas", "login", "ship", "house_db", "database" }
	local path = vim.fn.expand("%:p")
	local file = vim.fn.expand("%:t")
	for _, process in ipairs(processes) do
		if path:find(process, 1, true) then
			vim.cmd("!check " .. process .. " " .. file)
			return
		end
	end
end, {silent = true, noremap = true, desc = "Check file"})
--------------------------keymaps end----------------------------
