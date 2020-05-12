set encoding=utf-8
"set fileencodings=ucs-bom,utf-8,utf-16,gb2312,gbk,big5,gb18030,latin1
"set fileencodings=ucs-bom,utf-8,gb2312,gbk,big5,gb18030,cp936
set fileencodings=ucs-bom,utf-8,chinese
"set nobomb
set langmenu=zh_CN.UTF-8
let $LANG='zh_CN.UTF-8'
"language message zh_CN.UTF-8

source $VIMRUNTIME/vimrc_example.vim
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

Plugin 'mileszs/ack.vim'

Plugin 'dyng/ctrlsf.vim'
let g:ctrlsf_ackprg='rg'
let g:ctrlsf_absolute_file_path=0
let g:ctrlsf_auto_close=0
let g:ctrlsf_case_sensitive='no'
let g:ctrlsf_default_view_mode='compact'
let g:ctrlsf_ignore_dir=['tags']
let g:ctrlsf_default_root='cwd'
let g:ctrlsf_search_mode='async'
let g:ctrlsf_parse_speed=200
let g:ctrlsf_context='-C 0'

Plugin 'ervandew/supertab'
let g:SuperTabDefaultCompletionType='context'

Plugin 'vim-scripts/a.vim'

Plugin 'easymotion/vim-easymotion'
map f <Plug>(easymotion-prefix)

Plugin 'terryma/vim-multiple-cursors'
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_start_word_key      = '<A-n>'
let g:multi_cursor_select_all_word_key = '<A-m>'
let g:multi_cursor_start_key           = 'g<A-n>'
let g:multi_cursor_select_all_key      = 'g<A-m>'
let g:multi_cursor_next_key            = '<A-n>'
let g:multi_cursor_prev_key            = '<A-p>'
let g:multi_cursor_skip_key            = '<A-x>'
let g:multi_cursor_quit_key            = '<Esc>'

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

set foldenable
set foldmethod=manual

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

set ruler

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

set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar
set guioptions-=L
set guioptions-=b
set guioptions-=e  "tab

set winaltkeys=no

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
map <silent> <C-n> :NERDTreeToggle<CR>
map <silent> <C-b> :TlistToggle<CR>

nmap <C-f> <Plug>CtrlSFPrompt
nmap <S-f> <Plug>CtrlSFCwordPath
vmap <S-f> <Plug>CtrlSFVwordPath
nmap <M-f> :CtrlSFToggle<CR>
"nmap     <C-f>f <Plug>CtrlSFPrompt
"vmap     <C-f>f <Plug>CtrlSFVwordPath
"vmap     <C-f>F <Plug>CtrlSFVwordExec
"nmap     <C-f>n <Plug>CtrlSFCwordPath
"nmap     <C-f>p <Plug>CtrlSFPwordPath
"nnoremap <C-f>o :CtrlSFOpen<CR>
"nnoremap <C-f>t :CtrlSFToggle<CR>
"inoremap <C-f>t <Esc>:CtrlSFToggle<CR>


function GenerateCtags()
	silent! exec '!ctags -R ' . getcwd()
endfunction
nmap <M-t> :call GenerateCtags()<CR>

"run server
function RunServer()
	silent! exec "!runserver"
endfunction
nmap <F5> :call RunServer()<CR>

"close server
function CloseServer()
	silent! exec "!closeserver"
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
	silent! exec "!start " . expand("%:h")
endfunction
nmap <silent> <M-e> :call Folder()<CR>

"open folder of current file with totalcommand
function TCFolder()
	silent! exec "!vimtc " . expand("%:p:h")
endfunction
nmap <silent> <M-d> :call TCFolder()<CR>

"swtich between inc and mgr
function SwitchInc()
	if match(expand("%"),"Inc\.lua") != -1
		execute "edit " . substitute(expand("%"), 'Inc\.lua', '\.lua', "")
	else
		execute "edit " . substitute(expand("%"), '\.lua', 'Inc\.lua', "")
	endif
endfunction
nmap <M-i> :call SwitchInc()<CR>
