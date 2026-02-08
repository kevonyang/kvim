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
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			opts = {},
		},
		{
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			opts = {},
		},
		{
			"nvim-tree/nvim-tree.lua", tag = "v1.15.0",
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			opts = {
				on_attach = function(bufnr)
					local api = require "nvim-tree.api"
					api.config.mappings.default_on_attach(bufnr)
				end,
				sync_root_with_cwd = true,
				actions = {
					change_dir = {
						enable = true,
						global = true,
						restrict_above_cwd = false,
					},
				},
				update_focused_file = {
					enable = true,
					update_root = true,
				},
			},
		},
		{
			"ibhagwan/fzf-lua",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},
		{
			'ggandor/leap.nvim',
			keys = { 's', 'S' },
			config = function()
				require('leap').add_default_mappings()
			end,
		},
		{ 'github/copilot.vim' },
		--[[
		{
			"nvim-telescope/telescope.nvim", tag = "v0.2.1",
			dependencies = { 'nvim-lua/plenary.nvim' },
		},
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install'
		},
		{
			'ludovicchabant/vim-gutentags',
		},
		{
			'ervandew/supertab',
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
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', {silent = true, noremap = true})
vim.keymap.set('n', '<A-f>', ':NvimTreeFindFile<CR>', {silent = true, noremap = true})
--------------------------nvimtree end----------------------------

--------------------------fzf-lua begin----------------------------
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
vim.keymap.set('n', '<leader>fw', function() fzf_lua.grep_cword() end, { desc = 'FzfLua grep cword' })
vim.keymap.set('n', '<leader>ft', function() fzf_lua.help_tags() end, { desc = 'FzfLua help_tags' })
vim.keymap.set('n', '<leader>fb', function() fzf_lua.buffers() end, { desc = 'FzfLua buffers' })
vim.keymap.set('n', '<leader>fk', function() fzf_lua.keymaps() end, { desc = 'FzfLua keymaps' })
vim.keymap.set('n', '<leader>fhs', function() fzf_lua.search_history() end, { desc = 'FzfLua search_history' })
vim.keymap.set('n', '<leader>fhc', function() fzf_lua.command_history() end, { desc = 'FzfLua command_history' })
vim.keymap.set('n', '<leader>fho', function() fzf_lua.oldfiles() end, { desc = 'FzfLua oldfils' })

vim.keymap.set('n', '<C-p>', function() fzf_lua.files() end, { desc = 'FzfLua files' })
vim.keymap.set('n', '<C-b>', function() fzf_lua.buffers() end, { desc = 'FzfLua buffers' })
vim.keymap.set('n', '<C-g>', function() fzf_lua.resume() end, { desc = 'FzfLua resume' })

vim.keymap.set({'n', 'v', 'i'}, '<C-f>', function()
	local input_str = vim.fn.input('FzfLua grep: ')
	if input_str ~= '' then
		fzf_lua.grep({ search = input_str })
	end
end, { desc = 'FzfLua grep input' })

vim.keymap.set('n', '<S-f>', function() fzf_lua.grep_cword() end, { desc = 'FzfLua grep cword' })
vim.keymap.set('v', '<S-f>', function()
	vim.cmd('normal! "zy')
	fzf_lua.grep({ search = vim.fn.getreg('z') })
end, { desc = 'FzfLua grep selected' })

vim.keymap.set('n', '<C-S-f>', function() fzf_lua.live_grep() end, { desc = 'FzfLua live_grep input' })
vim.keymap.set('v', '<C-S-f>', function()
	vim.cmd('normal! "zy')
	fzf_lua.live_grep({ search = vim.fn.getreg('z') })
end, { desc = 'FzfLua live_grep selected' })
--------------------------fzf-lua end----------------------------

--------------------------telescope begin----------------------------
--[=[
local telescope = require('telescope')
local actions = require('telescope.actions')
local layout = require('telescope.actions.layout')
telescope.setup({
	defaults = {
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
		  	'--smart-case',
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
			limit = 100,
		},
		cache_picker = false,
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
				["<C-v>"] = function(prompt_bufnr) vim.api.nvim_paste(vim.fn.getreg('+'), true, -1) end,
			},
		},
	},
	--[[
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		}
	},
	--]]
})

--telescope.load_extension('fzf')

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
vim.keymap.set('n', '<C-b>', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<C-g>', builtin.resume, { desc = 'Resume last telescope' })

vim.keymap.set('n', '<C-f>', function()
	local input_str = vim.fn.input('Telescope grep: ')
	if input_str ~= '' then
		builtin.grep_string({ search = input_str })
	end
end, { desc = 'Telescope grep input string' })
vim.keymap.set('n', '<S-f>', builtin.grep_string, { desc = 'Telescope grep string' })
vim.keymap.set('v', '<S-f>', function()
	vim.cmd('normal! "zy')
	builtin.grep_string({ search = vim.fn.getreg('z') })
end, { desc = 'Telescope grep string' })

vim.keymap.set('n', '<C-S-f>', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('v', '<C-S-f>', function()
	vim.cmd('normal! "zy')
	builtin.live_grep({ default_text = vim.fn.getreg('z') })
end, {desc = "Telescope live grep" })
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

--------------------------copilot begin----------------------------
vim.keymap.set('i', '<C-j>', 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
vim.keymap.set('i', '<C-K>', '<Plug>(copilot-accept-word)')
vim.keymap.set('i', '<C-L>', '<Plug>(copilot-accept-line)')
vim.keymap.set('i', '<C-H>', '<Plug>(copilot-dismiss)')
vim.keymap.set('i', '<M-J>', '<Plug>(copilot-next)')
vim.keymap.set('i', '<M-K>', '<Plug>(copilot-previous)')
vim.g.copilot_no_tab_map = true
vim.g.copilot_workspace_folders = {"H:/L10/server/game", "H:/L10/Development/QnMobile/Assets/Scripts/lua"}

--------------------------copilot end----------------------------

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
vim.opt.writebackup = true
vim.opt.swapfile = false
vim.opt.undofile = false

vim.opt.backspace = "indent,eol,start"

vim.opt.lines = 50
vim.opt.columns = 200
vim.opt.linespace = 1

vim.cmd("colorscheme tokyonight")
vim.opt.termguicolors = true
vim.o.background = "dark"
vim.o.guifont = "Consolas:h12"
vim.opt.title = true

--[[
vim.opt.autoread = true
vim.opt.updatetime = 2000
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

vim.keymap.set({'n', 'v'}, '<C-j>', ':resize +5<CR>', {silent = true, noremap = true})
vim.keymap.set({'n', 'v'}, '<C-k>', ':resize -5<CR>', {silent = true, noremap = true})
vim.keymap.set({'n', 'v', 'i'}, '<C-h>', ':vertical resize -10<CR>', {silent = true, noremap = true})
vim.keymap.set({'n', 'v', 'i'}, '<C-l>', ':vertical resize +10<CR>', {silent = true, noremap = true})

vim.keymap.set('i', '<A-j>', '<Down>', {silent = true, noremap = true})
vim.keymap.set('i', '<A-k>', '<Up>', {silent = true, noremap = true})
vim.keymap.set('i', '<A-h>', '<Left>', {silent = true, noremap = true})
vim.keymap.set('i', '<A-l>', '<Right>', {silent = true, noremap = true})

vim.keymap.set('n', '<C-t>', ':tabnew<CR>', {silent = true, noremap = true})

vim.keymap.set('n', '<A-e>', function()
    vim.cmd("silent :!start explorer %:p:h")
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
			vim.cmd("!runtime_check " .. process .. " " .. file)
			return
		end
	end
end, {silent = true, noremap = true, desc = "Check file"})
--------------------------keymaps end----------------------------
