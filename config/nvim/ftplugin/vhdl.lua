-- Only do this when not done yet for this buffer
if vim.b.did_ftplugin then
    return
end
local opt = vim.opt -- to set options
local g = vim.g     -- a table to access global variables

g.UltiSnipsSnippetDir = "~/.config/nvim/UltiSnips/"
g.vhdl_indent_genportmap = 0 -- Keeps Vim from indenting port maps too much
g.HDL_Clock_Period = 100
g.HDL_Author = vim.fn.system("git config --global user.name")

if vim.fn.exists(":EasyAlign") ~= 0 then
    vim.api.nvim_set_keymap("n", "<leader>v:", ":EasyAlign :>l1<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>v=", ":EasyAlign =<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>vs", ":EasyAlign =<CR>", { noremap = true, silent = true })
    vim.api.nvim_set_keymap("n", "<leader>vw", ":EasyAlign =<CR>", { noremap = true, silent = true })
    -- vim.api.nvim_set_keymap("n", "<leader>v,", ":Tabularize /,=<CR>", { noremap = true, silent = true })
end

if vim.fn.exists(':Rooter') ~= 0 then
    g.rooter_patterns = { '.hdl_checker.config', 'vhdl_ls.toml' }
end

opt.comments = ":--,:--"
opt.commentstring = "--%s"
opt.formatoptions = vim.bo.formatoptions .. "cro"
opt.textwidth = 0

-- Simple shortcuts from https://github.com/salinasv/vim-vhdl/
vim.cmd([[
    iabbrev <buffer> con constant
    iabbrev <buffer> dt  downto
    iabbrev <buffer> sig signal
    iabbrev <buffer> var variable
    iabbrev <buffer> gen generate
    iabbrev <buffer> ot  others
    iabbrev <buffer> sl  std_logic
    iabbrev <buffer> slv std_logic_vector
    iabbrev <buffer> lv  std_logic_vector
    iabbrev <buffer> uns unsigned
    iabbrev <buffer> toi to_integer
    iabbrev <buffer> tos to_signed
    iabbrev <buffer> tou to_unsigned
]])

vim.api.nvim_set_keymap("n", "<F9>",
    [[:setl autoread<CR>:let b:current_file = @%<CR>:w!<CR>:execute '!vsg -f ' . b:current_file . ' --fix --configuration ./vsg_config.yaml'<CR><CR>:edit<CR>:setl noautoread<CR>]],
    { noremap = true, silent = true })

opt.foldmethod = "indent"
