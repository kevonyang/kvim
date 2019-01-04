source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
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

Plugin 'vim-scripts/taglist.vim'
let Tlist_Show_One_File=1
let Tlist_Use_Right_Window=1
let Tlist_GainFocus_On_ToggleOpen=1
let Tlist_Close_On_Select=1

Plugin 'ctrlpvim/ctrlp.vim'
let g:ctrlp_working_path_mode = 'wa'
let g:ctrlp_custom_ignore={
    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|so|dll|xls|xlsx|doc|docx|meta|bytes|ppt|pptx|xml|pdb|pem|config|jsx|include|bat|ini|txt|ddef|release|gradle|java|m|cmd)$',
    \ }

Plugin 'dyng/ctrlsf.vim'
let g:ctrlsf_ackprg='ag'
let g:ctrlsf_absolute_file_path=0
let g:ctrlsf_auto_close=0
let g:ctrlsf_case_sensitive='no'
let g:ctrlsf_default_view_mode='compact'
let g:ctrlsf_ignore_dir=['tags']
let g:ctrlsf_default_root='cwd'
let g:ctrlsf_search_mode='async'
let g:ctrlsf_parse_speed=200
let g:ctrlsf_context='-C 0'

"Plugin 'dkprice/vim-easygrep'
"let g:EasyGrepCommand=0
"let g:EasyGrepRoot="cwd"
"let g:EasyGrepIgnoreCase=1
"let g:EasyGrepRecursive=1
"let g:EasyGrepSearchCurrentBufferDir=0
"let g:EasyGrepFilesToExclude="tags"

"if executable('ag')
"  set grepprg=ag\ --nogroup\ --nocolor
"endif

"Plugin 'Shougo/neocomplete.vim'
"let g:acp_enableAtStartup=0
"let g:neocomplete#enable_at_startup=1
"let g:neocomplete#enable_smart_case=1
"let g:neocomplete#sources#syntax#min_keyword_length=3
"let g:neocomplete#sources#dictionary#dictionaries={
"    \ 'default' : '',
"    \ 'vimshell' : $HOME.'/.vimshell_hist',
"    \ 'scheme' : $HOME.'/.gosh_completions'
"\ }
" Define keyword.
"if !exists('g:neocomplete#keyword_patterns')
"    let g:neocomplete#keyword_patterns={}
"endif
"let g:neocomplete#keyword_patterns['default']='\h\w*'

"Plugin 'Valloric/YouCompleteMe'
"let g:ycm_min_num_of_chars_for_completion=2
"let g:ycm_semantic_triggers={
"\ 'c' : ['->', '.'],
"\ 'lua' : ['.', ':'],
"\}

"Plugin 'vim-scripts/AutoComplPop'

Plugin 'ervandew/supertab'
let g:SuperTabDefaultCompletionType='context'

Plugin 'vim-scripts/a.vim'

Plugin 'easymotion/vim-easymotion'
Plugin 'terryma/vim-multiple-cursors'
let g:multi_cursor_use_default_mapping=0

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"endvundle-----------------------------------------------------------------------

set backspace=2		" more powerful backspacing

set encoding=utf-8
"set fileencodings=ucs-bom,utf-8,utf-16,gb2312,gbk,big5,gb18030,latin1
"set fileencodings=ucs-bom,utf-8,gb2312,gbk,big5,gb18030,cp936
set fileencodings=ucs-bom,utf-8,chinese
"set nobomb

set langmenu=zh_CN.UTF-8
let $LANG='zh_CN.UTF-8'
"language message zh_CN.UTF-8

source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

colorscheme desert
syntax enable
syntax on

set lines=50 columns=200 linespace=1
set background=dark
set guifont=consolas:h11:cANSI
"set guifontwide=NSimSun:h10:cANSI

set foldenable
set foldmethod=manual

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

set ruler

set laststatus=2

set number

set exrc
set secure

set cursorline
"set cursorcolumn 

set tags=./tags;,tags;
"set autochdir

set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar
set guioptions-=L
set guioptions-=e  "tab

set winaltkeys=no

map <silent> <C-j> :resize+5<CR>
map <silent> <C-k> :resize-5<CR> 
map <silent> <C-h> :vertical resize-10<CR>
map <silent> <C-l> :vertical resize+10<CR>

map <silent> <C-Up> :resize-5<CR>
map <silent> <C-Down> :resize+5<CR> 
map <silent> <C-Left> :vertical resize-10<CR>
map <silent> <C-Right> :vertical resize+10<CR>

map <silent> <C-t> :tabnew<CR>
map <silent> <C-n> :NERDTreeToggle<CR>
map <silent> <C-b> :TlistToggle<CR>

nmap <C-f> <Plug>CtrlSFCwordPath
vmap <C-f> <Plug>CtrlSFVwordPath
nmap <S-f> <Plug>CtrlSFPrompt
"nmap     <C-f>f <Plug>CtrlSFPrompt
"vmap     <C-f>f <Plug>CtrlSFVwordPath
"vmap     <C-f>F <Plug>CtrlSFVwordExec
"nmap     <C-f>n <Plug>CtrlSFCwordPath
"nmap     <C-f>p <Plug>CtrlSFPwordPath
"nnoremap <C-f>o :CtrlSFOpen<CR>
"nnoremap <C-f>t :CtrlSFToggle<CR>
"inoremap <C-f>t <Esc>:CtrlSFToggle<CR>

map f <Plug>(easymotion-prefix)

let g:multi_cursor_start_word_key      = '<A-n>'
let g:multi_cursor_select_all_word_key = '<A-a>'
let g:multi_cursor_start_key           = 'g<A-n>'
let g:multi_cursor_select_all_key      = 'g<A-a>'
let g:multi_cursor_next_key            = '<A-n>'
let g:multi_cursor_prev_key            = '<A-p>'
let g:multi_cursor_skip_key            = '<A-x>'
let g:multi_cursor_quit_key            = '<Esc>'

function GenerateCtags()
	silent exec "!ctags -R " . getcwd()
endfunction
nmap <M-t> :call GenerateCtags()<CR>

"run server
function RunServer()
	silent exec "!runserver"
endfunction
nmap <F5> :call RunServer()<CR>

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
	elseif match(expand("%:p"),"common") != -1
		exec "!check master " . expand("%:t")
		exec "!check gas " . expand("%:t")
	endif
	if match(expand("%:p"),"master") != -1
		exec "!runtime_check master " . expand("%:p")
	elseif match(expand("%:p"),"gas") != -1
		exec "!runtime_check gas " . expand("%:p")
	elseif match(expand("%:p"),"common") != -1
		exec "!runtime_check master " . expand("%:p")
		exec "!runtime_check gas " . expand("%:p")
	endif
endfunction
nmap <M-c> :call CheckServer()<CR>

"open folder of current file
function Folder()
	silent exec "!explorer " . expand("%:h")
endfunction
nmap <silent> <M-e> :call Folder()<CR>

"swtich between inc and mgr
function SwitchInc()
	if match(expand("%"),"Inc\.lua") != -1
		execute "edit " . substitute(expand("%"), 'Inc\.lua', '\.lua', "")
	else
		execute "edit " . substitute(expand("%"), '\.lua', 'Inc\.lua', "")
	endif
endfunction
nmap <M-i> :call SwitchInc()<CR>
