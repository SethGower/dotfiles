highlight LineNr ctermfg=grey
set title
set hidden
set pastetoggle=<F2>
set visualbell
set noerrorbells
set smartindent
set smartcase
set ignorecase
set hlsearch
set showmatch
set undolevels=1000
set number
set t_Co=256
set autoindent
set backspace=indent,eol,start
set tabstop=2 shiftwidth=2 expandtab
set smarttab
set breakindent
set inccommand=nosplit
set clipboard+=unnamedplus
set cursorline
set noshowmode
set textwidth=80
set mouse=a
set nowrap

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
    Plug 'Shougo/echodoc.vim'
    Plug 'jiangmiao/auto-pairs'
    Plug 'chip/vim-fat-finger'
    Plug 'godlygeek/tabular'
    Plug 'tpope/vim-commentary'
    Plug 'tmhedberg/SimpylFold', {'for':'python'}
    Plug 'scrooloose/nerdtree'
    Plug 'ctrlpvim/ctrlp.vim'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'tpope/vim-fugitive'
    Plug 'kshenoy/vim-signature'
    Plug 'neovim/pynvim'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'jackguo380/vim-lsp-cxx-highlight'
    Plug 'igankevich/mesonic'
    Plug 'moll/vim-bbye'
    Plug 'aymericbeaumet/vim-symlink'
call plug#end()
filetype plugin indent on " for plug

let g:lsp_cxx_hl_log_file = '/tmp/vim-lsp-cxx-hl.log'

syntax on
let g:dracula_colorterm = 0 " enables correct background color
colorscheme dracula
hi Comment ctermfg=Yellow
""set termguicolors

autocmd FileType latex,tex,markdown,md,text setlocal spell spelllang=en_us
autocmd FileType make setlocal noexpandtab " prevents vim from placing spaces
                                           " instead of tabs for makefiles (sadly)
autocmd BufNewFile,BufRead *.h set ft=c
autocmd BufNewFile,BufRead *.toml set ft=dosini

" Ultisnips commands.
let g:UltiSnipsExpandTrigger       = "<C-j>"
let g:UltiSnipsJumpForwardTrigger  = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"

" Persistent undo
set undodir=~/.config/nvim/undodir
set undofile

" Vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#coc#enabled = 1
let airline#extensions#coc#error_symbol = 'Error:'
let airline#extensions#coc#warning_symbol = 'Warning:'


inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


" Language Servers
set signcolumn=yes


" CoC Stuff
set colorcolumn=+1
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

command! -nargs=0 Format :call CocAction('format')
nmap <leader>f <Plug>(coc-format)
" autocmd BufWritePre * %s/\s\+$//e " remove trailing white space on write
map <leader>ws :%s/\s\+$//e<CR>
" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)


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
let g:NERDTreeGitStatusIndicatorMapCustom = {
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
