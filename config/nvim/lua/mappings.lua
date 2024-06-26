-- Normalize codes (such as <Tab>) to their terminal codes (<Tab> == ^I)
local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function map(mode, lhs, rhs, opts)
    local options = { noremap = false }
    if opts then
        options = vim.tbl_extend('force', options, opts)
        if opts['noremap'] then
            options['noremap'] = true
        end
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function create_noops(keys)
    for _, v in ipairs(keys) do
        vim.keymap.set(v[1], v[2], '')
    end
end

create_noops({
    { 'n',          '<leader>e' },
    { 'n',          '<leader>d' },
    { 'n',          '<leader>D' },
    { 'n',          'gD' },
    { 'n',          'gd' },
    { 'n',          'gr' },
    { 'n',          'gi' },
    { 'n',          '<leader>rn' },
    { 'n',          '<leader>ca' },
    { 'n',          '<leader>f' },
    { 'n',          '<F5>' },
    { 'n',          '<F10>' },
    { 'n',          '<F11>' },
    { 'n',          '<F12>' },
    { 'n',          '<Leader>b' },
    { 'n',          '<Leader>B' },
    { 'n',          '<Leader>lp' },
    { 'n',          '<Leader>dr' },
    { 'n',          '<Leader>dl' },
    { 'n',          '<Leader>df' },
    { 'n',          '<Leader>ds' },
    { { 'n', 'v' }, '<Leader>dh' },
    { { 'n', 'v' }, '<Leader>dp' },
})

map('',  'j',                'gj')
map('',  'k',                'gk')
map('',  '<leader>wh',       '<C-w>h')
map('',  '<leader>wj',       '<C-w>j')
map('',  '<leader>wk',       '<C-w>k')
map('',  '<leader>wl',       '<C-w>l')
map('n', '<space>',          'za')
map('n', 'ga',               '<Plug>(EasyAlign)')
map('',  'ga',               '<Plug>(EasyAlign)')
map('n', '<C-P>',            '<cmd>lua require("telescope.builtin").find_files()<CR>')
map('n', '<C-B>',            '<cmd>lua require("telescope.builtin").buffers()<CR>')
map('n', '<leader>g',        '<cmd>lua require("telescope.builtin").live_grep()<CR>')
-- map('n', '<C-H>',            '<cmd>Telescope harpoon marks<CR>')
-- map('n', '<C-E>',            '<cmd>Telescope gitmoji<CR>')
-- map('n', '<C-S>',            '<cmd>Telescope session-lens search_session<CR>')
map('',  '<leader>ws',       ':%s/\\s\\+$//e<CR>:noh<CR>')
map('n', '<leader><leader>', '<C-^>')
map('t', '<Esc>',            '<C-\\><C-n>', {noremap = true})
map('n', 'ga',               '<Plug>(EasyAlign)')
map('x', 'ga',               '<Plug>(EasyAlign)')
map('n', '<leader>ad',       '<cmd>ALEDetail<CR>')
map("n", "<leader>nt",        "<cmd>NvimTreeFindFile<CR>")

-- functions to use tab and shift+tab to navigate the completion menu
function _G.smart_tab()
    return vim.fn.pumvisible() == 1 and t '<C-n>' or t '<Tab>'
end

function _G.smart_back_tab()
    return vim.fn.pumvisible() == 1 and t '<C-p>' or t '<S-Tab>'
end

vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.smart_tab()', { expr = true, noremap = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.smart_back_tab()', { expr = true, noremap = true })
