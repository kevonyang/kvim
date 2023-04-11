set encoding=utf-8
"set fileencodings=ucs-bom,utf-8,utf-16,gb2312,gbk,big5,gb18030,latin1
"set fileencodings=ucs-bom,utf-8,gb2312,gbk,big5,gb18030,cp936
set fileencodings=ucs-bom,utf-8,chinese
"set nobomb
set langmenu=zh_CN.UTF-8
let $LANG='zh_CN.UTF-8'
"language message zh_CN.UTF-8

"source $VIMRUNTIME/vimrc_example.vim
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


"vundle-----------------------------------------------------------------------
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=$HOME/.vim/bundle/Vundle.vim/
call vundle#begin('$HOME/.vim/bundle/')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'scrooloose/nerdtree'
let g:NERDTreeChDirMode=2
map <silent> <C-n> :NERDTreeToggle<CR>
map <silent> <M-f> :NERDTreeFind<CR>

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

function GenerateCtags()
	silent! exec '!ctags -R ' . getcwd()
	silent! exec '!cscope -Rbq'
endfunction
nmap <leader>su :call GenerateCtags()<CR>

Plugin 'vim-scripts/taglist.vim'
let Tlist_Show_One_File=1
let Tlist_Use_Right_Window=1
let Tlist_GainFocus_On_ToggleOpen=1
let Tlist_Close_On_Select=1
map <silent> <M-t> :TlistToggle<CR>

Plugin 'Yggdroot/LeaderF'
let g:Lf_HideHelp = 1
let g:Lf_UseCache = 0
let g:Lf_UseVersionControlTool = 0
let g:Lf_DefaultExternalTool = 'rg'
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_WindowPosition = 'popup'
let g:Lf_PopupPosition = [0,0]
let g:Lf_PreviewInPopup = 1
let g:Lf_WindowHeight = 0.30
let g:Lf_StlSeparator = { 'left': '', 'right': '' , 'font': '' }
let g:Lf_PreviewResult = {
	\ 'File': 0,
	\ 'Buffer': 0,
	\ 'Mru': 0,
	\ 'Tag': 0,
	\ 'BufTag': 1,
	\ 'Function': 1,
	\ 'Line': 0,
	\ 'Colorscheme': 0,
	\ 'Rg': 0,
	\ 'Gtags': 0
	\}
let g:Lf_WildIgnore = {
	\ 'dir': ['.svn','.git','.hg'],
    \ 'file': ['*.bak','*.exe','*.o','*.so','*.dll','*.sln','*.sdf','*.opensdf','*.suo','*.vcxproj','*.filters','*.xls','*.xlsx','*.doc','*.docx','*.ppt','*.pptx','*.meta','*.bytes','*.pdb','*.out','tags']
	\}
let g:Lf_WorkingDirectoryMode = 'c'
let g:Lf_RootMarkers = []
let g:Lf_ShortcutF = '<C-P>'
noremap <leader>fb :<C-U><C-R>=printf("Leaderf buffer %s", "")<CR><CR>
noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>

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

"Plugin 'ctrlpvim/ctrlp.vim'
"let g:ctrlp_working_path_mode = 'wa'
"let g:ctrlp_custom_ignore={
"    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
"    \ 'file': '\v\.(exe|so|dll|xls|xlsx|doc|docx|meta|bytes|ppt|pptx|xml|pdb|pem|config|jsx|include|bat|ini|txt|ddef|release|gradle|java|m|cmd)$',
"    \ }

"Plugin 'dyng/ctrlsf.vim'
"let g:ctrlsf_ackprg='rg'
"let g:ctrlsf_absolute_file_path=0
"let g:ctrlsf_auto_close=0
"let g:ctrlsf_case_sensitive='no'
"let g:ctrlsf_default_view_mode='compact'
"let g:ctrlsf_ignore_dir=['tags']
"let g:ctrlsf_default_root='cwd'
"let g:ctrlsf_search_mode='async'
"let g:ctrlsf_parse_speed=200
"let g:ctrlsf_context='-C 3'

"nmap <C-f> <Plug>CtrlSFPrompt
"nmap <S-f> <Plug>CtrlSFCwordPath
"vmap <S-f> <Plug>CtrlSFVwordPath
"nmap <M-f> :CtrlSFToggle<CR>

"nmap     <C-f>f <Plug>CtrlSFPrompt
"vmap     <C-f>f <Plug>CtrlSFVwordPath
"vmap     <C-f>F <Plug>CtrlSFVwordExec
"nmap     <C-f>n <Plug>CtrlSFCwordPath
"nmap     <C-f>p <Plug>CtrlSFPwordPath
"nnoremap <C-f>o :CtrlSFOpen<CR>
"nnoremap <C-f>t :CtrlSFToggle<CR>
"inoremap <C-f>t <Esc>:CtrlSFToggle<CR>

"Plugin 'mileszs/ack.vim'
"Plugin 'vim-scripts/a.vim'

Plugin 'ervandew/supertab'
let g:SuperTabDefaultCompletionType='context'

Plugin 'easymotion/vim-easymotion'
map f <Plug>(easymotion-prefix)

Plugin 'terryma/vim-multiple-cursors'
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_start_word_key      = '<A-n>'
let g:multi_cursor_select_all_word_key = '<A-a>'
let g:multi_cursor_start_key           = 'g<A-n>'
let g:multi_cursor_select_all_key      = 'g<A-a>'
let g:multi_cursor_next_key            = '<A-n>'
let g:multi_cursor_prev_key            = '<A-p>'
let g:multi_cursor_skip_key            = '<A-x>'
let g:multi_cursor_quit_key            = '<Esc>'
set selection=inclusive

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"endvundle-----------------------------------------------------------------------


"colorscheme solarized
colorscheme desert
syntax enable
syntax on

set lines=50 columns=200 linespace=1
set background=dark
set guifont=consolas:h10.5:cANSI
"set guifontwide=NSimSun:h10:cANSI

set foldmethod=indent
set nofoldenable

set backspace=2		" more powerful backspacing
set tabstop=4
set shiftwidth=4
set softtabstop=4
"set expandtab
set autoindent

set noundofile
set nobackup
set noswapfile
set ignorecase

set hlsearch
set incsearch
set showmatch
set wildmenu

"set nowrapscan
set noendofline

set ruler

set statusline=%F%m%r%h%w%=\ [FORMAT=%{&ff}:%{(&fenc!=\"\"?&fenc:&enc).((exists(\"+bomb\")\ &&\ &bomb)?\"+\":\"\")}]\ [ASCII=%03.3b]\ [POS=%l,%v\ \ %p%%]
set laststatus=2

set number

set exrc
set secure

set cursorline
"set cursorcolumn 

"set splitbelow
"set splitright

set tags=./tags;,tags;
"set autochdir
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

"use continuous paste(xnoremap p "0p)
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
	if match(expand("%:p"),"master") != -1
		exec "!reload master " . expand("%:t")
	elseif match(expand("%:p"),"gas") != -1
		exec "!reload gas " . expand("%:t")
	elseif match(expand("%:p"),"common") != -1
		exec "!reload master " . expand("%:t")
		exec "!reload gas " . expand("%:t")
	endif
endfunction
nmap <M-r> :call ReloadServer()<CR>

"server check
function CheckServer()
	if match(expand("%:p"),"master") != -1
		exec "!check master " . expand("%:t")
	elseif match(expand("%:p"),"gas") != -1
		exec "!check gas " . expand("%:t")
	elseif match(expand("%:p"),"login") != -1
		exec "!check login " . expand("%:t")
	elseif match(expand("%:p"),"common") != -1
		exec "!check master " . expand("%:t")
		exec "!check gas " . expand("%:t")
		exec "!check login " . expand("%:t")
	endif
	if match(expand("%:p"),"master") != -1
		exec "!runtime_check master " . expand("%:t")
	elseif match(expand("%:p"),"gas") != -1
		exec "!runtime_check gas " . expand("%:t")
	elseif match(expand("%:p"),"login") != -1
		exec "!runtime_check login " . expand("%:t")
	elseif match(expand("%:p"),"common") != -1
		exec "!runtime_check master " . expand("%:t")
		exec "!runtime_check gas " . expand("%:t")
		exec "!runtime_check login " . expand("%:t")
	endif
endfunction
nmap <M-c> :call CheckServer()<CR>

"open folder of current file
function Folder()
	silent exec "!start " . expand("%:h")
endfunction
nmap <silent> <M-e> :call Folder()<CR>

"open folder of current file with totalcommand
function TCFolder()
	silent exec "!vimtc " . expand("%:p:h")
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
