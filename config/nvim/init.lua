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
opt.rnu         = true;  -- releative number
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
cmd 'set undofile'

-------------------- PLUGINS -------------------------------
require('plugins') -- all of the plugin definitions are in lua/plugins.lua
-- recompile packer whenever saving the lua/plugins.lua file
vim.cmd([[autocmd BufWritePost plugins.lua source <afile> | PackerCompile]])

vim.o.termguicolors = true
vim.g.dracula_colorterm = 0
cmd 'colorscheme dracula'
--------------------- Local Config --------------------
require('local_config')


------------------------- AUTO COMMANDS -------------------------
vim.cmd [[autocmd FileType latex,tex,markdown,md,text setlocal spell spelllang=en_us]]
vim.cmd [[autocmd FileType make setlocal noexpandtab]]
vim.cmd [[autocmd FileType gitconfig set ft=dosini]]
vim.cmd [[autocmd FileType zsh set ft=sh]]
vim.cmd [[autocmd BufNewFile,BufRead *.h set ft=c]]
vim.cmd [[autocmd BufNewFile,BufRead *.config set ft=json]]
vim.cmd("autocmd BufEnter " .. fn.stdpath('config') .. "/*.lua set kp=:help") -- sets the keywordprg to :help for init.lua, that way I can do 'K' on a word and look it up quick

require("nvim-tree").setup()

require('mappings')
