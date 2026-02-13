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
			config = function()
				require('nvim-treesitter').install({ 'lua', 'javascript' })
			end
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
			dependencies = { "nvim-tree/nvim-web-devicons" },
			priority = 1000,
			lazy = false,
			opts = {
				explorer = { enabled = true },
				indent = { enabled = true },
				notifier = { enabled = true, timeout = 8000},
				picker = {
					enabled = true,
					layout = {
						preset = "vertical",
					},
				},
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
		{ "neoclide/coc.nvim", branch = 'release', },
		{ "github/copilot.vim" },
		--[[
		{
			"ggandor/leap.nvim",
			keys = { 's', 'S' },
			config = function()
				require('leap').add_default_mappings()
			end,
		},
		{
			"nvim-tree/nvim-tree.lua", tag = "v1.15.0",
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			opts = {
				on_attach = "default",
				sync_root_with_cwd = true,
			},
		},
		{
			"ibhagwan/fzf-lua",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},
		{
			"nvim-telescope/telescope.nvim", tag = "v0.2.1",
			dependencies = { 'nvim-lua/plenary.nvim' },
		},
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install'
		},
		{
			"ludovicchabant/vim-gutentags",
		},
		{
			"ervandew/supertab",
		},
		--]]
	},
	install = {},
	checker = {
		enabled = false,
		notify = false,
	},
})
--------------------------lazy.nvim end----------------------------

--------------------------nvimtree begin----------------------------
--vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', {silent = true, noremap = true})
--vim.keymap.set('n', '<A-f>', ':NvimTreeFindFile<CR>', {silent = true, noremap = true})
--------------------------nvimtree end----------------------------

--------------------------coc begin----------------------------
local keyset = vim.keymap.set
-- Autocomplete
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use Tab for trigger completion with characters ahead and navigate
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<TAB>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

-- Make <CR> to accept selected completion item or notify coc.nvim to format
-- <C-g>u breaks current undo, please make your own choice
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

-- Use <c-j> to trigger snippets
keyset("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
-- Use <c-space> to trigger completion
keyset("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})

-- Use `[g` and `]g` to navigate diagnostics
-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

-- GoTo code navigation
vim.keymap.set("n", "gd", "<Plug>(coc-definition)", {silent = true})
vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", {silent = true})
vim.keymap.set("n", "gr", "<Plug>(coc-references)", {silent = true})

-- Use K to show documentation in preview window
function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
keyset("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})

-- Symbol renaming
keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})

-- Formatting selected code
keyset("x", "<leader>fs", "<Plug>(coc-format-selected)", {silent = true})
keyset("n", "<leader>fs", "<Plug>(coc-format-selected)", {silent = true})

-- Setup formatexpr specified filetype(s)
vim.api.nvim_create_autocmd("FileType", {
    group = "CocGroup",
    pattern = "typescript,json",
    command = "setl formatexpr=CocAction('formatSelected')",
    desc = "Setup formatexpr specified filetype(s)."
})

-- Apply codeAction to the selected region
-- Example: `<leader>aap` for current paragraph
local opts = {silent = true, nowait = true}
keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

-- Remap keys for apply code actions at the cursor position.
keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
-- Remap keys for apply source code actions for current file.
keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
-- Apply the most preferred quickfix action on the current line.
keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

-- Remap keys for apply refactor code actions.
keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

-- Run the Code Lens actions on the current line
keyset("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)

-- Map function and class text objects
-- NOTE: Requires 'textDocument.documentSymbol' support from the language server
keyset("x", "if", "<Plug>(coc-funcobj-i)", opts)
keyset("o", "if", "<Plug>(coc-funcobj-i)", opts)
keyset("x", "af", "<Plug>(coc-funcobj-a)", opts)
keyset("o", "af", "<Plug>(coc-funcobj-a)", opts)
keyset("x", "ic", "<Plug>(coc-classobj-i)", opts)
keyset("o", "ic", "<Plug>(coc-classobj-i)", opts)
keyset("x", "ac", "<Plug>(coc-classobj-a)", opts)
keyset("o", "ac", "<Plug>(coc-classobj-a)", opts)

-- Remap <C-d> and <C-u> to scroll float windows/popups
---@diagnostic disable-next-line: redefined-local
local opts = {silent = true, nowait = true, expr = true}
keyset("n", "<C-d>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-d>"', opts)
keyset("n", "<C-u>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-u>"', opts)
keyset("i", "<C-d>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
keyset("i", "<C-u>", 'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
keyset("v", "<C-d>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-d>"', opts)
keyset("v", "<C-u>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-u>"', opts)

-- Use CTRL-S for selections ranges
-- Requires 'textDocument/selectionRange' support of language server
keyset("n", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
keyset("x", "<C-s>", "<Plug>(coc-range-select)", {silent = true})

-- Add `:Format` command to format current buffer
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

-- " Add `:Fold` command to fold current buffer
vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})

-- Add `:OR` command for organize imports of the current buffer
vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

-- Add (Neo)Vim's native statusline support
-- NOTE: Please see `:h coc-status` for integrations with external plugins that
-- provide custom statusline: lightline.vim, vim-airline
vim.opt.statusline:prepend("%{coc#status()}%{get(b:,'coc_current_function','')}")

-- Mappings for CoCList
-- code actions and coc stuff
---@diagnostic disable-next-line: redefined-local
local opts = {silent = true, nowait = true}
-- Show all diagnostics
keyset("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
-- Manage extensions
keyset("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
-- Show commands
keyset("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
-- Find symbol of current document
keyset("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
-- Search workspace symbols
keyset("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
-- Do default action for next item
keyset("n", "<space>j", ":<C-u>CocNext<cr>", opts)
-- Do default action for previous item
keyset("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
-- Resume latest coc list
keyset("n", "<space>p", ":<C-u>CocListResume<cr>", opts)
--------------------------coc end----------------------------

--------------------------copilot begin----------------------------
vim.keymap.set('i', '<C-j>', 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
vim.keymap.set('i', '<C-k>', '<Plug>(copilot-accept-word)')
vim.keymap.set('i', '<C-l>', '<Plug>(copilot-accept-line)')
vim.keymap.set('i', '<C-h>', '<Plug>(copilot-dismiss)')
vim.keymap.set('i', '<A-n>', '<Plug>(copilot-next)')
vim.keymap.set('i', '<A-p>', '<Plug>(copilot-previous)')
vim.g.copilot_no_tab_map = true
vim.g.copilot_workspace_folders = {"H:/L10/server/game", "H:/L10/Development/QnMobile/Assets/Scripts/lua"}
--------------------------copilot end----------------------------

--------------------------fzf-lua begin----------------------------
--[[
local fzf_lua = require("fzf-lua")
fzf_lua.setup({
	winopts = {
		preview = {
			vertical = "down:45%",
			layout = "vertical",
		},
	},
	files = {
		fd_opts = "--color=never --hidden --follow --type f" ..
			" --exclude .git" ..
			" --exclude .svn" ..
			" --exclude node_modules",
	},
	grep = {
		rg_opts = "--line-number --column --no-heading --with-filename --color=always --smart-case" ..
			" --glob !.git/**" ..
			" --glob !.svn/**" ..
			" --glob !node_modules/**",
	},
})
vim.keymap.set('n', '<leader>ff', function() fzf_lua.files() end, { desc = 'FzfLua files' })
vim.keymap.set('n', '<leader>fg', function() fzf_lua.live_grep() end, { desc = 'FzfLua live_grep' })
vim.keymap.set('n', '<leader>fw', function() fzf_lua.grep_cword() end, { desc = 'FzfLua grep_cword' })
vim.keymap.set('n', '<leader>ft', function() fzf_lua.help_tags() end, { desc = 'FzfLua help_tags' })
vim.keymap.set('n', '<leader>fb', function() fzf_lua.buffers() end, { desc = 'FzfLua buffers' })
vim.keymap.set('n', '<leader>fk', function() fzf_lua.keymaps() end, { desc = 'FzfLua keymaps' })
vim.keymap.set('n', '<leader>fr', function() fzf_lua.resume() end, { desc = 'FzfLua resume' })
vim.keymap.set('n', '<leader>fhs', function() fzf_lua.search_history() end, { desc = 'FzfLua search_history' })
vim.keymap.set('n', '<leader>fhc', function() fzf_lua.command_history() end, { desc = 'FzfLua command_history' })
vim.keymap.set('n', '<leader>fho', function() fzf_lua.oldfiles() end, { desc = 'FzfLua oldfiles' })

vim.keymap.set('n', '<C-p>', function() fzf_lua.files() end, { desc = 'FzfLua files' })
vim.keymap.set('n', '<C-b>', function() fzf_lua.buffers() end, { desc = 'FzfLua buffers' })
vim.keymap.set('n', '<C-g>', function() fzf_lua.resume() end, { desc = 'FzfLua resume' })

vim.keymap.set({'n', 'i'}, '<C-f>', function()
	local input_str = vim.fn.input('FzfLua live_grep: ')
	if input_str ~= "" then
		fzf_lua.live_grep({ search = input_str })
	end
end, { desc = 'FzfLua live_grep input' })
vim.keymap.set('v', '<C-f>', function() vim.cmd('normal! "zy') fzf_lua.live_grep({ search = vim.fn.getreg('z') }) end, { desc = 'FzfLua live_grep selected' })
vim.keymap.set('n', '<C-S-f>', function() fzf_lua.live_grep() end, { desc = 'FzfLua live_grep' })

vim.keymap.set('n', '<S-f>', function() fzf_lua.grep_cword() end, { desc = 'FzfLua grep_cword' })
vim.keymap.set('v', '<S-f>', function() vim.cmd('normal! "zy') fzf_lua.grep({ search = vim.fn.getreg('z') }) end, { desc = 'FzfLua grep selected' })
--]]
--------------------------fzf-lua end----------------------------

--------------------------telescope begin----------------------------
--[=[
local telescope = require('telescope')
local actions = require('telescope.actions')
local layout = require('telescope.actions.layout')
telescope.setup({
	defaults = {
		use_less = false,
		winblend = 0,
		file_ignore_patterns = {
			"node_modules",
			"%.git/", "%.svn/", "%.hg/",
			"tags", "build/", "dist/",
			"%.map$", "%.tlog$", "%.meta$", "%.bytes$", "%.bak$",
			"%.exe$", "%.dll$", "%.o$", "%.obj$", "%.pdb$", "%.lib$",
			"%.xls$", "%.xlsx$", "%.doc$", "%.docx$", "%.pdf$", "%.ppt$", "%.pptx$",
			"%.out$"
		},
		vimgrep_arguments = {
			'rg',
			"--color=never",
			"--no-heading",
		  	'--with-filename',
		  	'--line-number',
			'--column',
			'--hidden',
		  	'--smart-case',
			'--no-messages',
		  	'--glob=!**/.git/**',
		  	"--glob=!**/.svn/**",
			"--glob=!**/node_modules/**",
		},
		preview = {
			check_mime_type = true,
			filesize_limit = 1,
			timeout = 500,
			hide_on_startup = true,
			treesitter = false,
		},
		history = {
			limit = 10,
		},
		layout_strategy = 'vertical',
		scroll_strategy = 'limit',
		mappings = {
			i = {
				["<M-p>"] = layout.toggle_preview,
				["<M-d>"] = actions.preview_scrolling_down,
				["<M-u>"] = actions.preview_scrolling_up,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-d>"] = actions.results_scrolling_down,
				["<C-u>"] = actions.results_scrolling_up,
				["<ESC>"] = actions.close,
				["<C-v>"] = function(prompt_bufnr) vim.api.nvim_paste(vim.fn.getreg('+'), true, -1) end,
			},
			n = {
				["<M-p>"] = layout.toggle_preview,
				["<M-d>"] = actions.preview_scrolling_down,
				["<M-u>"] = actions.preview_scrolling_up,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-d>"] = actions.results_scrolling_down,
				["<C-u>"] = actions.results_scrolling_up,
				["<ESC>"] = actions.close,
				["<C-v>"] = function(prompt_bufnr) vim.api.nvim_paste(vim.fn.getreg('+'), true, -1) end,
			},
		},
	},
	pickers = {
		find_files = {
			find_command = {
				'rg', '--files',
				'--color=never',
				'--hidden',
				'--smart-case',
				'--no-messages',
				'--glob=!**/.git/**',
				'--glob=!**/.svn/**',
				'--glob=!**/node_modules/**'
			},
			--[[
			find_command = {
				"fd",
				"--type", "f",
				"--hidden",
				"--exclude", ".git",
				"--exclude", ".svn",
				"--exclude", "node_modules",
				"--follow",
				"--ignore-case",
				"."
			},
			--]]
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		}
	},
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

vim.keymap.set('n', '<C-p>', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<C-g>', builtin.resume, { desc = 'Resume last telescope' })

vim.keymap.set({'n', 'v'}, '<C-f>', function()
	local input_str = vim.fn.input('Telescope grep: ')
	if input_str ~= '' then
		builtin.grep_string({ search = input_str })
	end
end, { desc = 'Telescope grep input' })

vim.keymap.set('n', '<S-f>', function() builtin.grep_string()  end, { desc = 'Telescope grep string' })
vim.keymap.set('v', '<S-f>', function() vim.cmd('normal! "zy') builtin.grep_string({ search = vim.fn.getreg('z') }) end, { desc = 'Telescope grep selected' })

vim.keymap.set('n', '<C-S-f>', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('v', '<C-S-f>', function() vim.cmd('normal! "zy') builtin.live_grep({ default_text = vim.fn.getreg('z') }) end, { desc = 'Telescope live grep selected' })
--]=]
--------------------------telescope end----------------------------

--------------------------gutentags begin----------------------------
-- 安装插件后加入这些设置
--[[
local cache_dir = vim.fn.stdpath('cache')
vim.fn.mkdir(cache_dir .. '/tags', 'p')

vim.g.gutentags_enabled = 0
vim.g.gutentags_cache_dir = cache_dir .. '/tags'
vim.g.gutentags_modules = {'ctags'}
vim.g.gutentags_ctags_executable = 'ctags'
vim.g.gutentags_ctags_extra_args = {'--languages=Lua', '--fields=+ailmnS', '--extras=+q', '--sort=no'}
vim.g.gutentags_file_list_command = 'rg --files --hidden --glob "!.git" --glob "!.svn" --glob "!node_modules" --glob "*.lua"'
vim.g.gutentags_project_root = {'.svn', '.git', '.project'}

vim.g.gutentags_generate_on_new	         = 0
vim.g.gutentags_generate_on_write        = 0
vim.g.gutentags_generate_on_missing      = 0
vim.g.gutentags_generate_on_empty_buffer = 0

vim.keymap.set('n', '<leader>tu', function()
	vim.g.gutentags_enabled = 1
	vim.cmd('GutentagsUpdate')
	vim.g.gutentags_enabled = 0
	vim.notify('Tags update manually', vim.log.levels.INFO)
end, { desc = 'Gutentags Update' })
--]]
--------------------------gutentags end----------------------------

--------------------------ctags begin----------------------------
--[[
local function run_job(cmd_tbl, cwd, name)
	local ok, jid = pcall(vim.fn.jobstart, cmd_tbl, {
		cwd = cwd,
		stdout_buffered = true,
		stderr_buffered = true,
		on_stdout = function(_, _data) end,
		on_stderr = function(_, _data) end,
		on_exit = function(_, code)
			if code == 0 then
				vim.notify(name .. " finished in: " .. cwd, vim.log.levels.INFO)
			else
				vim.notify(name .. " failed (exit " .. tostring(code) .. ") in: " .. cwd, vim.log.levels.ERROR)
			end
		end,
		detach = true,
	})
	if not ok or jid == 0 then
		vim.notify("Failed to start " .. name, vim.log.levels.ERROR)
	end
end

local function generate_ctags()
	local cwd = vim.fn.getcwd()
	if not cwd or cwd == "" then
		notify("Cannot determine working directory", vim.log.levels.ERROR)
		return
	end

	if vim.fn.executable("ctags") == 1 then
		run_job({ "ctags", "-R",
			"--languages=Lua,Python,JavaScript", -- adjust or remove
			"--fields=+niazS",
			"--extras=+q",
			"-f", "tags", "." }, cwd, "ctags")
	end

	if vim.fn.executable("cscope") == 1 then
		run_job({ "cscope", "-R", "-b", "-q" }, cwd, "cscope")
	end
end
vim.api.nvim_create_user_command("Gentags", function() generate_ctags() end, { nargs = 0, desc = "Generate ctags in current working directory" })
--]]
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
vim.o.guifont = "Consolas:h12"
--vim.o.guifont = "JetBrainsMono Nerd Font Mono:h11"
vim.opt.title = true

--[[
vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
{
	pattern = "*",
	callback = function()
		vim.cmd("checktime")
	end,
})
vim.api.nvim_create_autocmd("FileChangedShellPost",
{
	pattern = "*",
	callback = function()
		vim.notify("File changed on disk and reloaded", vim.log.levels.WARN)
	end,
})
--]]

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
vim.keymap.set('v', '<C-x>', '"+x', {silent = true, noremap = true})
vim.keymap.set('v', '<C-c>', '"+y', {silent = true, noremap = true})
vim.keymap.set('n', '<C-v>', '"+P', {silent = true, noremap = true})
vim.keymap.set('v', '<C-v>', '"_dP', {silent = true, noremap = true})
vim.keymap.set('c', '<C-v>', '<C-r>+', {noremap = true})
--vim.keymap.set('i', '<C-v>', '<C-r>+', {noremap = true})
vim.keymap.set('i', '<C-v>', function()
    vim.o.paste = true
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-r>+', true, true, true), 'n', false)
    vim.defer_fn(function() vim.o.paste = false end, 10)
end, {silent = true, noremap = true, desc = "paste with auto paste mode"})
vim.keymap.set('n', '<C-a>', 'ggVG', {silent = true, noremap = true})

vim.keymap.set({'n', 'v'}, '<C-j>', ':resize +5<CR>', {silent = true, noremap = true})
vim.keymap.set({'n', 'v'}, '<C-k>', ':resize -5<CR>', {silent = true, noremap = true})
vim.keymap.set({'n', 'v'}, '<C-h>', ':vertical resize -10<CR>', {silent = true, noremap = true})
vim.keymap.set({'n', 'v'}, '<C-l>', ':vertical resize +10<CR>', {silent = true, noremap = true})

vim.keymap.set('i', '<A-j>', '<Down>', {silent = true, noremap = true})
vim.keymap.set('i', '<A-k>', '<Up>', {silent = true, noremap = true})
vim.keymap.set('i', '<A-h>', '<Left>', {silent = true, noremap = true})
vim.keymap.set('i', '<A-l>', '<Right>', {silent = true, noremap = true})

vim.keymap.set('n', '<C-t>', ':tabnew<CR>', {silent = true, noremap = true})

vim.keymap.set('n', '<A-e>', function()
	local dir = vim.fn.fnameescape(vim.fn.expand("%:p:h"))
	dir = string.gsub(dir, "/", "\\")
	vim.cmd("silent :!start explorer " .. dir)
    --vim.cmd("silent :!start explorer.exe %:p:h")
end, {silent = true, noremap = true, desc = "Open file folder"})

vim.keymap.set('n', '<A-i>', function()
	local name = vim.fn.expand("%")
	if name and name:find("Inc%.lua$") then
		local newname = name:gsub("Inc%.lua$", ".lua", 1)
		vim.cmd("edit " .. vim.fn.fnameescape(newname))
	elseif name and name:find("%.lua$") then
		local newname = name:gsub("%.lua$", "Inc.lua", 1)
		vim.cmd("edit " .. vim.fn.fnameescape(newname))
	end
end, {silent = true, noremap = true, desc = "Toggle inc file"})

vim.keymap.set('n', '<A-r>', function()
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

vim.keymap.set('n', '<A-c>', function()
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
