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

map j gj
map k gk

set rtp+=$HOME/.config/nvim/bundle/Vundle.vim/
call vundle#begin()
    Plugin 'lervag/vimtex'
    Plugin 'Valloric/YouCompleteMe'
    Plugin 'rdnetto/YCM-Generator'
    Plugin 'SirVer/ultisnips'
    Plugin 'honza/vim-snippets'
    Plugin 'neomake/neomake'
    Plugin 'sethgower/vip'
    Bundle 'scrooloose/nerdtree'
    Bundle 'jistr/vim-nerdtree-tabs'
    Plugin 'dracula/vim'
    "Plugin 'bluz71/vim-moonfly-colors'
call vundle#end()
filetype plugin indent on

syntax on
let g:dracula_colorterm = 0
colorscheme dracula
set termguicolors

autocmd FileType latex,tex,markdown,md setlocal spell spelllang=en_us

" NERDTree config
let NERDTreeShowHidden=1
let NERDTreeSortOrder=['[\/]$', '*']
let NERDTreeIgnore=['.*\.swp$', '.*\.swo$', '.*\.pyc$']

" simple augroup for vimtex. 
augroup MyVimtex
	    autocmd!
        autocmd User VimtexEventQuit call system('latexmk -c') " Makes vimtex clean all log files and such when exiting vim
        autocmd BufWinEnter *.tex :VimtexCompile " compiles when a tex file is opened. 
augroup END

let g:vimtex_view_general_viewer = 'evince'
let g:vimtex_compiler_progname = 'nvr'
let g:tex_flavor='latex'

if exists("b:did_ftplugin")
    finish
endif

" Ultisnips commands.
let g:UltiSnipsExpandTrigger = "<C-j>"
let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"

"YouCompleteMe (YCM) configuration options.
let g:ycm_python_binary_path = 'python3'
let g:ycm_key_list_select_completion = ['<TAB>']
let g:ycm_key_list_previous_completion = ['<S_TAB>']
let g:ycm_min_num_of_chars_for_completion = 2

"Changes colorscheme of popup for YCM
highlight Pmenu ctermfg=7  ctermbg=25

map <Leader>n <plug>NERDTreeTabsToggle<CR>
