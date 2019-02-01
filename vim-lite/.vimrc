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
set undolevels=1000
set number
set t_Co=256
set autoindent
set backspace=indent,eol,start
set tabstop=4 shiftwidth=4 expandtab
set smarttab
set inccommand=nosplit
set clipboard=unnamed
set cursorline
set noshowmode

let mapleader="\\"

map j gj
map k gk

call plug#begin()
    Plug 'SirVer/ultisnips'
    Plug 'dracula/vim'
    Plug 'vim-airline/vim-airline'
    Plug 'airblade/vim-gitgutter'
    Plug 'jiangmiao/auto-pairs'
    Plug 'chip/vim-fat-finger'
    Plug 'kshenoy/vim-signature'
call plug#end()
filetype plugin indent on

syntax on
let g:dracula_colorterm = 0
colorscheme dracula
set termguicolors

autocmd FileType latex,tex,markdown,md setlocal spell spelllang=en_us
autocmd FileType make setlocal noexpandtab " prevents vim from placing spaces instead of tabs for makefiles (sadly)

"let g:vimtex_view_general_viewer = 'evince'

if exists("b:did_ftplugin")
    finish
endif

" Ultisnips commands.
let g:UltiSnipsExpandTrigger = "<C-j>"
let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"

" Persistent undo
set undodir=~/.config/nvim/undodir
set undofile

"call neomake#configure#automake('nwri')

" Vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1


" gitgutter
let g:gitgutter_enabled = 1

map <leader>mc :make clean<CR>

map <leader>wh  <C-w>h
map <leader>wj  <C-w>j
map <leader>wk  <C-w>k
map <leader>wl  <C-w>l
