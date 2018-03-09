set number
set tabstop=4
set t_Co=256
set autoindent
syntax on
colorscheme desert

call plug#begin('~/.vim/plugged')
	Plug 'lervag/vimtex'
call plug#end()

if has('nvim')
	Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  else
	Plug 'Shougo/deoplete.nvim'
	Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif

autocmd FileType latex,tex,markdown,md setlocal spell spelllang=en_us

let g:vimtex_view_general_viewer = 'mupdf'
let g:deoplete#enable_at_startup = 1
