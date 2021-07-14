-------------------- HELPERS -------------------------------
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

-- Normalize codes (such as <Tab>) to their terminal codes (<Tab> == ^I)
local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end


local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

--------------------  SETTINGS -------------------------------
cmd('highlight LineNr ctermfg=grey')
opt.title       = true
opt.hidden      = true
opt.smartindent = true
opt.smartcase   = true
opt.ignorecase  = true
opt.hlsearch    = true
opt.showmatch   = true
opt.number      = true
opt.autoindent  = true
opt.backspace   = {'indent','eol','start'}
opt.tabstop     = 2
opt.shiftwidth  = 2
opt.expandtab   = true
opt.smarttab    = true
opt.breakindent = true
opt.inccommand  = 'nosplit'
opt.clipboard   = opt.clipboard + 'unnamedplus'
opt.cursorline  = true
opt.showmode    = false
opt.textwidth   = 80
opt.mouse       = 'a'
opt.wrap        = false
opt.signcolumn  = 'yes'
opt.foldmethod  = 'expr'
opt.foldexpr    = 'nvim_treesitter#foldexpr()'
opt.foldenable  = false
opt.undolevels  = 1000
-- opt.undodir = '~/.config/nvim/undodir'
cmd 'set undofile'

-------------------- PLUGINS -------------------------------
local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim'          -- packer manages itself
  use 'SirVer/ultisnips'                -- Snippets from Ultisnips
  use 'honza/vim-snippets'              -- default snippets for Ultisnips
  use 'vim-airline/vim-airline'         -- airline status line
  use 'Shougo/echodoc.vim'              -- docstrings on echo line
  use 'jiangmiao/auto-pairs'            -- auto pairs for certain characters
  use 'chip/vim-fat-finger'             -- quick fixes for certain typos
  use 'junegunn/vim-easy-align'         -- better alignment
  use 'tpope/vim-commentary'            -- comments lines with motions
  use 'preservim/nerdtree'              -- File Tree
  use 'Xuyuanp/nerdtree-git-plugin'     -- provides git stats to NERDTree
  use 'airblade/vim-rooter'             -- changes CWD to root of project
  use 'tpope/vim-fugitive'              -- git commands in vim
  use 'kshenoy/vim-signature'           -- adds markers to the sign column
  use 'igankevich/mesonic'              -- adds make calls to interface with meson
  use 'moll/vim-bbye'                   -- better buffer deletion
  use 'aymericbeaumet/vim-symlink'      -- read symlinks for pwd
  use 'nvim-treesitter/nvim-treesitter' -- treesitter interface for vim
  use 'deoplete-plugins/deoplete-lsp'   -- LSP completion source for deoplete
  use 'neovim/nvim-lspconfig'           -- LSP configuration for built in LSP
  use 'kosayoda/nvim-lightbulb'         -- Lightbulb icon for code actions

  -- Matlab Linting using mlint
  use {
    'ibbo/mlint.vim',
    opt = true,
    ft ='matlab'
  }
  -- Lua Fuzzy Searcher
  use {
    'nvim-telescope/telescope.nvim',
    requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}}
  }

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
    run = fn['remote#host#UpdateRemotePlugins'],
    config = "vim.g['deoplete#enable_at_startup'] = 1"
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

vim.o.termguicolors = true
vim.g.dracula_colorterm = 0
cmd 'colorscheme dracula'


------------------------ MAPS -------------------------
map('',  'j',          'gj')
map('',  'k',          'gk')
map('',  '<leader>wh', '<C-w>h')
map('',  '<leader>wj', '<C-w>j')
map('',  '<leader>wk', '<C-w>k')
map('',  '<leader>wl', '<C-w>l')
map('n', '<space>',    'za')
map('n', 'ga',         '<Plug>(EasyAlign)')
map('',  'ga',         '<Plug>(EasyAlign)')
map('n', '<C-P>',      '<cmd>Telescope find_files<CR>')
map('',  '<leader>nt', ':NERDTreeToggle<CR>')
map('',  '<leader>ws', ':%s/\\s\\+$//e<CR>:noh<CR>')

-- functions to use tab and shift+tab to navigate the completion menu
function _G.smart_tab()
    return vim.fn.pumvisible() == 1 and t'<C-n>' or t'<Tab>'
end
function _G.smart_back_tab()
    return vim.fn.pumvisible() == 1 and t'<C-p>' or t'<S-Tab>'
end

vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.smart_tab()', {expr = true, noremap = true})
vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.smart_back_tab()', {expr = true, noremap = true})

vim.g.UltiSnipsExpandTrigger       = '<C-j>'
vim.g.UltiSnipsJumpForwardTriggeru = '<C-j>'
vim.g.UltiSnipsJumpBackwardTrigger = '<C-k>'

------------------------- LSP -------------------------

local lspconfig = require('lspconfig')
local configs = require('lspconfig/configs')
local util = require('lspconfig/util')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD',         '<cmd>lua vim.lsp.buf.declaration()<CR>',                  opts)
  buf_set_keymap('n', 'gd',         '<cmd>lua vim.lsp.buf.definition()<CR>',                   opts)
  buf_set_keymap('n', 'K',          '<cmd>lua vim.lsp.buf.hover()<CR>',                        opts)
  buf_set_keymap('n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>',               opts)
  buf_set_keymap('n', '<C-k>',      '<cmd>lua vim.lsp.buf.signature_help()<CR>',               opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',                       opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',                  opts)
  buf_set_keymap('n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>',                   opts)
  buf_set_keymap('n', '<leader>e',   '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d',         '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',             opts)
  buf_set_keymap('n', ']d',         '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',             opts)
  buf_set_keymap("n", "<leader>f",  "<cmd>lua vim.lsp.buf.formatting()<CR>",                   opts)

end

if not lspconfig.hdl_checker then
  configs.hdl_checker = {
    default_config = {
      cmd = {"hdl_checker", "--lsp"};
      filetypes = { "vhdl" };
      root_dir = function(fname)
        return util.root_pattern('.hdl_checker.config')(fname)
      end;
      settings = {};
    };
  }
end

if not lspconfig.rust_hdl then
  configs.rust_hdl = {
    default_config = {
      cmd = {"vhdl_ls"};
      filetypes = { "vhdl" };
      root_dir = function(fname)
        return util.root_pattern('vhdl_ls.toml')(fname)
      end;
      settings = {};
    };
  }
end
-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "ccls", "rust_hdl", "hdl_checker", "pyls", "rls", "texlab"}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

opt.updatetime  = 300
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
	vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = false,
		underline = true,
		signs = true,
	}
)

vim.cmd('autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()')
vim.cmd('autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()')
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
    change       = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  current_line_blame = true,
  current_line_blame_delay = 100
}
