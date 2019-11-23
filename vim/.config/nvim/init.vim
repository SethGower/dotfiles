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
set breakindent
set inccommand=nosplit
set clipboard+=unnamedplus
set cursorline
set noshowmode
set textwidth=78
set colorcolumn=+1

let mapleader="\\"

map j gj
map k gk

call plug#begin()
    Plug 'lervag/vimtex', {'for':'tex'}
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'JPR75/vip', {'for':'vhdl'}
    Plug 'dracula/vim',{'as':'dracula'}
    Plug 'vim-airline/vim-airline'
    Plug 'airblade/vim-gitgutter'
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch' : 'next',
        \ 'do'     : 'bash install.sh',
        \ }
    Plug 'w0rp/ale'
    Plug 'Shougo/echodoc.vim'
    Plug 'jiangmiao/auto-pairs'
    Plug 'chip/vim-fat-finger'
    Plug 'kshenoy/vim-signature'
    Plug 'godlygeek/tabular'
    Plug 'tpope/vim-commentary'
    Plug 'PratikBhusal/vim-grip'
    Plug 'tmhedberg/SimpylFold', {'for':'python'}
    Plug 'scrooloose/nerdtree'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'deoplete-plugins/deoplete-jedi', {'for':'python'}
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'dylanaraps/wal.vim'
    Plug 'chrisbra/Colorizer'
    Plug 'tpope/vim-surround'
    Plug 'neovim/pynvim'
call plug#end()
filetype plugin indent on " for plug

syntax on
let g:dracula_colorterm = 0 " enables correct background color
colorscheme dracula
""set termguicolors

autocmd FileType latex,tex,markdown,md,text setlocal spell spelllang=en_us
autocmd FileType make setlocal noexpandtab " prevents vim from placing spaces 
autocmd BufNewFile,BufRead *.h set ft=c
autocmd BufNewFile,BufRead *.toml set ft=dosini
" instead of tabs for makefiles (sadly)

" Ultisnips commands.
let g:UltiSnipsExpandTrigger       = "<C-j>"
let g:UltiSnipsJumpForwardTrigger  = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"

" Persistent undo
set undodir=~/.config/nvim/undodir
set undofile

" Vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1

" Deoplete
call deoplete#enable()
call deoplete#custom#source('LanguageClient', 'min_pattern_length', 4)

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


" Language Servers
set signcolumn=yes
let g:LanguageClient_autoStart    = 1
let g:LanguageClient_loggingFile  = '/tmp/LanguageClient.log'
let g:LanguageClient_loggingLevel = 'INFO'
let g:LanguageClient_serverStderr = '/tmp/LanguageServer.log'

let g:LanguageClient_serverCommands = {
    \ 'python' : ['/usr/bin/pyls'],
    \ 'sh'     : ['bash-language-server', 'start'],
    \ 'c'      : ['cquery'],
    \ 'rust'   : ['rls']
    \ }

let g:LanguageClient_diagnosticsDisplay = {
            \1: {
                \ "name"       : "Error",
                \ "texthl"     : "ALEError",
                \ "signText"   : "✖",
                \ "signTexthl" : "ALEErrorSign",
            \},
            \2                 : {
                \ "name"       : "Warning",
                \ "texthl"     : "ALEWarning",
                \ "signText"   : "-",
                \ "signTexthl" : "ALEWarningSign",
            \},
            \3                 : {
                \ "name"       : "Information",
                \ "texthl"     : "ALEInfo",
                \ "signText"   : "ℹ",
                \ "signTexthl" : "ALEInfoSign",
            \},
            \4                 : {
                \ "name"       : "Hint",
                \ "texthl"     : "ALEInfo",
                \ "signText"   : "➤",
                \ "signTexthl" : "ALEInfoSign",
            \},
        \}
let g:ale_sign_error = "✖"
let g:ale_sign_warning = "-"

let g:ale_fix_on_save = 1
let g:ale_fixers = 
            \ {
            \ 'sh'     : ['shfmt'],
            \ 'python' : ['autopep8', 'isort'],
            \ 'java'   : ['google_java_format'],
            \ 'c'      : ['clang-format'],
            \ 'cpp'    : ['clang-format'],
            \ 'text'   : ['textlint','remove_trailing_lines','trim_whitespace'],
            \ 'vhdl'   : ['remove_trailing_lines','trim_whitespace'],
            \ 'make'   : ['remove_trailing_lines','trim_whitespace'],
            \ 'rust'   : ['rustfmt'],
            \ 'perl'   : ['perltidy']
            \ }

nnoremap <leader>f :ALEFix<CR>
let g:ale_linters = 
            \ {
            \ 'bash'   : ['language-server'],
            \ 'python' : ['autopep8', 'python-language-server'],
            \ 'tex'    : ['lacheck'],
            \ 'c'      : ['cquery'],
            \ 'rust'   : ['rls']
            \ }

let g:ale_c_clangformat_options = '-style="{BasedOnStyle: LLVM, IndentWidth: 4}"'
map <leader>at  :ALEToggle<CR>
map <leader>ai  :ALEInfo<CR>
map <leader>al  :ALELint<CR>
map <leader>ad  :ALEGoToDefinition<CR>
map <leader>aR :ALEFindReferences<CR>
map <leader>ar  :ALERename<CR>

let g:ale_c_parse_makefile = 1

" gitgutter
let g:gitgutter_enabled = 1

map <leader>mc :make clean<CR>

if has('nvr')
    let $VISUAL = 'nvr -cc split --remote-wait'
endif

map <leader>wh  <C-w>h
map <leader>wj  <C-w>j
map <leader>wk  <C-w>k
map <leader>wl  <C-w>l

nnoremap <space> za

if exists(":Tabularize")
    nmap <Leader>a= :Tabularize /=<CR>
    vmap <Leader>a= :Tabularize /=<CR>
    nmap <Leader>a: :Tabularize /:<CR>
    vmap <Leader>a: :Tabularize /:<CR>
endif

" Nerd Tree Stuff
map <leader>nt :NERDTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
" If no file is opened when vim is opened, open NERDTree
" Open NERDTree when vim opens
autocmd vimenter * NERDTree
" Refocus on the other window not NERDTree
autocmd VimEnter * wincmd p
