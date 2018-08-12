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
"set relativenumber
set t_Co=256
set autoindent
set backspace=indent,eol,start
set tabstop=4 shiftwidth=4 expandtab
set smarttab
set inccommand=nosplit
set clipboard=unnamed
set cursorline

let mapleader="\\"

map j gj
map k gk


call plug#begin()
    Plug 'lervag/vimtex'
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'sethgower/vip'
    Plug 'dracula/vim'
    Plug 'vim-airline/vim-airline'
    Plug 'airblade/vim-gitgutter'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh',
        \ }
    Plug 'w0rp/ale'
    Plug 'Shougo/echodoc.vim'
    Plug 'jiangmiao/auto-pairs'
call plug#end()
filetype plugin indent on

syntax on
let g:dracula_colorterm = 0
colorscheme dracula
set termguicolors

autocmd FileType latex,tex,markdown,md setlocal spell spelllang=en_us

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

"Changes colorscheme of popup for YCM
highlight Pmenu guifg=7 guibg=13 ctermfg=7 ctermbg=13

" Persistent undo
set undodir=~/.config/nvim/undodir
set undofile

"call neomake#configure#automake('nwri')

" Vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1

" Deoplete
call deoplete#enable()
call deoplete#custom#source('LanguageClient', 'min_pattern_length', 2)

" Language Servers
set signcolumn=yes
let g:LanguageClient_autoStart = 1
let g:LanguageClient_loggingFile = '/tmp/LanguageClient.log'
let g:LanguageClient_loggingLevel = 'INFO'
let g:LanguageClient_serverStderr = '/tmp/LanguageServer.log'

let g:LanguageClient_serverCommands = {
    \ 'python' : ['/usr/bin/pyls'],
    \ 'sh': ['bash-language-server', 'start'],
    \ }

let g:LanguageClient_diagnosticsDisplay = {
            \1: {
                \ "name": "Error",
                \ "texthl": "ALEError",
                \ "signText": "✖",
                \ "signTexthl": "ALEErrorSign",
            \},
            \2: {
                \ "name": "Warning",
                \ "texthl": "ALEWarning",
                \ "signText": "-",
                \ "signTexthl": "ALEWarningSign",
            \},
            \3: {
                \ "name": "Information",
                \ "texthl": "ALEInfo",
                \ "signText": "ℹ",
                \ "signTexthl": "ALEInfoSign",
            \},
            \4: {
                \ "name": "Hint",
                \ "texthl": "ALEInfo",
                \ "signText": "➤",
                \ "signTexthl": "ALEInfoSign",
            \},
        \}
let g:ale_sign_error = ">>"
let g:ale_sign_warning = "--"

let g:ale_fix_on_save = 1
let g:ale_fixers = 
            \ {
            \ 'sh': ['shfmt'],
            \ 'python': ['autopep8'],
            \ 'java': ['google_java_format']
            \ }

nnoremap <leader>f :ALEFix<CR>
let g:ale_linters = 
            \ {
            \ 'bash': ['language-server'],
            \ 'python': ['autopep8'],
            \ 'vhdl': ['ghdl']
            \ }

" gitgutter
let g:gitgutter_enabled = 1
