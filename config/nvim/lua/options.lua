---@diagnostic disable: unused-local
local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn   -- to call Vim functions e.g. fn.bufnr()
local g = vim.g     -- a table to access global variables
local opt = vim.opt -- to set options
local o = vim.o

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
opt.backspace   = { 'indent', 'eol', 'start' }
opt.tabstop     = 4
opt.shiftwidth  = 4
opt.expandtab   = true
opt.smarttab    = true
opt.breakindent = true
opt.inccommand  = 'nosplit'
opt.clipboard   = opt.clipboard + 'unnamedplus'
opt.rnu         = true; -- releative number
opt.showmode    = false
opt.textwidth   = 0
opt.mouse       = 'a'
opt.wrap        = true
opt.signcolumn  = 'yes'
opt.foldmethod  = 'expr'
opt.foldexpr    = 'nvim_treesitter#foldexpr()'
opt.foldenable  = false
opt.undolevels  = 1000
opt.wildmode    = { "longest", "list", "full" }
opt.wildmenu    = true
opt.listchars   = { eol = "¬", tab = ">·", trail = "~", extends = ">", precedes = "<", space = "␣" }

o.termguicolors = true
cmd 'set undofile'
cmd 'set nowrap'
