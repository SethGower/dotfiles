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
o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

cmd 'set undofile'
cmd 'set nowrap'

g.auto_save = true
--------------------
--  AUTOCOMMANDS  --
--------------------

-- Create autocommand group to prevent duplicating autocommands
vim.api.nvim_create_augroup('bufcheck', { clear = true })

-- Highlight Yanks
vim.api.nvim_create_autocmd('TextYankPost', {
    group    = 'bufcheck',
    pattern  = '*',
    callback = function ()
        vim.highlight.on_yank {
            timeout = 500
        }
    end
})

-- Autoreload file on external change
opt.autoread = true
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
    group    = 'bufcheck',
    pattern  = '*',
    callback = function ()
        if vim.fn.mode() ~= 'c' then
            vim.cmd('checktime')
        end
    end
}) -- vim.cmd('autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != \'c\' | checktime | endif')

-- Report when file was changed outside of neovim
vim.api.nvim_create_autocmd('FileChangedShellPost', {
    group    = 'bufcheck',
    pattern  = '*',
    callback = function ()
        vim.cmd('echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None')
    end
}) -- vim.cmd('autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None')

-- When re-opening a file restore cursor to previous position
vim.api.nvim_create_autocmd('BufReadPost', {
    group    = 'bufcheck',
    pattern  = '*',
    callback = function ()
        local fn = vim.fn.expand("%t")
        if fn:find(".git") then return end -- Don't restore cursor on git files
        if vim.fn.line("'\"") > 0 and vim.fn.line("'\"") <= vim.fn.line("$") then
            vim.fn.setpos('.', vim.fn.getpos("'\""))
            vim.api.nvim_feedkeys('zz', 'n', true)
        end
    end
})

-- Autosave file when leaving buffer or neovim.
-- Can be disabled in ft or local config by setting vim.g.auto_save = false
vim.api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
    group    = 'bufcheck',
    pattern  = '*',
    callback = function ()
        local buf = vim.fn.bufnr()
        local bvr = vim.fn.getbufvar(buf, "&")
        local fname = vim.fn.expand("%:t")
        if true and
            bvr.buftype == "" and
            bvr.modifiable == 1 and
            bvr.modified == 1 and
            fname ~= ""
        then
            vim.cmd('silent update')
            vim.cmd(
                'echohl InfoMsg | echo "Auto-saved " .. expand("%:t") .. " at " .. strftime("%H:%M:%S") | echohl None')
            vim.fn.timer_start(1500, function () vim.cmd('echon ""') end)
        end
    end
})

-----------------
--  FUNCTIONS  --
-----------------

local retab_buf = function (old)
    local bet = opt.expandtab
    local bsw = opt.shiftwidth
    local bts = opt.tabstop
    local bst = opt.softtabstop

    opt.expandtab = false
    opt.shiftwidth = old
    opt.tabstop = old
    opt.softtabstop = old
    vim.cmd [[retab!]]

    opt.expandtab = bet
    opt.shiftwidth = bsw
    opt.tabstop = bts
    opt.softtabstop = bst
    vim.cmd [[retab]]
end

vim.api.nvim_create_user_command("FixTabs",
     function (args)
         local retab_width = tonumber(args.args)
         if retab_width >= 1 then
             retab_buf(retab_width)
         else
             vim.notify(
                 args.args .. " is not a number >= 1. Please use :FixTabs <number>",
                 vim.log.levels.ERROR
             )
         end
     end, { nargs = 1, desc = "Retab files to 4 spaces" })
