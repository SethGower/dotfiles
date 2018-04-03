highlight LineNr ctermfg=grey
set title
set hidden
set pastetoggle=<F2>
set visualbell
set noerrorbells
set smartindent
set smartcase
set hlsearch
set showmatch
set ignorecase
set undolevels=1000
set number
set t_Co=256
set autoindent
set backspace=indent,eol,start
set tabstop=4 shiftwidth=4 expandtab
set smarttab
syntax on
colorscheme desert

if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin('~/.vim/plugged')
	"Plug 'SirVer/ultisnips'
    "Plug 'honza/vim-snippets'
    Plug 'lervag/vimtex'
call plug#end()

autocmd FileType latex,tex,markdown,md setlocal spell spelllang=en_us

let g:vimtex_view_general_viewer = 'evince'
let g:deoplete#enable_at_startup = 1

map j gj
map k gk
augroup MyVimtex
		  autocmd!
		  autocmd User VimtexEventQuit call system('latexmk -c')
augroup END

if exists("b:did_ftplugin")
    finish
endif
