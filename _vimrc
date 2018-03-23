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
set rtp+=$HOME/vimfiles/bundle/Vundle.vim/
call vundle#begin('$HOME/vimfiles/bundle/')

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
Plugin 'vim-scripts/a.vim'

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

"Plugin 'SuperTab'
Plugin 'dyng/ctrlsf.vim'
let g:ctrlsf_ackprg='ag'
let g:ctrlsf_auto_close=0
let g:ctrlsf_case_sensitive='no'
let g:ctrlsf_default_view_mode='compact'
let g:ctrlsf_ignore_dir=['tags']
let g:ctrlsf_default_root='cwd'

Plugin 'Valloric/YouCompleteMe'
let g:ycm_min_num_of_chars_for_completion=2
let g:ycm_semantic_triggers={
			\ 'c' : ['->', '.'],
			\ 'lua' : ['.', ':'],
			\}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

"endvundle-----------------------------------------------------------------------

set backspace=2		" more powerful backspacing

set encoding=utf-8
"set fileencodings=ucs-bom,utf-8,utf-16,gb2312,gbk,big5,gb18030,latin1
"set fileencodings=ucs-bom,utf-8,gb2312,gbk,big5,gb18030,cp936
set fileencodings=ucs-bom,utf-8,chinese

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

set tags=tags;
"set autochdir

"set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar
set guioptions-=L

map <silent> <C-j> :resize+5<CR>
map <silent> <C-k> :resize-5<CR> 
map <silent> <C-h> :vertical resize-5<CR>
map <silent> <C-l> :vertical resize+5<CR>

map <silent> <C-Up> :resize-5<CR>
map <silent> <C-Down> :resize+5<CR> 
map <silent> <C-Left> :vertical resize-5<CR>
map <silent> <C-Right> :vertical resize+5<CR>
map <silent> <C-tab> :tabn<CR>

map <silent> <C-n> :NERDTreeToggle<CR>
map <silent> <C-m> :TlistToggle<CR>

nmap <C-f> <Plug>CtrlSFCwordPath
vmap <C-f> <Plug>CtrlSFVwordPath
"nmap     <C-f>f <Plug>CtrlSFPrompt
"vmap     <C-f>f <Plug>CtrlSFVwordPath
"vmap     <C-f>F <Plug>CtrlSFVwordExec
"nmap     <C-f>n <Plug>CtrlSFCwordPath
"nmap     <C-f>p <Plug>CtrlSFPwordPath
"nnoremap <C-f>o :CtrlSFOpen<CR>
"nnoremap <C-f>t :CtrlSFToggle<CR>
"inoremap <C-f>t <Esc>:CtrlSFToggle<CR>

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
nmap <S-r> :call ReloadServer()<CR>

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
endfunction
nmap <S-t> :call CheckServer()<CR>

"server check
function RuntimeCheckServer()
	if match(expand("%:p"),"master") != -1
		exec "!runtime_check master " . expand("%:p")
	elseif match(expand("%:p"),"gas") != -1
		exec "!runtime_check gas " . expand("%:p")
	elseif match(expand("%:p"),"common") != -1
		exec "!runtime_check master " . expand("%:p")
		exec "!runtime_check gas " . expand("%:p")
	endif
endfunction
nmap <S-y> :call RuntimeCheckServer()<CR>


"open folder of current file
function Folder()
	silent exec "!explorer " . expand("%:h")
endfunction
nmap <silent> <S-e> :call Folder()<CR>

"swtich between inc and mgr
function SwitchInc()
	if match(expand("%"),"Inc\.lua") != -1
		execute "edit " . substitute(expand("%"), 'Inc\.lua', '\.lua', "")
	else
		execute "edit " . substitute(expand("%"), '\.lua', 'Inc\.lua', "")
	endif
endfunction

nmap <S-a> :call SwitchInc()<CR>