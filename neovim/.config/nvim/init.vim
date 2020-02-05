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
set textwidth=80
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
    Plug 'dense-analysis/ale'
    Plug 'Shougo/echodoc.vim'
    Plug 'jiangmiao/auto-pairs'
    Plug 'chip/vim-fat-finger'
    Plug 'kshenoy/vim-signature'
    Plug 'godlygeek/tabular'
    Plug 'tpope/vim-commentary'
    Plug 'tmhedberg/SimpylFold', {'for':'python'}
    Plug 'scrooloose/nerdtree'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'deoplete-plugins/deoplete-jedi', {'for':'python'}
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

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


" Language Servers
set signcolumn=yes
let g:ale_sign_error = "x"
let g:ale_sign_warning = "-"

let g:ale_fix_on_save = 1
let g:ale_fixers = 
            \ {
            \ 'sh'     : ['shfmt'],
            \ 'java'   : ['google_java_format'],
            \ 'text'   : ['textlint','remove_trailing_lines','trim_whitespace'],
            \ 'vhdl'   : ['remove_trailing_lines','trim_whitespace'],
            \ 'make'   : ['remove_trailing_lines','trim_whitespace'],
            \ 'perl'   : ['perltidy']
            \ }

nnoremap <leader>f :ALEFix<CR>
let g:ale_linters = 
            \ {
            \ 'bash'   : ['language-server']
            \ }

let g:ale_c_clangformat_options = '-style="{BasedOnStyle: LLVM, IndentWidth: 4}"'
map <leader>at  :ALEToggle<CR>
map <leader>ai  :ALEInfo<CR>
map <leader>al  :ALELint<CR>
map <leader>ad  :ALEGoToDefinition<CR>
map <leader>ar  :ALEFindReferences<CR>
map <leader>an  :ALENext<CR>
map <leader>aR  :ALERename<CR>

let g:ale_c_parse_makefile = 1

" gitgutter
let g:gitgutter_enabled = 1
map <leader>gs  :GitGutterStageHunk<CR>

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

let g:NERDTreeIgnore=['\~$', '\.o[[file]]', '\.fls$','\.log$', '\.pdf$', '\.gz$', '\.aux$', '\.fdb_latexmk$']
