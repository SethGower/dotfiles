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

set rtp+=$HOME/.config/nvim/bundle/Vundle.vim/
call vundle#begin()
    Plugin 'lervag/vimtex'
    "Plugin 'Valloric/YouCompleteMe'
    Plugin 'SirVer/ultisnips'
    Plugin 'honza/vim-snippets'
    Plugin 'neomake/neomake'
    "Plugin 'scrooloose/syntastic'
    Plugin 'JPR75/VIP'
call vundle#end()
filetype plugin indent on

autocmd FileType latex,tex,markdown,md setlocal spell spelllang=en_us

let g:vimtex_view_general_viewer = 'evince'

map j gj
map k gk
augroup MyVimtex
		  autocmd!
		  autocmd User VimtexEventQuit call system('latexmk -c')
augroup END

if exists("b:did_ftplugin")
    finish
endif

let g:UltiSnipsExpandTrigger = "<C-j>"
let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
