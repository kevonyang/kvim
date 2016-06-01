" Configuration file for vim
set modelines=0		" CVE-2007-2438

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing

" Don't write backup file if vim is being called by "crontab -e"
"au BufWrite /private/tmp/crontab.* set nowritebackup nobackup
" Don't write backup file if vim is being called by "chpass"
"au BufWrite /private/etc/pw.* set nowritebackup nobackup

set fileencodings=ucs-bom,utf-8,utf-16,gb2312,gbk,big5,gb18030,latin1
set enc=utf-8
set fencs=utf8,gbk,gb2312,gb18030

syntax enable
syntax on
"set term=xterm-256color
"set t_Co=256
"let g:solarized_termcolors=256
"let g:solarized_termtrans=1
set background=dark
"colorscheme monokai
colorscheme desert
set foldenable
set foldmethod=manual

set tabstop=4
set shiftwidth=4
set softtabstop=4

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

"source .vimrc file in working dir
set exrc
set secure

"nerdtree setting
"autocmd vimenter *NERDTree
map <silent> <C-n> :NERDTreeToggle<CR>

"taglist setting
set tags=tags;
set autochdir
