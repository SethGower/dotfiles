------------------------- LSP -------------------------
local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')
local util = require('lspconfig.util')

local M = {}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
M.on_attach = function(client, bufnr)
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

    require('nlspsettings').update_settings(client.name)
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

    local nlspsettings = require("nlspsettings")

    nlspsettings.setup({
        config_home = vim.fn.stdpath('config') .. '/nlsp-settings',
        local_settings_dir = ".nlsp-settings",
        local_settings_root_markers_fallback = { '.git' },
        append_default_schemas = true,
        loader = 'json',
        ignored_servers = {},
        nvim_notify = {
            enable = true,
            timeout = 5000
        },
        open_strictly = false
    })

    lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        capabilities = capabilities,
    })
    -- Use a loop to conveniently call 'setup' on multiple servers and
    -- map buffer local keybindings when the language server attaches
    local servers = { "pylsp", "rust_analyzer", "texlab", "ltex", "yamlls", "bashls", "vimls", "jsonls" }
    for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
            on_attach = function(client, bufnr)
                on_attach(client, bufnr)
                vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                    vim.lsp.diagnostic.on_publish_diagnostics, {
                        virtual_text = true,
                        underline = true,
                        signs = true,
                    }
                )
            end,
            capabilities = capabilities,
            flags = {
                debounce_text_changes = 150,
            }
        }
    end


    -- disable the diagnostics for verilog files (as well as sv files) since they
    -- were really annoying when editing verilog files, because of differences
    -- between sv and v. But I still wanted go to definition stuff
    -- servers = { "svls" }
    -- for _, lsp in ipairs(servers) do
    --     lspconfig[lsp].setup {
    --         on_attach = function(client, bufnr)
    --             on_attach(client, bufnr)
    --             vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
    --         end,
    --         capabilities = capabilities,
    --         flags = {
    --             debounce_text_changes = 150,
    --         }
    --     }
    -- end


    lspconfig["ccls"].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "c", "cpp", "cuda" },
        init_options = {
            cache = {
                directory = "/home/sgower/.cache/ccls",
            },
            request = {
                timeout = 100000
            }
        },
        flags = {
            debounce_text_changes = 150,
        }
    }

    lspconfig['svlangserver'].setup {
        on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            require('nlspsettings').update_settings(client.name)
        end,
        root_dir = function(fname)
            -- I am only going to be using system verilog in projects that also
            -- have VHDL, since the verilog might be in a submodule, go to the
            -- actual root of the directory which will be denoted with the
            -- vhdl_ls.toml file
            return util.root_pattern('vhdl_ls.toml')(fname)
        end,
    }

    lspconfig["verible"].setup {
        on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, {
                    virtual_text = true,
                    underline = true,
                    signs = true,
                }
            )
        end,
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        },
        cmd = { "verible-verilog-ls", "--indentation_spaces", "4" },
        root_dir = function(fname)
            -- I am only going to be using system verilog in projects that also
            -- have VHDL, since the verilog might be in a submodule, go to the
            -- actual root of the directory which will be denoted with the
            -- vhdl_ls.toml file
            return util.root_pattern('vhdl_ls.toml')(fname)
        end,
    }

    lspconfig["vhdl_ls"].setup {
        on_attach = function(client, bufnr)
            on_attach(client, bufnr)
            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
                vim.lsp.diagnostic.on_publish_diagnostics, {
                    virtual_text = true,
                    underline = true,
                    signs = true,
                }
            )
        end,
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        },
        root_dir = function(fname)
            return util.root_pattern('vhdl_ls.toml')(fname)
        end
    }

    local runtime_path = vim.split(package.path, ";")
    lspconfig["lua_ls"].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = "LuaJIT",
                    -- Setup your lua path
                    path = runtime_path,
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = { "vim" },
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
