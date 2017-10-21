" Configuration file for vim
set modelines=0		" CVE-2007-2438

"vundle-----------------------------------------------------------------------
" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
filetype off

"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

"let Vundle manage Vundle, required
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
Plugin 'dyng/ctrlsf.vim'
let g:ctrlsf_ackprg='ag'
let g:ctrlsf_auto_close=0
let g:ctrlsf_case_sensitive='no'
let g:ctrlsf_default_view_mode='compact'
let g:ctrlsf_ignore_dir=['tags']
let g:ctrlsf_default_root='cwd'

call vundle#end()
filetype plugin indent on
"endvundle-----------------------------------------------------------------------

set backspace=2		" more powerful backspacing

" Don't write backup file if vim is being called by "crontab -e"
"au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
" Don't write backup file if vim is being called by "chpass"
"au BufWrite /private/etc/pw.* set nowritebackup nobackup

set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936,gb2312,gbk,big5,gb18030

set langmenu=zh_CN.UTF-8
let $LANG='zh_CN.UTF-8'

"source $VIMRUNTIME/delmenu.vim
"source $VIMRUNTIME/menu.vim

"set term=xterm-256color
"set t_Co=256
"let g:solarized_termcolors=256
"let g:solarized_termtrans=1
"colorscheme 
colorscheme desert
syntax enable
syntax on

set lines=50 columns=200 linespace=1
set background=dark
set guifont=consolas:h10:cANSI

set foldenable
set foldmethod=manual

set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent

set noundofile
set nobackup
set noswapfile
set ignorecase

"高亮显示搜索结果
set hlsearch
set incsearch
set showmatch
set wildmenu

"显示光标当前位置
set ruler

set laststatus=2
"显示行号
set number
"使用系统剪贴板，可以复制到外面
set clipboard=unnamed

"source .vimrc file in working dir
set exrc
set secure

"set cursorline
"set cursorcolumn

set tags=tags;

"set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar
set guioptions-=L

map <C-j> :resize+5<CR>
map <C-k> :resize-5<CR>
map <C-h> :vertical resize-5<CR>
map <C-l> :vertical resize+5<CR>
map <silent> <C-Up> :resize-5<CR>
map <silent> <C-Down> :resize+5<CR> 
map <silent> <C-Left> :vertical resize-5<CR>
map <silent> <C-Right> :vertical resize+5<CR>
map <silent> <C-tab> :tabn<CR>

"nerdtree setting
"autocmd vimenter *NERDTree
map <silent> <C-n> :NERDTreeToggle<CR>
"taglist setting
map <silent> <C-t> :TlistToggle<CR>

nmap <C-f> <Plug>CtrlSFCwordPath
vmap <C-f> <Plug>CtrlSFVwordPath
"nmap     <C-s>f <Plug>CtrlSFPrompt
"vmap     <C-s>f <Plug>CtrlSFVwordPath
"vmap     <C-s>F <Plug>CtrlSFVwordExec
"nmap     <C-s>n <Plug>CtrlSFCwordPath
"nmap     <C-s>p <Plug>CtrlSFPwordPath
"nnoremap <C-s>o :CtrlSFOpen<CR>
"nnoremap <C-s>t :CtrlSFToggle<CR>
"inoremap <C-s>t <Esc>:CtrlSFToggle<CR>
