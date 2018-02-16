set number
set tabstop=4
set t_Co=256
set autoindent
syntax on
colorscheme desert

call plug#begin('~/.vim/plugged')
	Plug 'lervag/vimtex'
call plug#end()


autocmd FileType latex,tex,markdown,md setlocal spell spelllang=en_us
