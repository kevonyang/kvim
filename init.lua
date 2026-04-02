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

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
			"akinsho/bufferline.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			lazy = false,
			opts = {},
			config = function()
				require("bufferline").setup({
					options = {
						mode = "tabs",
						numbers = "ordinal",
						offsets = {
							{
								filetype = "NvimTree",
								text = "File Explorer",
								text_align = "left",
								separator = true,
							},
						},
						always_show_bufferline = true,
					}
				})
			end,
			keys = {
				{ "<leader>bc", ":BufferLinePickClose<CR>", silent = true, desc = "Close a picked buffer" },
				{ "<leader>bo", ":BufferLineCloseOthers<CR>", silent = true, desc = "Close other buffers" },
				{ "<leader>bd", ":bdelete<CR>", silent = true, desc = "Close buffer" },
				{ "<leader>bh", ":BufferLineCyclePrev<CR>", silent = true, desc = "Previous buffer" },
				{ "<leader>bl", ":BufferLineCycleNext<CR>", silent = true, desc = "Next buffer" },
				{ "<leader>bb", ":BufferLinePick<CR>", silent = true,  desc = "Pick a buffer" },

				{ "<a-q>", ":bdelete<CR>", silent = true, desc = "Close buffer" },
				{ "<a-h>", ":BufferLineCyclePrev<CR>", silent = true, desc = "Previous buffer" },
				{ "<a-l>", ":BufferLineCycleNext<CR>", silent = true, desc = "Next buffer" },
				{ "<a-b>", ":BufferLinePick<CR>", silent = true,  desc = "Pick a buffer" },
				{ "<a-1>", function() require("bufferline").go_to(1, true) end, silent = true, desc = "Go to buffer 1" },
				{ "<a-2>", function() require("bufferline").go_to(2, true) end, silent = true, desc = "Go to buffer 2" },
				{ "<a-3>", function() require("bufferline").go_to(3, true) end, silent = true, desc = "Go to buffer 3" },
				{ "<a-4>", function() require("bufferline").go_to(4, true) end, silent = true, desc = "Go to buffer 4" },
				{ "<a-5>", function() require("bufferline").go_to(5, true) end, silent = true, desc = "Go to buffer 5" },
				{ "<a-6>", function() require("bufferline").go_to(6, true) end, silent = true, desc = "Go to buffer 6" },
				{ "<a-7>", function() require("bufferline").go_to(7, true) end, silent = true, desc = "Go to buffer 7" },
				{ "<a-8>", function() require("bufferline").go_to(8, true) end, silent = true, desc = "Go to buffer 8" },
				{ "<a-9>", function() require("bufferline").go_to(9, true) end, silent = true, desc = "Go to buffer 9" },
				{ "<a-0>", function() require("bufferline").go_to(-1, true) end, silent = true, desc = "Go to last buffer" },
			},
		},
		{
			"sainnhe/gruvbox-material",
			priority = 1000 ,
			opts ={},
			config = function()
				vim.g.gruvbox_material_background = "soft" -- 背景风格：soft/hard/medium
				vim.g.gruvbox_material_foreground = "original" -- 前景风格：mix/original/flat
			end
		},
		{
			"nvim-treesitter/nvim-treesitter",
			build = ':TSUpdate',
			config = function()
				local filetypes = {
					"lua",
					"vim",
					"yaml",
					"markdown",
					"javascript",
					"typescript",
					"python",
					"json",
				}
				require('nvim-treesitter').install(filetypes)
				vim.api.nvim_create_autocmd('FileType', {
					pattern = filetypes,
					callback = function()
						vim.treesitter.start()
						vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
						vim.wo.foldmethod = 'expr'
						vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end,
				})
			end
		},
		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			opts = {
				preset = "modern",
			},
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
			"nvim-tree/nvim-tree.lua",
			lazy = false,
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
			config = function()
				require("nvim-tree").setup({
					sync_root_with_cwd = true,
					respect_buf_cwd = true,
					update_focused_file = {
						enable = true,
						update_root = true,             -- 切换 buffer 时 nvim-tree 根目录跟着变
					},
					actions = {
						change_dir = {
							enable = true,
							global = true,
							restrict_above_cwd = false,
						},
					},
					git = {
						enable = false,
					},
					diagnostics = {
						enable = false,
					},
					modified = {
						enable = false,
					},
				})

				vim.keymap.set("n", "<c-n>", ":NvimTreeToggle<CR>", { desc = "Toggle nvim-tree" })
				vim.keymap.set("n", "<a-n>", ":NvimTreeFindFile<CR>", { desc = "Find current file in nvim-tree" })
			end,
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
			opts = {},
			config = function()
				require("ibl").setup({
					indent = { char = "│" },
					scope = { enabled = true, char = "│", show_start = true, show_end = true },
				})
			end,
		},
		{
			"rcarriga/nvim-notify",
			config = function()
				require("notify").setup({
					timeout = 3000,
				})
				vim.notify = require("notify")
			end,
		},
		{
			"j-hui/fidget.nvim",
			opts = {
			},
			config = function()
				require("fidget").setup({})
			end,
		},
		{
			"rmagatti/auto-session",
			lazy = false,
			opts = {
			},
		},
		{
			"nvim-telescope/telescope.nvim", tag = 'v0.2.2',
			dependencies = {
				'nvim-lua/plenary.nvim',
				"nvim-tree/nvim-web-devicons",
				{
					'nvim-telescope/telescope-fzf-native.nvim',
					build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install'
				},
			},
			config = function()
				local telescope = require('telescope')
				local actions = require('telescope.actions')
				local layout = require('telescope.actions.layout')
				telescope.setup({
					defaults = {
						file_ignore_patterns = {
							"node_modules",
							".git/", ".svn/", ".hg/",
							"tags", "vendor", "build", "dist",
							"%.map$", "%.tlog$", "%.meta$", "%.bytes$", "%.bak$",
							"%.exe$", "%.dll$", "%.o$", "%.obj$", "%.pdb$", "%.lib$",
							"%.xls$", "%.xlsx$", "%.doc$", "%.docx$", "%.pdf$", "%.ppt$", "%.pptx$",
							"%.out$",
						},
						--preview = { hide_on_startup = true },
						layout_strategy = 'vertical',
						mappings = {
							i = {
								["<a-p>"] = layout.toggle_preview,
								["<c-j>"] = actions.move_selection_next,
								["<c-k>"] = actions.move_selection_previous,
								["<c-v>"] = function(prompt_bufnr) vim.api.nvim_paste(vim.fn.getreg('+'), true, -1) end,
							},
							n = {
								["<a-p>"] = layout.toggle_preview,
								["<c-j>"] = actions.move_selection_next,
								["<c-k>"] = actions.move_selection_previous,
								["<c-v>"] = function(prompt_bufnr) vim.api.nvim_paste(vim.fn.getreg('+'), true, -1) end,
							},
						},
					},
					extensions = {
						fzf = {
							fuzzy = true,
							override_generic_sorter = true,
							override_file_sorter = true,
							case_mode = "smart_case",
						}
					}
				})

				telescope.load_extension('fzf')

				local builtin = require('telescope.builtin')
				vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
				vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
				vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Telescope grep string' })
				vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
				vim.keymap.set('n', '<leader>ft', builtin.help_tags, { desc = 'Telescope help tags' })
				vim.keymap.set('n', '<leader>fh', builtin.search_history, { desc = 'Telescope search history' })
				vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope keymaps' })
				vim.keymap.set({'n', 'v'}, '<leader>fr', builtin.resume, { desc = 'Resume last telescope' })

				vim.keymap.set('n', '<c-p>', builtin.find_files, { desc = 'Telescope find files' })
				vim.keymap.set({'n', 'v'}, '<c-f>', builtin.live_grep, { desc = 'Telescope live grep' })
				vim.keymap.set({'n', 'v'}, '<a-f>', builtin.grep_string, { desc = 'Telescope grep string' })
				vim.keymap.set('n', '<c-b>', builtin.buffers, { desc = 'Telescope buffers' })
				vim.keymap.set('n', '<c-g>', builtin.resume, { desc = 'Resume last telescope' })
			end
		},
		--[=[
		{
			"folke/noice.nvim",
			event = "VeryLazy",
			opts = {},
			dependencies = {
				"MunifTanjim/nui.nvim",
			},
			config = function()
				require("noice").setup({
					lsp = {
						override = {
							["vim.lsp.util.convert_input_to_markdown_lines"] = false,
							["vim.lsp.util.stylize_markdown"] = false,
							["cmp.entry.get_documentation"] = false,
						},
					},
					presets = {
						bottom_search = false, -- use a classic bottom cmdline for search
						command_palette = true, -- position the cmdline and popupmenu together
						long_message_to_split = true, -- long messages will be sent to a split
						inc_rename = false, -- enables an input dialog for inc-rename.nvim
						lsp_doc_border = false, -- add a border to hover docs and signature help
					},
				})
			end
		},
		{
			"folke/snacks.nvim",
			priority = 1000,
			lazy = false,
			opts = {
				bigfile = { enabled = true },
				dashboard = { enabled = true },
				explorer = { enabled = false },
				indent = { enabled = true },
				input = { enabled = true },
				picker = {
					enabled = true,
					ui_select = true,
					layout = {
						cycle = false,
						preset = "vertical",
					},
					matcher = {
						fuzzy = true,
						smart_case = true,
						filename_bonus = false,

						cwd_bonus = false, -- give bonus for matching files in the cwd
						frecency = false, -- frecency bonus
						history_bonus = false, -- give more weight to chronological order
					},
					win = {
						input = {
							keys = {
								['<c-v>'] = { '<c-r>+', mode = 'i', expr = true, desc = "paste" },
							},
						},
					},
				},
				notifier = { enabled = true, timeout = 5000},
				quickfile = { enabled = true },
				scope = { enabled = true },
				scroll = { enabled = false },
				statuscolumn = { enabled = false },
				words = { enabled = false },
			},
			keys = {
				-- Top Pickers & Explorer
				{ "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
				{ "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
				{ "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
				{ "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
				{ "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
				--{ "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
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

				--{ "<c-e>", function() Snacks.explorer() end, desc = "File Explorer" },
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
		--]=]
		{
			"zbirenbaum/copilot.lua",
			cmd = "Copilot",
			event = "InsertEnter",
			config = function ()
				require("copilot").setup({
					suggestion = {
						enabled = true,
						auto_trigger = true,
						trigger_on_accept = true,
						debounce = 15,
						keymap = {
							accept = "<c-j>",
							accept_word = "<c-k>",
							accept_line = "<c-l>",
							next = "<a-n>",
							prev = "<a-p>",
							dismiss = "<c-h>",
						},
					},
					panel = {
						enabled = false,
					},
					nes = {
						enabled = false,
					},
				})
			end,
		},
		--[[
		{
			"zbirenbaum/copilot-cmp",
			config = function ()
				require("copilot_cmp").setup()
			end
		},
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
					mapping = cmp.mapping.preset.insert({
						['<C-b>'] = cmp.mapping.scroll_docs(-4),
						['<C-f>'] = cmp.mapping.scroll_docs(4),
						["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
						["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
						['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
						['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
						['<C-Space>'] = cmp.mapping.complete(),
						['<C-e>'] = cmp.mapping.abort(),
						['<CR>'] = cmp.mapping.confirm({ select = true }),
					}),
					sources = cmp.config.sources({
						{ name = 'copilot', priority = 1000, max_item_count = 5 },
						{ name = 'nvim_lsp', priority = 900, max_item_count = 8 },
						{ name = 'vsnip', priority = 500, max_item_count = 5 },
						{ name = 'buffer', priority = 300, max_item_count = 8 },
						{ name = 'path', priority = 200, max_item_count = 5 },
					}),
					sorting = {
						priority_weight = 2,
						comparators = {
							require("copilot_cmp.comparators").prioritize,
							-- Below is the default comparitor list and order for nvim-cmp
							cmp.config.compare.offset,
							-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
							cmp.config.compare.exact,
							cmp.config.compare.score,
							cmp.config.compare.recently_used,
							cmp.config.compare.locality,
							cmp.config.compare.kind,
							cmp.config.compare.sort_text,
							cmp.config.compare.length,
							cmp.config.compare.order,
						},
					},
					completion = {
						completeopt = "menu,menuone,noinsert",
					},
					experimental = {
						ghost_text = false,
					},
				})
			end,
		},
		--]]
		{
			"saghen/blink.cmp",
			version = "v1.9.1",
			dependencies = {
				'rafamadriz/friendly-snippets',
			},
			opts = {
				-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
				-- 'super-tab' for mappings similar to vscode (tab to accept)
				-- 'enter' for enter to accept
				-- 'none' for no mappings
				-- All presets have the following mappings:
				-- C-space: Open menu or open docs if already open
				-- C-n/C-p or Up/Down: Select next/previous item
				-- C-e: Hide menu
				-- C-k: Toggle signature help (if signature.enabled = true)
				-- See :h blink-cmp-config-keymap for defining your own keymap
				keymap = {
					--[[
					preset = 'default',
					["<CR>"] = {"accept", "fallback"},
					["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
					["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
					--]]

					preset = 'super-tab',
				},
				appearance = { nerd_font_variant = 'mono' },
				completion = {
					list = { selection = { preselect = true, auto_insert = true } },
					documentation = { auto_show = true },
					ghost_text = { enabled = false },
				},
				sources = {
					default = { 'lsp', 'path', 'snippets', 'buffer' },
					providers = {
						lsp = { max_items = 5, fallbacks = {} },
						path = { max_items = 5, fallbacks = {} },
						snippets = { max_items = 5, fallbacks = {} },
						buffer = { max_items = 5, fallbacks = {} },
					},
					per_filetype = {
						codecompanion = { "codecompanion" },
					},
				},
				fuzzy = { implementation = "prefer_rust" },
			},
			opts_extend = { "sources.default" },
		},
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


				--local capabilities = require('cmp_nvim_lsp').default_capabilities()
				local capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
				for name, server in pairs(servers) do
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
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
								maxPreload = 1000, -- 预加载文件数量
								ignoreDir = { "node_modules", "engine", "implib" },
							},
							telemetry = { enable = false },
						},
					},
				})
				vim.lsp.enable("lua_ls")

				vim.diagnostic.config({
					enable = true,
					virtual_text = false,
					signs = true,
					underline = true,
				})
			end,
		},
		{
			"olimorris/codecompanion.nvim",
			--version = "v19.7.0",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
				"saghen/blink.cmp",
			},
			config = function()
				require("codecompanion").setup({
					opts = {
						language = "Chinese",
						log_level = "DEBUG",
					},
					adapters = {
						http = {
							opts = {
								show_presets = true,
								show_model_choices = true,
							},
							copilot_gpt41_http = function()
								return require("codecompanion.adapters").extend("copilot", {
									name = "copilot_gpt41_http",
									schema = {
										model = {
											default = "gpt-4.1",
										},
									},
								})
							end,
							copilot_claude_opus46_http = function()
								return require("codecompanion.adapters").extend("copilot", {
									name = "copilot_claude_opus46_http",
									schema = {
										model = {
											default = "claude-opus-4.6",
										},
									},
								})
							end,
							anthropic_co_http = function()
								return require("codecompanion.adapters").extend("anthropic", {
									name = "anthropic_co_http",
									formatted_name = "Anthropic Co(HTTP)",
									url = "${url}",
									env = {
										api_key = "ANTHROPIC_AUTH_TOKEN",
										url = "COMPANY_ANTHROPIC_URL",
									},
									schema = {
										model = {
											default = "claude-sonnet-4-6",
										},
									},
								})
							end,
							openai_co_http = function()
								return require("codecompanion.adapters").extend("openai_compatible", {
									name = "openai_co_http",
									formatted_name = "OpenAI Co(HTTP)",
									env = {
										api_key = "ANTHROPIC_AUTH_TOKEN",
										url = "COMPANY_OPENAI_BASE_URL",
										chat_url = "/v1/chat/completions",
									},
									schema = {
										model = {
											default = "MiniMax-M2.7",
										},
									},
								})
							end,
						},
						acp = {
							opencode_acp = function()
								return require("codecompanion.adapters").extend("opencode", {
									name = "opencode_acp",
									formatted_name = "OpenCode ACP",
								})
							end,
							codemaker_acp = function()
								return require("codecompanion.adapters").extend("opencode", {
									name = "codemaker_acp",
									formatted_name = "CodeMaker ACP",
									commands = {
										default = {
											"codemaker", "acp"
										},
									},
								})
							end,
							claude_code_co_acp = function()
								return require("codecompanion.adapters").extend("claude_code", {
									name = "claude_code_co_acp",
									formatted_name = "Anthropic Co ACP",
									defaults = {
										model = function(self)
											return "Default"
										end,
									},
								})
							end,
						},
					},
					interactions = {
						chat = {
							adapter = "claude_code_co_acp",
						},
						inline = {
							adapter = "anthropic_co_http",
						},
						cmd = {
							adapter = "anthropic_co_http",
						},
						background = {
							adapter = "anthropic_co_http",
						},
						cli = {
							agent = "claude_code",
							agents = {
								claude_code = {
									cmd = "claude",
									args = {},
									description = "Claude Code CLI",
									provider = "terminal",
								},
								opencode = {
									cmd = "opencode",
									args = {},
									description = "OpenCode CLI",
									provider = "terminal",
								},
								codemaker = {
									cmd = "codemaker",
									args = {},
									description = "CodeMaker CLI",
									provider = "terminal",
								},
							},
							opts = {
								auto_insert = false,
								reload = true,
							},
						},
					},
					prompt_library = {
						markdown = {
							dirs = {
								vim.fn.getcwd() .. "/.prompts",
								vim.fn.stdpath("config") .. "/prompts",
							},
						}
					},
				})

				vim.keymap.set({'n', 'v'}, '<leader>cc', function() require("codecompanion").toggle() end, { desc = "codecompanion toggle" })

				vim.keymap.set({'n', 'v'}, '<leader>cn', ":CodeCompanionChat<cr>", { desc = "codecompanion new chat" })
				--vim.keymap.set({'n', 'v'}, '<leader>co', ":CodeCompanionChat adapter=openai_co_http<cr>", { desc = "codecompanion new chat with openai_co(http)" })
				--vim.keymap.set({'n', 'v'}, '<leader>co', ":CodeCompanionChat adapter=opencode_acp<cr>", { desc = "codecompanion new chat with opencode(acp)" })
				--vim.keymap.set({'n', 'v'}, '<leader>cm', ":CodeCompanionChat adapter=codemaker_acp<cr>", { desc = "codecompanion new chat with codemaker(acp)" })

				vim.keymap.set({'n', 'v'}, "<leader>cl", ":CodeCompanionActions<cr>", { desc = "codecompanion list actions" })
				vim.keymap.set({'n', 'v'}, '<leader>cs', ":CodeCompanion ", { desc = "codecompanion chat buffer send prompt" })
				vim.keymap.set('v', '<leader>ca', ":CodeCompanionChat Add<cr>", { desc = "codecompanion chat buffer add" })

				vim.keymap.set({'n', 'v'}, '<leader>ci', ":CodeCompanionCLI<cr>", { desc = "codecompanion new cli" })
				vim.keymap.set({'n', 'v'}, '<leader>cS', ":CodeCompanionCLI! ", { desc = "codecompanion cli send prompt" })
				vim.keymap.set({'n', 'v'}, "<leader>cA", function() return require("codecompanion").cli("#{this}", { focus = true }) end, { desc = "codecompanion cli add context" })
				vim.keymap.set({'n', 'v'}, '<leader>cp', function() require("codecompanion").cli({ prompt = true }) end, { desc = "codecompanion cli complex prompt" })
			end,
		},
		{
			'MeanderingProgrammer/render-markdown.nvim',
			dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
			ft = { "markdown", "codecompanion" },
			opts = {
				anti_conceal = {
					enabled = true,
					disabled_modes = {'n'},
				}
			},
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
		args = { "-R", "--fields=+niazSk", "--extras=+q", "--lua-kinds=+f", "--exclude=.svn", "--exclude=node_modules", "-f", tags_path, root_dir },
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

vim.keymap.set('n', "<leader>tg", ":GenerateTags<CR>", { noremap = true, silent = true, desc = "Manually generate tags" })
vim.keymap.set('n', "<leader>ta", ":AddTags<CR>", { noremap = true, silent = true, desc = "Manually add tags" })
--------------------------ctags end----------------------------

--------------------------options begin----------------------------
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.signcolumn = "yes"
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split"
--vim.opt.wrap = false

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
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

vim.opt.backspace = "indent,eol,start"

vim.cmd.colorscheme("gruvbox-material")
vim.opt.termguicolors = true
vim.o.background = "dark"
vim.o.guifont = "JetBrainsMonoNL Nerd Font Mono:h11"
--vim.o.guifont = "JetBrainsMono Nerd Font Mono:h11"
--vim.o.guifont = "FiraCode Nerd Font Mono:h11"
--vim.o.guifont = "Consolas:h12"
vim.opt.title = true

vim.opt.autoread = true

if vim.g.neovide then
	vim.g.neovide_position_animation_length = 0.00
	vim.g.neovide_cursor_animation_length = 0
	vim.g.neovide_cursor_trail_size = 0.0
	vim.g.neovide_cursor_smooth_blink = false
	vim.g.neovide_scroll_animation_length = 0.0
	vim.g.neovide_scroll_animation_far_lines = 0
	vim.g.neovide_cursor_vfx_mode = ""
	vim.g.neovide_cursor_vfx_opacity = 0.0
	vim.g.neovide_refresh_rate = 60
	vim.g.neovide_vsync = true
	vim.g.neovide_fullscreen = false
	vim.g.neovide_remember_window_size = true
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

--vim.keymap.set('t', '<c-t>', '<c-\\><c-n>', { noremap = true, silent = true, desc = "Leave Terminal" })

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
			vim.notify("reload " .. process .. " " .. file, vim.log.levels.INFO)
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
			vim.notify("check " .. process .. " " .. file, vim.log.levels.INFO)
			return
		end
	end
end, {silent = true, noremap = true, desc = "Check file"})
--------------------------keymaps end----------------------------
