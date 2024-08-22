-- Normalize codes (such as <Tab>) to their terminal codes (<Tab> == ^I)
local M = {}

local default_key_options = { noremap = true, silent = true }

local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function map(mode, lhs, rhs, opts)
    local options = default_key_options
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    if type(lhs) == "string" then
        vim.keymap.set(mode, lhs, rhs, options)
    elseif type(lhs) == "table" then
        for _, key in pairs(lhs) do
            vim.keymap.set(mode, key, rhs, options)
        end
    end
end

local function create_noops(keys)
    for _, v in ipairs(keys) do
        vim.keymap.set(v[1], v[2], '')
    end
end

local function Opt(desc)
    local opt_desc = default_key_options

    if desc then
        opt_desc = vim.tbl_extend("force", default_key_options, {
            desc = desc
        })
    end

    return opt_desc
end

-- This is a bit hacky, but we have to resolve `vim.lsp.buf` at runtime
-- so the operation completes on the active buffer NOT. If we pass
-- `vim.lsp.buf.declaration`, it will resolve at mapping time, not at
-- run time.
local function buf_run(str)
    return "<Cmd>lua " .. str .. "<CR>"
end

function M.setup_noops()
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
        { 'n',          '<Leader>ta' },
        { 'n',          '<Leader>nt' },
        { { 'n', 'v' }, '<Leader>dh' },
        { { 'n', 'v' }, '<Leader>dp' },
    })
end

function M.misc()
    map('n', 'ga', '<Plug>(EasyAlign)')
    map('', 'ga', '<Plug>(EasyAlign)')
    map('n', 'ga', '<Plug>(EasyAlign)')
    map('x', 'ga', '<Plug>(EasyAlign)')
    map('', '<leader>ws', ':%s/\\s\\+$//e<CR>:noh<CR>')
    map('t', '<Esc>', '<C-\\><C-n>', { noremap = true })
    map('n', '<leader>ad', '<cmd>ALEDetail<CR>')
    map("n", "<leader>nt", "<cmd>NvimTreeFindFile<CR>")
    map("n", "<leader>ta", "<cmd>ToggleAlternate<CR>")
end

function M.lsp_setup(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local function lsp_keymap(lsp_capability, ...)
        if client.server_capabilities[lsp_capability] then
            buf_set_keymap(...)
        end
    end

    local lOpts = function (desc) return Opt("LSP: " .. desc) end

    --Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- buf_set_keymap("n", "<leader>D", "<cmd>Trouble workspace_diagnostics<CR>", opts)
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', lOpts('open floating diagnostic'))
    buf_set_keymap("n", "<leader>d", "<cmd>Trouble diagnostics<CR>",             lOpts('trouble diagnostics'))

    -- goto bindings
    lsp_keymap('declarationProvider',        "n", "gD",         buf_run("vim.lsp.buf.declaration()"),            lOpts("goto declaration"))
    lsp_keymap('definitionProvider',         "n", "gd",         buf_run("vim.lsp.buf.definition()"),             lOpts("goto definition"))
    lsp_keymap('implementationsProvider',    "n", "gi",         buf_run("vim.lsp.buf.implementation()"),         lOpts("goto implementation"))
    lsp_keymap('definitionProvider',         "n", "gl",         buf_run("vim.lsp.buf.type_definition()"),        lOpts("goto type definition"))
    lsp_keymap('references',                 "n", "gr",         buf_run("vim.lsp.buf.references()"),             lOpts("see all object references"))

    lsp_keymap('renameProvider',             'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',             lOpts('rename symbol'))
    lsp_keymap('codeActionProvider',         'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',        lOpts('code action'))
    lsp_keymap('documentFormattingProvider', "n", "<leader>f",  "<cmd>lua vim.lsp.buf.format{async = true}<CR>", lOpts('format buffer'))
    lsp_keymap('documentFormattingProvider', "n", "<leader>F",  "<cmd>lua require('conform').format()<CR>",      lOpts('format with conform'))
end

function M.navigation()
    map('', 'j', 'gj')
    map('', 'k', 'gk')
    local has_navigator, navigator = pcall(require, 'Navigator')
    if has_navigator then
        map({ 'n', 't' }, { "<C-h>", "<C-Left>" }, navigator.left, Opt("Navigation: Left a window"))
        map({ 'n', 't' }, { "<C-k>", "<C-Up>" }, navigator.up, Opt("Navigation: Up a window"))
        map({ 'n', 't' }, { "<C-l>", "<C-Right>" }, navigator.right, Opt("Navigation: Right a window"))
        map({ 'n', 't' }, { "<C-j>", "<C-Down>" }, navigator.down, Opt("Navigation: Down a window"))
        map({ 'n', 't' }, "<A-p>", navigator.previous, Opt("Navigation: Go to previous window"))
    else
        map({ 'n', 't' }, { "<C-h>", "<C-Left>" }, "<C-w>h", Opt("Navigation: Left a window"))
        map({ 'n', 't' }, { "<C-k>", "<C-Up>" }, "<C-w>k", Opt("Navigation: Up a window"))
        map({ 'n', 't' }, { "<C-l>", "<C-Right>" }, "<C-w>l", Opt("Navigation: Right a window"))
        map({ 'n', 't' }, { "<C-j>", "<C-Down>" }, "<C-w>j", Opt("Navigation: Down a window"))
        map({ 'n', 't' }, "<A-p>", "<C-w>p", Opt("Navigation: Go to previous window"))
    end
    map('n', '<leader><leader>', '<C-^>')

    if vim.g.plugins_installed then
        map('n', '<C-P>', '<cmd>lua require("telescope.builtin").find_files()<CR>')
        map('n', '<C-B>', '<cmd>lua require("telescope.builtin").buffers()<CR>')
        map('n', '<leader>g', '<cmd>lua require("telescope.builtin").live_grep()<CR>')
    end -- vim.g.plugins_installed

    -- keybind that shows the changes that haven't been saved yet
    -- stolen from https://programming.dev/post/18289612
    vim.keymap.set(
        'n',
        '<C-D>',
        function ()
            local tmpft = vim.bo.filetype
            vim.cmd.vnew()
            vim.bo.filetype = tmpft
            vim.bo.buftype = 'nofile'
            vim.keymap.set(
                'n',
                'q',
                '<cmd>bw<cr>',
                { noremap = true, silent = true, buffer = true }
            )
            vim.cmd('silent r#|0d_')
            vim.bo.modifiable = false
            vim.cmd('diffthis|wincmd p|diffthis')
        end,
        { noremap = true }
    )
end

function M.setup()
    -- M.setup_noops()
    M.misc()
    M.navigation()
    -- map('n', '<space>', 'za')

    -- functions to use tab and shift+tab to navigate the completion menu
    function _G.smart_tab()
        return vim.fn.pumvisible() == 1 and t '<C-n>' or t '<Tab>'
    end

    function _G.smart_back_tab()
        return vim.fn.pumvisible() == 1 and t '<C-p>' or t '<S-Tab>'
    end

    vim.api.nvim_set_keymap('i', '<Tab>', 'v:lua.smart_tab()', { expr = true, noremap = true })
    vim.api.nvim_set_keymap('i', '<S-Tab>', 'v:lua.smart_back_tab()', { expr = true, noremap = true })
end

-----------------
--  mini.clue  --
-----------------
M.mini = {}
M.mini.clue = {
    -- Clue popup triggers
    triggers = {
        -- Leader triggers
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },

        -- Built-in completion
        { mode = 'i', keys = '<C-x>' },

        -- `g` key
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },

        -- Marks
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },

        -- Registers
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },

        -- Window commands
        { mode = 'n', keys = '<C-w>' },
        -- { mode = 'n', keys = '<Leader>w' },

        -- `z` key
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },
    },
    -- Additional clue hints
    clues = {
        { mode = 'n', keys = '<Leader>l',        desc = 'LSP: Extra' },
        { mode = 'n', keys = '<Leader>lw',       desc = 'Workspace' },
        { mode = 'n', keys = '<Leader>h',        desc = 'git' },
        { mode = 'n', keys = '<Leader>s',        desc = 'Surround' },
        { mode = 'n', keys = '<Leader>p',        desc = 'Misc. Pickers' },
        { mode = 'n', keys = '<Leader><Leader>', desc = 'Harpoon' },
    }
}

M.mini.files = {

    mappings = {
        close       = 'q',
        go_in       = 'l',
        go_in_plus  = 'L',
        go_out      = 'h',
        go_out_plus = 'H',
        reset       = '<BS>',
        reveal_cwd  = '@',
        show_help   = 'g?',
        synchronize = '=',
        trim_left   = '<',
        trim_right  = '>',
    },
    setup = function ()
        map('n', '<leader>mf', buf_run('MiniFiles.open()'))
    end
}
-- function M.mini.files.setup()
-- end

return M
