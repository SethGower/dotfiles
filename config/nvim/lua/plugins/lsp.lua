------------------------- LSP -------------------------
local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')
local util = require('lspconfig.util')

local M = {}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
M.on_attach = function(_, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    --Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD',         '<cmd>lua vim.lsp.buf.declaration()<CR>',        opts)
    buf_set_keymap('n', 'gi',         '<cmd>Trouble lsp_implementations<CR>',          opts)
    buf_set_keymap('n', 'gd',         '<cmd>lua vim.lsp.buf.definition()<CR>',         opts)
    buf_set_keymap('n', 'gr',         '<cmd>Trouble lsp_references<CR>',               opts)
    buf_set_keymap('n', '<C-k>',      '<cmd>lua vim.lsp.buf.hover()<CR>',              opts)
    buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',             opts)
    buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',        opts)
    buf_set_keymap('n', '<leader>e',  '<cmd>lua vim.diagnostic.open_float()<CR>',      opts)
    buf_set_keymap('n', '[d',         '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',   opts)
    buf_set_keymap('n', ']d',         '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',   opts)
    buf_set_keymap("n", "<leader>f",  "<cmd>lua vim.lsp.buf.format{async = true}<CR>", opts)
    buf_set_keymap("n", "<leader>d",  "<cmd>Trouble document_diagnostics<CR>",         opts)
    buf_set_keymap("n", "<leader>D",  "<cmd>Trouble workspace_diagnostics<CR>",        opts)

    vim.opt.updatetime                                  = 300
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = true,
        underline = true,
        signs = true,
    }
    )
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


M.setup = function()
    local on_attach = M.on_attach
    require('mason').setup()
    require('mason-lspconfig').setup {
        automatic_installation = true
    }

    if not configs.vhdl_ls then
        configs.vhdl_ls = {
            default_config = {
                cmd = { "vhdl_ls" };
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
    local servers = { "pylsp", "rust_analyzer", "texlab", "ltex", "yamlls", "svls", "svlangserver", "vhdl_ls", "bashls",
        "jsonls", "sumneko_lua", "vimls" }
    for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
            on_attach = on_attach,
            capabilities = capabilities,
            flags = {
                debounce_text_changes = 150,
            }
        }
    end

    lspconfig["ccls"].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "c", "cpp", "cuda" },
        init_options = {
            cache = {
                directory = "/home/sgower/.cache/ccls";
            }
        },
        flags = {
            debounce_text_changes = 150,
        }
    }


    -- adds a check to see if any of the active clients have the capability
    -- textDocument/documentHighlight. without the check it was causing constant
    -- errors when servers didn't have that capability
    for _, client in ipairs(vim.lsp.get_active_clients()) do
        if client.server_capabilities.document_highlight then
            vim.cmd [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
            vim.cmd [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
            vim.cmd [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
            break -- only add the autocmds once
        end
    end
end

return M