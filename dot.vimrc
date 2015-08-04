syntax on
colorscheme peachpuff 
set ruler
set nu
set visualbell
set title
set cursorline
set colorcolumn=80
set t_Co=256
set nowritebackup
set noswapfile
set nobackup
set expandtab
set shiftwidth=2
set softtabstop=2
set autoindent
set nocompatible 
filetype off 

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'mv/mv-vim-puppet'
Plugin 'smerrill/vcl-vim-plugin'

call vundle#end() 
filetype plugin indent on 

highlight LineNr ctermfg=white ctermbg=blue
highlight StatusLine ctermfg=blue ctermbg=white
set statusline=%t%m%r%h%w
			\%=[FORMATO=%{&ff}]
			\[TIPO=%Y]
			\[\ XY=%04v,%04l]
			\[%03P]
setlocal laststatus=2

