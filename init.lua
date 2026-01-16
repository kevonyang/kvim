vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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

local function on_nvim_tree_attach(bufnr)
	local api = require "nvim-tree.api"

	local function opts(desc)
		return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
end

require("lazy").setup({
	spec = {
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			opts = {},
		},
		{
			"nvim-tree/nvim-tree.lua",
			dependencies = { 'nvim-tree/nvim-web-devicons' },
			opts = {
				on_attach = on_nvim_tree_attach,
				sync_root_with_cwd = true,
				actions = {
					change_dir = {
						enable = true,
						global = true,
						restrict_above_cwd = false,
					},
				},
			},
		},
		{
			"nvim-treesitter/nvim-treesitter",
			branch = 'master',
			lazy = false,
			build = ':TSUpdate',
			opts = {
				ensure_installed = { "c", "cpp", "lua" },
				highlight = { enable = true },
			},
		},
		{
			"nvim-telescope/telescope.nvim", tag = '0.1.8',
			dependencies = { 'nvim-lua/plenary.nvim' },
		},
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release --target install'
		},
		--[[
		{
			'ludovicchabant/vim-gutentags',
			lazy = false,
		},
		--]]
		{
			'ervandew/supertab',
		},
		{
			'ggandor/leap.nvim',
			keys = { 's', 'S' },
			config = function()
				require('leap').add_default_mappings()
			end,
		},
		--[[
		{
			"mason-org/mason.nvim",
			config = true,
		},
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {
				ensure_installed = { "lua_ls", "pyright" },
				automatic_enable = true,
			},
			dependencies = {
				"mason-org/mason.nvim",
				"neovim/nvim-lspconfig",
			},
		},
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-path" },
		{ 'hrsh7th/nvim-cmp' },
		{ 'hrsh7th/cmp-vsnip' },
		{ 'hrsh7th/vim-vsnip' },
		--]]
		{ 'github/copilot.vim' },
		{
			"folke/tokyonight.nvim",
			lazy = false,
			priority = 1000,
			opts = {},
		},
	},
	install = {},
	checker = {
		enabled = false,
		notify = false,
	},
})
--------------------------lazy.nvim end----------------------------

--------------------------tags begin----------------------------
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
--------------------------tags end----------------------------

--------------------------gutentags begin----------------------------
--[[
-- 安装插件后加入这些设置
local cache_dir = vim.fn.stdpath('cache')
vim.fn.mkdir(cache_dir .. '/tags', 'p')

vim.g.gutentags_enabled = 1
vim.g.gutentags_cache_dir = cache_dir .. '/tags'
vim.g.gutentags_modules = {'ctags'}
vim.g.gutentags_ctags_executable = 'ctags'
vim.g.gutentags_ctags_extra_args = {'--languages=Lua,Python,JavaScript', '--fields=+ailmnS', '--extras=+q', '--sort=no'}
-- 使用 rg 提速（需安装 ripgrep）
vim.g.gutentags_file_list_command = 'rg --files --hidden --glob "!.git" --glob "!.svn" --glob "!node_modules" --glob "*.lua" --glob "*.py" --glob "*.js"'

vim.g.gutentags_project_root = {'.svn', '.git', '.project', 'Makefile'}
vim.g.gutentags_add_default_project_roots = 0

local allowed_roots = {
  "H:/L10/server/game",
  "H:/L10/Development/QnMobile/Assets/Scripts/lua",
}
_G.gutentags_allowed_root_finder = function(filepath)
	if not filepath or filepath == '' then return '' end
	local dir = vim.fn.fnamemodify(filepath, ':p:h')
	dir = dir:gsub('\\', '/')
    for _, r in ipairs(allowed_roots) do
		if vim.startswith(dir:lower(), r:lower()) then
			return r
		end
    end
	return ''
end
vim.g.gutentags_project_root_finder = 'v:lua.gutentags_allowed_root_finder'
--]]
--------------------------gutentags end----------------------------

--------------------------telescope begin----------------------------
local telescope = require('telescope')
local actions = require('telescope.actions')
local layout = require('telescope.actions.layout')
telescope.setup({
	defaults = {
		file_ignore_patterns = {
			"node_modules",
			"%.png$", "%.jpg$", "%.jpeg$", "%.gif$",
			".git/", ".svn/", ".hg/",
			"tags", "vendor", "build", "dist",
			"%.map$", "%.tlog$", "%.meta$", "%.bytes$", "%.bak$",
			"%.exe$", "%.dll$", "%.o$", "%.obj$", "%.pdb$", "%.lib$",
			"%.xls$", "%.xlsx$", "%.doc$", "%.docx$", "%.pdf$", "%.ppt$", "%.pptx$",
			"%.out$",
		},
		preview = { hide_on_startup = true },
		layout_strategy = 'vertical',
		mappings = {
			i = {
				["<M-p>"] = layout.toggle_preview,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-v>"] = function(prompt_bufnr) vim.api.nvim_paste(vim.fn.getreg('+'), true, -1) end,
			},
			n = {
				["<M-p>"] = layout.toggle_preview,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-v>"] = function(prompt_bufnr) vim.api.nvim_paste(vim.fn.getreg('+'), true, -1) end,
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

--------------------------telescope end----------------------------

--------------------------cmp begin----------------------------
--[[
vim.o.completeopt = "menu,menuone,noselect"
vim.o.signcolumn = "yes"
local cmp = require 'cmp'
cmp.setup({
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
			-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
		end,
	},
    window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
      	['<C-Space>'] = cmp.mapping.complete(),
      	['<C-e>'] = cmp.mapping.abort(),
      	['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			--elseif luasnip.expand_or_jumpable() then
			--	luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			--elseif luasnip.jumpable(-1) then
			--	luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
      	{ name = 'vsnip' }, -- For vsnip users.
      	-- { name = 'luasnip' }, -- For luasnip users.
	},
	{
		{ name = 'buffer' },
    }),
	-- 可选：自动完成时显示来源
	formatting = {
		format = function(entry, vim_item)
		  vim_item.menu = ({
			buffer = "[buf]",
			nvim_lsp = "[LSP]",
			luasnip = "[snip]",
			path = "[path]",
		  })[entry.source.name]
		  return vim_item
		end,
	},
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = 'path' }
	},
	{
		{ name = 'cmdline' }
	}),
	matching = { disallow_symbol_nonprefix_matching = false }
})
--]]
--------------------------cmp end----------------------------

--------------------------lspconfig begin----------------------------
--[[
-- 基础 capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- 用nvim-cmp，使用它提供的 helper 来补全 capabilities
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.project', '.git', '.luarc.json', '.luarc.jsonc' },
  settings = {
    Lua = {
		runtime = {
			version = 'LuaJIT',
			path = vim.split(package.path, ';'),
		},
		workspace = {
			-- preloadFileSize 单位为 KB（例如 2000 = 2MB）
			preloadFileSize = 1000,
			-- 可选：预加载最大文件数
			maxPreload = 2000,
			-- 把 Neovim runtimepath 加进 library，以便识别内置全局/模块
			library = vim.api.nvim_get_runtime_file("", true),
			-- 禁用第三方库检查
			checkThirdParty = false,
		},
		diagnostics = {
			globals = {"vim"},
		},
		telemetry = { enable = false },
    }
  }
})

vim.lsp.enable('lua_ls')
--]]
--------------------------lspconfig end----------------------------

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
vim.opt.autoread = true

vim.opt.backspace = "indent,eol,start"

vim.opt.lines = 50
vim.opt.columns = 200
vim.opt.linespace = 1

vim.cmd("colorscheme tokyonight")
vim.opt.termguicolors = true
vim.o.background = "dark"
vim.o.guifont = "Consolas:h12"


vim.opt.autoread = true
vim.opt.updatetime = 1000

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


vim.opt.title = true

local function set_term_title()
	local name = vim.fn.expand("%:p")    -- 完整路径, 用 "%:t" 获取文件名
	if name == "" then name = "[No Name]" end
	if vim.bo.modified then name = name .. " [+]" end
	vim.opt.titlestring = name
end

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "BufWritePost", "BufModifiedSet", "FileChangedShellPost" },
{
	pattern = "*",
	callback = set_term_title
})
-- 进程刚启动时也设置一次
set_term_title()

--[[
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = 'init.lua',
  command = 'source <afile>',
  group = vim.api.nvim_create_augroup('ReloadNvimConfig', { clear = true })
})
--]]
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

vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', {silent = true, noremap = true})
vim.keymap.set('n', '<A-f>', ':NvimTreeFindFile<CR>', {silent = true, noremap = true})

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

-- 在 LSP 客户端附加到缓冲区时设置快捷键
--[[
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		local bufmap = function(mode, lhs, rhs, desc)
			if desc then desc = "LSP: " .. desc end
			vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
		end
		-- 跳转到定义 (gd)
		bufmap('n', 'gd', builtin.lsp_definitions, "Goto definition")
		--bufmap("n", "gd", vim.lsp.buf.definition, "Goto definition")
		--bufmap("n", "gD", vim.lsp.buf.declaration, "Goto declaration")
		-- 实现 (gi)
		bufmap('n', 'gi', builtin.lsp_implementations, "Implementation")
		--bufmap("n", "gi", vim.lsp.buf.implementation, "Implementation")
		-- 类型定义 (gf)
		bufmap('n', 'gf', builtin.lsp_type_definitions, "Type definition")
		--bufmap('n', 'gf', vim.lsp.buf.type_definition, "Type definition")

		-- 查找引用 (gr)
		bufmap('n', 'gr', builtin.lsp_references, "References")
		--bufmap("n", "gr", vim.lsp.buf.references, "References")
		-- 列出文档中的符号 (gs)
		bufmap('n', 'gs', builtin.lsp_document_symbols, "Document Symbols")
		-- 列出工作区中的符号 (gS)
		bufmap('n', 'gS', builtin.lsp_dynamic_workspace_symbols, "Workspace Symbols")

		bufmap("n", "K", vim.lsp.buf.hover, "Hover docs")
		bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
		bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
		--bufmap("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format")
	end,
})
--]]


vim.keymap.set('i', '<C-j>', 'copilot#Accept("\\<CR>")', { expr = true, replace_keycodes = false })
vim.g.copilot_no_tab_map = true
vim.keymap.set('i', '<C-k>', '<Plug>(copilot-accept-word)')

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
