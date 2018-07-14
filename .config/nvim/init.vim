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
set inccommand=nosplit
set clipboard=unnamed

map j gj
map k gk

" call vundle#rc("~/.config/nvim/bundle")
call plug#begin()
    Plug 'VundleVim/Vundle.vim'
    Plug 'lervag/vimtex'
    "Plug 'Valloric/YouCompleteMe'
    "Plug 'rdnetto/YCM-Generator'
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'neomake/neomake'
    Plug 'sethgower/vip'
    Plug 'dracula/vim'
    Plug 'vim-airline/vim-airline'
    Plug 'airblade/vim-gitgutter'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh',
        \ }
call plug#end()
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
let g:vimtex_quickfix_open_on_warning = 0

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
highlight Pmenu guifg=7 guibg=13 ctermfg=7 ctermbg=13

map <Leader>n <plug>NERDTreeTabsToggle<CR>

" Persistent undo
set undodir=~/.config/nvim/undodir
set undofile

"call neomake#configure#automake('nwri')

" Vim-airline
let g:airline_powerline_fonts = 1

" Deoplete
call deoplete#enable()
call deoplete#custom#source('LanguageClient', 'min_pattern_length', 2)

" Language Servers
set signcolumn=yes
let g:LanguageClient_autoStart = 1
let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
let g:LanguageClient_loggingLevel = 'DEBUG'
let g:LanguageClient_serverStderr = '/tmp/LanguageServer.log'

let g:LanguageClient_serverCommands = {
    \ 'python' : ['/usr/bin/pyls'],
    \ 'sh': ['bash-language-server', 'start'],
    \ 'rust': ['rustup', 'run', 'nightly', 'rls'],
    \ }
