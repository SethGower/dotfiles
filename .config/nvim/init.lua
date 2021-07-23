-- Copyright (c) 2021 Gower, Seth <sethzerish@gmail.com>
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
-- the Software, and to permit persons to whom the Software is furnished to do so,
-- subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
-- FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
-- COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
-- IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
-- CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

-------------------- HELPERS -------------------------------
---@diagnostic disable: unused-local
local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

-- Normalize codes (such as <Tab>) to their terminal codes (<Tab> == ^I)
local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end


local function map(mode, lhs, rhs, opts)
  local options = {noremap = false}
  if opts then
    options = vim.tbl_extend('force', options, opts)
    if opts['noremap'] then
      options['noremap'] = true
    end
  end
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
opt.rnu         = true; -- releative number
opt.showmode    = false
opt.textwidth   = 80
opt.mouse       = 'a'
opt.wrap        = false
opt.signcolumn  = 'yes'
opt.foldmethod  = 'expr'
opt.foldexpr    = 'nvim_treesitter#foldexpr()'
opt.foldenable  = false
opt.undolevels  = 1000
opt.wildmode    = {"longest","list","full"}
opt.wildmenu    = true
-- opt.undodir = '~/.config/nvim/undodir'
cmd 'set undofile'

vim.o.termguicolors = true
vim.g.dracula_colorterm = 0
cmd 'colorscheme dracula'
-------------------- PLUGINS -------------------------------
require('plugins') -- all of the plugin definitions are in lua/plugins.lua
-- recompile packer whenever saving the lua/plugins.lua file
vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])

------------------------ MAPS -------------------------
map('',  'j',                'gj')
map('',  'k',                'gk')
map('',  '<leader>wh',       '<C-w>h')
map('',  '<leader>wj',       '<C-w>j')
map('',  '<leader>wk',       '<C-w>k')
map('',  '<leader>wl',       '<C-w>l')
map('n', '<space>',          'za')
map('n', 'ga',               '<Plug>(EasyAlign)')
map('',  'ga',               '<Plug>(EasyAlign)')
map('n', '<C-P>',            '<cmd>Telescope find_files<CR>')
map('n', '<C-B>',            '<cmd>Telescope buffers<CR>')
map('',  '<leader>ws',       ':%s/\\s\\+$//e<CR>:noh<CR>')
map('n', '<leader><leader>', '<C-^>')
map('t', '<Esc>',            '<C-\\><C-n>', {noremap = true})
map('n', 'ga',               '<Plug>(EasyAlign)')
map('x', 'ga',               '<Plug>(EasyAlign)')

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
  -- buf_set_keymap('n', 'K',          '<cmd>lua vim.lsp.buf.hover()<CR>',                        opts)
  buf_set_keymap('n', 'gi',         '<cmd>lua vim.lsp.buf.implementation()<CR>',               opts)
  -- buf_set_keymap('n', '<C-k>',      '<cmd>lua vim.lsp.buf.signature_help()<CR>',               opts)
  buf_set_keymap('n', '<C-k>',      '<cmd>lua vim.lsp.buf.hover()<CR>',                        opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',                       opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',                  opts)
  buf_set_keymap('n', 'gr',         '<cmd>lua vim.lsp.buf.references()<CR>',                   opts)
  buf_set_keymap('n', '<leader>e',   '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d',         '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',             opts)
  buf_set_keymap('n', ']d',         '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',             opts)
  buf_set_keymap("n", "<leader>f",  "<cmd>lua vim.lsp.buf.formatting()<CR>",                   opts)

  -- require "lsp_signature".on_attach()  -- Note: add in lsp client on-attach
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

if not lspconfig.hdl_checker then
  configs.hdl_checker = {
    default_config = {
      autostart = false,
      cmd = {"hdl_checker", "--lsp"};
      filetypes = {"vhdl", "verilog", "systemverilog"};
      root_dir = function(fname)
        return util.root_pattern('.hdl_checker.config')(fname) or util.path.dirname(fname)
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
local servers = { "ccls", "rust_hdl", "hdl_checker", "pylsp", "rust_analyzer", "texlab"}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = vim.fn.stdpath('cache')..'/lspconfig/sumneko_lua/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

opt.updatetime  = 300
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    underline = true,
    signs = true,
  }
)

require('lsp_signature').setup()

-- sets up highlighting for lsp items


-- adds a check to see if any of the active clients have the capability
-- textDocument/documentHighlight. without the check it was causing constant
-- errors when servers didn't have that capability
for _,client in ipairs(vim.lsp.get_active_clients()) do
  if client.resolved_capabilities.document_highlight then
    vim.cmd [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
    vim.cmd [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
    vim.cmd [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
    break -- only add the autocmds once
  end
end

-- Lightbulb stuff
vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])
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

map('',  '<leader>nt', ':NERDTreeToggle<CR>')

vim.cmd('autocmd BufEnter * if winnr(\'$\') == 1 && exists(\'b:NERDTree\') && b:NERDTree.isTabTree() | quit | endif')
vim.cmd('autocmd VimEnter * if argc() > 0 | NERDTreeFind | else | NERDTree | endif | wincmd p')
vim.cmd('autocmd TabEnter * silent NERDTreeMirror')
-- vim.cmd("autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 | let buf=bufnr() | buffer# | execute 'normal! \<C-W>w' | execute 'buffer'.buf | endif")

------------------------- TREE-SITTER -------------------------
local ts = require('nvim-treesitter.configs')
ts.setup {
  ensure_installed = 'all',
  highlight = { -- built in
    enable = true
  },
  indent = { -- built in
    enable = true
  },
  rainbow = { -- added by p00f/nvim-ts-rainbow
    enable = true,
    extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
    max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
  },
  autotag = { -- added by windwp/nvim-ts-autotag
    enable = true,
  },
  context = { -- added by romgrk/nvim-treesitter-context
    enable = true,
  },
  autopairs = {
    enable = false,
  },
  matchup = {
    enable = true,
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
}


local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.vhdl = {
  install_info = {
    url = "~/.local/share/tree-sitter/tree-sitter-vhdl",
    files = {"src/parser.c"}
  },
  filetype = "vhdl"
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

local npairs = require('nvim-autopairs')
npairs.setup({
  check_ts = true,
  fast_wrap = {
      map = '<C-e>',
  },
  enable_check_bracket_line = false
})

-- skip it, if you use another global object
_G.MUtils= {}

MUtils.completion_confirm=function()
  if vim.fn.pumvisible() ~= 0  then
    return npairs.esc("<cr>") -- simply the plugins wrapper for termcode replacement
  else
    return npairs.autopairs_cr()
  end
end

map('i' , '<CR>','v:lua.MUtils.completion_confirm()', {expr = true , noremap = true})
------------------------- AUTO COMMANDS -------------------------
vim.cmd [[autocmd FileType latex,tex,markdown,md,text setlocal spell spelllang=en_us]]
vim.cmd [[autocmd FileType make setlocal noexpandtab]]
vim.cmd [[autocmd FileType gitconfig set ft=dosini]]
vim.cmd [[autocmd BufNewFile,BufRead *.h set ft=c]]
vim.cmd [[autocmd BufNewFile,BufRead *.config set ft=json]]
vim.cmd [[autocmd BufEnter init.lua set kp=:help]] -- sets the keywordprg to :help for init.lua, that way I can do 'K' on a word and look it up quick
