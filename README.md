# kvim
vim configuration

## 安装vim

gvim_8.1.2300_x64.exe 最新版本也可

https://github.com/vim/vim-win32-installer/releases

exe安装

## 安装python

需要根据vim版本里的描述安装匹配的版本，加入环境变量

https://www.python.org/downloads/

C:\Python27\

C:\Python27\Scripts

## 安装pygments  用于语法分析

命令行执行 pip install pygments

## 安装vundle 插件管理器

https://github.com/VundleVim/Vundle.vim

git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

替换_vimrc后，在vim里面输入 :PluginInstall 安装插件

## 安装rg 搜索插件

ripgrep-12.1.1-x86_64-pc-windows-msvc

https://github.com/BurntSushi/ripgrep/releases

rg.exe拷贝到Vim目录下

## 安装gtags 查定义查引用

glo665wb.zip

https://www.gnu.org/software/global/ => http://adoxa.altervista.org/global/

解压到C目录，加入环境变量

## 以下为可选

## ctags gtags替代

ctags-2021-10-25_p5.9.20211024.0-2-g6f544dfc-x64.zip

https://github.com/universal-ctags/ctags-win32/releases

ctags.exe拷贝到vim目录下

## ag 搜索插件 rg替代

https://github.com/JFLarvoire/the_silver_searcher/releases

ag.exe拷贝到Vim目录下

## lua 加入环境变量

直接拷进Vim目录也可
