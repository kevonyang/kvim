set encoding=utf-8
set fileencodings=ucs-bom,utf-8,chinese
"set fileencodings=ucs-bom,utf-8,utf-16,gb2312,gbk,big5,gb18030,latin1
"set fileencodings=ucs-bom,utf-8,gb2312,gbk,big5,gb18030,cp936

set langmenu=zh_CN.UTF-8
let $LANG='zh_CN.UTF-8'

source $VIMRUNTIME/mswin.vim
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

behave mswin

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

" cscope setting
if has("cscope")
   "set csprg=/usr/bin/cscope              "指定用来执行 cscope 的命令
   set csto=1                             "先搜索tags标签文件，再搜索cscope数据库
   set cst                                "使用|:cstag|(:cs find g)，而不是缺省的:tag
   set nocsverb                           "不显示添加数据库是否成功
   " add any database in current directory
   if filereadable("cscope.out")
	  cs add cscope.out                   "添加cscope数据库
   endif
   set csverb                             "显示添加成功与否
endif
nmap <leader>ss :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <leader>sg :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader>sc :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <leader>st :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <leader>se :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <leader>sf :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <leader>si :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <leader>sd :cs find d <C-R>=expand("<cword>")<CR><CR>
nmap <leader>sa :cs find a <C-R>=expand("<cword>")<CR><CR>

" ctags setting
function GenerateCtags()
	silent! exec '!ctags -R ' . getcwd()
	silent! exec '!cscope -Rbq'
endfunction
nmap <leader>su :call GenerateCtags()<CR>


set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin()

Plug 'morhetz/gruvbox'

Plug 'preservim/nerdtree'
let g:NERDTreeChDirMode=2
map <silent> <C-n> :NERDTreeToggle<CR>
map <silent> <M-f> :NERDTreeFind<CR>

Plug 'vim-scripts/taglist.vim'
let Tlist_Show_One_File=1
let Tlist_Use_Right_Window=1
let Tlist_GainFocus_On_ToggleOpen=1
let Tlist_Close_On_Select=1
map <silent> <M-t> :TlistToggle<CR>

Plug 'ervandew/supertab'
let g:SuperTabDefaultCompletionType='context'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_theme='gruvbox'

Plug 'easymotion/vim-easymotion'
map f <Plug>(easymotion-prefix)

Plug 'github/copilot.vim'
let g:copilot_workspace_folders = ["H:/L10/server", "H:/L10/Development/QnMobile/Assets/Scripts"]
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
imap <C-K> <Plug>(copilot-accept-word)
imap <C-L> <Plug>(copilot-accept-line)
imap <C-H> <Plug>(copilot-dismiss)
imap <M-J> <Plug>(copilot-next)
imap <M-K> <Plug>(copilot-previous)
let g:copilot_no_tab_map = v:true

Plug 'Yggdroot/LeaderF', { 'do': ':LeaderfInstallCExtension' }
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_DefaultExternalTool = 'rg'
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_WindowPosition = 'popup'
let g:Lf_PopupPreviewPosition = 'top'
let g:Lf_WildIgnore = {
	\'dir': [
		\'.svn',
		\'.git',
		\'.hg',
		\'node_modules'
	\],
    \'file': [
		\'*.map',
		\'*.tlog',
		\'*.bak',
		\'*.exe',
		\'*.o',
		\'*.so',
		\'*.dll',
		\'*.sln',
		\'*.sdf',
		\'*.opensdf',
		\'*.suo',
		\'*.vcxproj',
		\'*.filters',
		\'*.meta',
		\'*.bytes',
		\'*.obj',
		\'*.pdb',
		\'*.out'
	\]
\}
let g:Lf_WorkingDirectoryMode = 'c'
let g:Lf_RootMarkers = []
let g:Lf_ShortcutF = '<C-P>'
noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>

let g:Lf_RgConfig = [
	\ "--max-columns-preview",
	\ "--hidden",
	\ "--glob=!.svn/*",
	\ "--glob=!.git/*",
	\ "--glob=!node_modules/*",
	\ "--glob=!*.map",
	\ "--glob=!*.tlog",
	\ "--glob=!*.meta",
	\ "--glob=!*.bytes",
	\ "--glob=!*.obj"
	\]
noremap <leader>ff :<C-U><C-R>=printf("Leaderf! rg -e ")<CR>
noremap <C-F> :<C-U><C-R>=printf("Leaderf! rg -F ")<CR>
nnoremap <S-F> :<C-U><C-R>=printf("Leaderf! rg -F %s", expand("<cword>"))<CR>
vnoremap <S-F> :<C-U><C-R>=printf("Leaderf! rg -F %s", leaderf#Rg#visual())<CR>
noremap <C-B> :<C-U><C-R>=printf("Leaderf! rg --current-buffer -F %s", expand("<cword>"))<CR>
noremap <C-G> :<C-U>Leaderf! rg --recall<CR>

let g:Lf_GtagsAutoGenerate = 0
let g:Lf_Gtagslabel = 'native-pygments'
noremap <leader>fr :<C-U><C-R>=printf("Leaderf! gtags -r %s", expand("<cword>"))<CR><CR>
noremap <leader>fd :<C-U><C-R>=printf("Leaderf! gtags -d %s --auto-jump", expand("<cword>"))<CR><CR>
noremap <leader>fo :<C-U><C-R>=printf("Leaderf! gtags --recall %s", "")<CR><CR>
noremap <leader>fn :<C-U><C-R>=printf("Leaderf gtags --next %s", "")<CR><CR>
noremap <leader>fp :<C-U><C-R>=printf("Leaderf gtags --previous %s", "")<CR><CR>
noremap <leader>fu :<C-U><C-R>=printf("Leaderf gtags --update")<CR><CR>

call plug#end()

filetype plugin on    " required
filetype indent on    " required

syntax enable
syntax on
colorscheme gruvbox

set lines=50 columns=200 linespace=1
set background=dark
set guifont=consolas:h12:cANSI

set foldmethod=indent
set nofoldenable

set backspace=2		" more powerful backspacing
set tabstop=4
set shiftwidth=4
set softtabstop=4
set autoindent

set noundofile
set nobackup
set noswapfile
set ignorecase

set hlsearch
set incsearch
set showmatch
set wildmenu

set noendofline

set ruler

set laststatus=2

set exrc
set secure

set number
set cursorline
"set cursorcolumn 

set tags=./tags;,tags;
set clipboard+=unnamed
set paste

set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar
set guioptions-=L
set guioptions-=b
set guioptions-=e  "tab

set winaltkeys=no

"未开启 IME 时光标背景色
highlight Cursor guifg=slategrey guibg=khaki gui=NONE
"开启IME 时光标背景色
highlight CursorIM guifg=NONE guibg=SkyBlue gui=NONE
"关闭Vim的自动切换 IME 输入法(插入模式和检索模式)
set iminsert=0
set imsearch=-1

"continuous paste(xnoremap p "0p)
xnoremap p pgvy

inoremap <M-j> <Down>
inoremap <M-k> <Up>
inoremap <M-h> <left>
inoremap <M-l> <Right>

map <silent> <C-j> :resize+5<CR>
map <silent> <C-k> :resize-5<CR> 
map <silent> <C-h> :vertical resize-10<CR>
map <silent> <C-l> :vertical resize+10<CR>

map <silent> <C-Up> :resize-5<CR>
map <silent> <C-Down> :resize+5<CR> 
map <silent> <C-Left> :vertical resize-10<CR>
map <silent> <C-Right> :vertical resize+10<CR>

map <silent> <C-t> :tabnew<CR>

"open folder of current file
function Folder()
	silent exec "!start " . expand("%:h")
endfunction
nmap <silent> <M-e> :call Folder()<CR>

"open folder of current file with totalcommand
function TCFolder()
	silent exec "!start Totalcmd64.exe /O /T /L=" . expand("%:p:h")
endfunction
nmap <silent> <M-d> :call TCFolder()<CR>

"switch between inc and mgr
function SwitchInc()
	if match(expand("%"),"Inc\.lua") != -1
		execute "edit " . substitute(expand("%"), 'Inc\.lua', '\.lua', "")
	else
		execute "edit " . substitute(expand("%"), '\.lua', 'Inc\.lua', "")
	endif
endfunction
nmap <M-i> :call SwitchInc()<CR>


"run server
function RunServer()
	silent exec "!start runserver"
endfunction
nmap <F3> :call RunServer()<CR>

function RunServer_3D()
	silent exec "!start run3dserver"
endfunction
nmap <F4> :call RunServer_3D()<CR>

"close server
function CloseServer()
	silent exec "!start closeserver"
endfunction
nmap <F6> :call CloseServer()<CR>

"server reload, only master and gas
function ReloadServer()
	let processes = ["master", "gas", "login", "ship", "house_db", "database"]
	let pathStr = expand("%:p")
    let fileName = expand("%:t")

	for process in processes
		if stridx(pathStr,process) != -1
			exec "silent !reload " . process . " " . fileName
			echo "reloaded " . process . " " . fileName
			return
		endif
	endfor
endfunction
nmap <silent> <M-r> :call ReloadServer()<CR>

"server check
function CheckServer()
	let processes = ["master", "gas", "login", "ship", "house_db", "database"]
	let pathStr = expand("%:p")
	let fileName = expand("%:t")

	for process in processes
		if stridx(pathStr,process) != -1
			exec "silent !check " . process . " " . fileName
			echo "checked " . process . " " . fileName
			return
		endif
	endfor

	if stridx(pathStr, "common") != -1
		for process in ["master", "gas", "login"]
			exec "silent !check " . process . " " . fileName . " common"
			echo "checked " . process . " " . fileName . " common"
		endfor
		return
	endif
endfunction
nmap <silent> <M-c> :call CheckServer()<CR>

"kevon's vim edit
function KVimEdit(argName)
	let argFile = ""
	let argFolder = "."
	if a:argName == "_vimrc"
		let argFolder = "C:\\Users\\hzyangkai1"
		let argFile = argFolder . "\\_vimrc"
	elseif a:argName == "design"
		let argFolder = "H:\\L10\\design\\"
		let argFile = argFolder
	elseif a:argName == "server"
		let argFolder = "H:\\L10\\server\\"
		let argFile = argFolder
	elseif a:argName == "game"
		let argFolder = "H:\\L10\\server\\game\\"
		let argFile = argFolder
	elseif a:argName == "lua"
		let argFolder = "H:\\L10\\Development\\QnMobile\\Assets\\Scripts\\lua\\"
		let argFile = argFolder
	elseif a:argName == "patch"
		let argFolder = "H:\\L10\\patch\\"
		let argFile = argFolder
	elseif a:argName == "pdef"
		let argFolder = "H:\\L10\\server\\engine\\src\\ArkCodeGen\\Properties\\"
		let argFile = argFolder
	elseif a:argName == "ddef"
		let argFolder = "H:\\L10\\Development\\BinaryDesignDataGen\\"
		let argFile = argFolder
	elseif a:argName == "logdef"
		let argFolder = "H:\\L10\\server\\tools\\autoGen\\log\\"
		let argFile = argFolder
	elseif a:argName == "gmcmddef"
		let argFolder = "H:\\L10\\server\\tools\\autoGen\\GmCodeGen\\"
		let argFile = argFolder
	elseif a:argName == "mywork"
		let argFolder = "H:\\mywork"
		let argFile = argFolder
	endif

	silent exec "cd " . argFolder
	silent exec "edit " . argFile
endfunction
function KVimEditComplete(ArgLead, CmdLine, CursorPos)
	return "_vimrc\ndesign\nserver\ngame\nlua\npatch\npdef\nddef\nlogdef\ngmcmddef\nmywork\n"
endfunction
:command -nargs=+ -complete=custom,KVimEditComplete KEdit :call KVimEdit(<f-args>)

"kevon's vim run
function KVimRun(argName)
	let currentDir = getcwd()
	if a:argName == "3dall"
		silent exec "!start run3dserver"
	elseif a:argName == "all"
		silent exec "!start runserver"
	elseif a:argName == "3dgas"
		silent exec "!start run3dgas"
	elseif a:argName == "gas"
		silent exec "!start rungas"
	elseif a:argName == "gui"
		silent exec "cd H:\\L10\\design\\data"
		silent exec "!start 策划工具GUI.bat"
		silent exec "cd " . currentDir
	elseif a:argName == "newgmt"
		silent exec "cd H:\\L10\\GMTool\\NewGMT"
		silent exec "!start NewGMT.exe"
		silent exec "cd " . currentDir
	elseif a:argName == "patchcenter"
		silent exec "cd H:\\L10\\patch\\patchcenter"
		silent exec "!start patchcenter"
		silent exec "cd " . currentDir
	endif
endfunction
function KVimRunComplete(ArgLead, CmdLine, CursorPos)
	return "3dall\nall\n3dgas\ngas\ngui\nnewgmt\npatchcenter\n"
endfunction
:command -nargs=+ -complete=custom,KVimRunComplete KRun :call KVimRun(<f-args>)
