-------------------- HELPERS -------------------------------
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

--------------------  SETTINGS -------------------------------
cmd('highlight LineNr ctermfg=grey')
opt.title = true
opt.hidden = true
opt.smartindent = true
opt.smartcase = true
opt.ignorecase = true
opt.hlsearch = true
opt.showmatch = true
opt.number = true
opt.autoindent = true
opt.backspace = {'indent','eol','start'}
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smarttab = true
opt.breakindent = true
opt.inccommand = 'nosplit'
opt.clipboard = opt.clipboard + 'unnamedplus'
opt.cursorline = true
opt.showmode = false
opt.textwidth=80
opt.mouse='a'
opt.wrap = false
opt.signcolumn = 'yes'
opt.foldenable = false
opt.undolevels = 1000
opt.undodir = '~/.config/nvim/undodir'
opt.undofile = true

-------------------- PLUGINS -------------------------------
local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim' -- packer manages itself
  use 'SirVer/ultisnips' -- Snippets from Ultisnips
  use 'honza/vim-snippets' -- default snippets for Ultisnips
  use 'vim-airline/vim-airline' -- airline status line
  use 'Shougo/echodoc.vim' -- docstrings on echo line
  use 'jiangmiao/auto-pairs' -- auto pairs for certain characters
  use 'chip/vim-fat-finger' -- quick fixes for certain typos
  use 'junegunn/vim-easy-align' -- better alignment
  use 'tpope/vim-commentary' -- comments lines with motions
  use 'preservim/nerdtree' -- File Tree
  use 'Xuyuanp/nerdtree-git-plugin' -- provides git stats to NERDTree
  use 'junegunn/fzf' -- fuzzy searching
  use 'junegunn/fzf.vim' -- commands for fzf
  use 'airblade/vim-rooter' -- changes CWD to root of project
  use 'tpope/vim-fugitive' -- git commands in vim
  use 'kshenoy/vim-signature' -- adds markers to the sign column
  use 'jackguo380/vim-lsp-cxx-highlight' -- adds semantic highlighting for Cxx
  use 'igankevich/mesonic' -- adds make calls to interface with meson
  use 'moll/vim-bbye' -- better buffer deletion
  use 'aymericbeaumet/vim-symlink' -- read symlinks for pwd
  use 'nvim-treesitter/nvim-treesitter' -- treesitter interface for vim
  use 'deoplete-plugins/deoplete-lsp' -- LSP completion source for deoplete
  use 'neovim/nvim-lspconfig' -- LSP configuration for built in LSP

  -- git interface stuff for nvim. Mainly for git blame
  use {
    'lewis6991/gitsigns.nvim',
    requires = {
      'nvim-lua/plenary.nvim'
    }
  }
  
  -- completion using deoplete
  use {
    'Shougo/deoplete.nvim',
    run = fn['remote#host#UpdateRemotePlugins']
  }

  -- VimTeX for better development of LaTeX
  use {
    'lervag/vimtex',
    ft= 'tex',
    opt=true
  }

  -- VHDL plugin for copying and pasting entities and such
  use {
    'JPR75/vip',
    ft='vhdl',
    opt=true
  }

  -- Dracula colorscheme https://draculatheme.com/
  use {
    'dracula/vim',
    as='dracula'
  }

  -- adds folding definitions for python
  use {
    'tmhedberg/SimpylFold',
    ft='python',
    opt=true
  }

end)

cmd 'colorscheme dracula'


------------------------- MAPS -------------------------
map('', 'j', 'gj')
map('', 'k', 'gk')
map('', '<leader>wh', '<C-w>h')
map('', '<leader>wj', '<C-w>j')
map('', '<leader>wk', '<C-w>k')
map('', '<leader>wl', '<C-w>l')
map('n', '<space>', 'za')
map('n', 'ga', '<Plug>(EasyAlign)')
map('n', '<C-P>', ':FZF<CR>')

------------------------- LSP -------------------------

local lsp = require('lspconfig')
-- local lspfuzzy = require('lspfuzzy')


------------------------- NERDTree -------------------------
vim.g.NERDTreeGitStatusIndicatorMapCustom = {
  Modified  = "✹",
  Staged    = "✚",
  Untracked = "✭",
  Renamed   = "➜",
  Unmerged  = "═",
  Deleted   = "✖",
  Dirty     = "✗",
  Clean     = "✔︎",
  Ignored   = '☒',
  Unknown   = "?"
}
-- vim.g.NERDTreeIgnore={
--   '\~$',
--   '\.o[[file]]',
--   '\.fls$',
--   '\.log$',
--   '\.pdf$',
--   '\.gz$',
--   '\.aux$',
--   '\.fdb_latexmk$'
-- }

vim.cmd('autocmd BufEnter * if winnr(\'$\') == 1 && exists(\'b:NERDTree\') && b:NERDTree.isTabTree() | quit | endif')
vim.cmd('autocmd VimEnter * if argc() > 0 | NERDTreeFind | else | NERDTree | endif | wincmd p')
vim.cmd('autocmd TabEnter * silent NERDTreeMirror')
-- vim.cmd("autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 | let buf=bufnr() | buffer# | execute 'normal! \<C-W>w' | execute 'buffer'.buf | endif")

------------------------- TREE-SITTER -------------------------
local ts = require('nvim-treesitter.configs')
ts.setup {
  ensure_installed = 'maintained',
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  }
}

require('gitsigns').setup {
  signs = {
    add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
    change       = {hl = 'GitSignsChange', text = '!', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  current_line_blame = true,
  current_line_blame_delay = 100
}
