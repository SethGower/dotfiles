------------------------- LSP -------------------------
local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')
local util = require('lspconfig.util')

local M = {}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
M.on_attach = function (client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    local function lsp_keymap(lsp_capability, ...)
        if client.server_capabilities[lsp_capability] then
            buf_set_keymap(...)
        end
    end

    --Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap("n", "<leader>d", "<cmd>Trouble document_diagnostics<CR>", opts)
    buf_set_keymap("n", "<leader>D", "<cmd>Trouble workspace_diagnostics<CR>", opts)

    lsp_keymap('hoverProvider', 'n', '<C-k>', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    lsp_keymap('definitionProvider', 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    lsp_keymap('declarationProvider', 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    lsp_keymap('referencesProvider', 'n', 'gr', '<cmd>Trouble lsp_references<CR>', opts)
    lsp_keymap('implementationsProvider', 'n', 'gi', '<cmd>Trouble lsp_implementations<CR>', opts)

    lsp_keymap('renameProvider', 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    lsp_keymap('codeActionProvider', 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    lsp_keymap('documentFormattingProvider', "n", "<leader>f", "<cmd>lua vim.lsp.buf.format{async = true}<CR>", opts)
    lsp_keymap('documentFormattingProvider', "n", "<leader>F", "<cmd>lua require('conform').format()<CR>", opts)

    vim.opt.updatetime = 300

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


M.setup = function ()
    local on_attach = M.on_attach

    require('mason').setup()
    require('mason-lspconfig').setup {
        automatic_installation = true
    }

    local nlspsettings = require("nlspsettings")

    -- Sets the defaults for the server configurations. This way I don't have to specify these for every single one
    lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        capabilities = capabilities,
        on_attach = on_attach,
    })
    -- Use a loop to conveniently call 'setup' on multiple servers and
    -- map buffer local keybindings when the language server attaches
    local servers = { "pylsp", "rust_analyzer", "texlab", "bashls", "vimls", "jsonls", "cmake", "marksman",
        "ginko_ls", "vhdl_ls" }
    for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {}
    end

    lspconfig["ltex"].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "tex" },
    }

    lspconfig["yamlls"].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            yaml = {
                format = { enable = true },
                validate = true,
            },
        },
    }
    -- lspconfig["svls"].setup {
    --     on_attach = on_attach,
    --     capabilities = capabilities,
    --     root_dir = function (_)
    --         return vim.fs.dirname(vim.fs.find({ '.git', '.svls.toml', 'vhdl_ls.toml' }, { upward = true })[1]);
    --     end,
    -- }

    lspconfig['svlangserver'].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        root_dir = function (_)
            return vim.fs.dirname(vim.fs.find({ '.git', 'vhdl_ls.toml' }, { upward = true })[1]);
        end,
    }

    lspconfig['clangd'].setup {
        capabilities = capabilities,
        on_attach = function (client, bufnr)
            on_attach(client, bufnr)
            require('nlspsettings').update_settings(client.name)
        end,
    }

    lspconfig["verible"].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "verible-verilog-ls", "--indentation_spaces", "4" },
        root_dir = function (_)
            return vim.fs.dirname(vim.fs.find({ '.git', 'vhdl_ls.toml' }, { upward = true })[1]);
        end,
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
                    -- globals = { "vim" },
                    -- disable = { "missing-fields" }
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = {
                        vim.env.VIMRUNTIME
                    },
                    checkThirdParty = false,
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


    -- vim.lsp.set_log_level("debug")
end

M.null_ls = function ()
    local null_ls = require('null-ls')
    local helpers = require('null-ls.helpers')
    local vsg_lint = {
        name = "VSG",
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { "vhdl" },
        generator = helpers.generator_factory({
            command = "vsg",
            args = function (params)
                local rv = {}
                -- check if there is a config file in the root directory, if so
                -- insert the -c argument with it
                if vim.fn.filereadable(params.root .. '/vsg_config.yaml') == 1 then
                    table.insert(rv, '-c=' .. params.root .. '/vsg_config.yaml')
                end
                table.insert(rv, '--stdin')
                table.insert(rv, '-of=syntastic')
                return rv
            end,
            cwd = nil,
            check_exit_code = function () return true end,
            from_stderr = false,
            ignore_stderr = true,
            to_stdin = true,
            format = "line",
            multiple_files = false,
            on_output = helpers.diagnostics.from_patterns({
                {
                    pattern = [[(%w+).*%((%d+)%)(.*)%s+%-%-%s+(.*)]],
                    groups = { 'severity', 'row', 'code', 'message' },
                    overrides = {
                        severities = {
                            ["ERROR"] = 2,
                            ["WARNING"] = 3,
                            ["INFORMATION"] = 3,
                            ["HINT"] = 4,
                        }
                    }
                }
            }),
        })
    }

    local tcllint = {
        name = "tclint",
        method = null_ls.methods.DIAGNOSTICS,
        filetypes = { "tcl" },
        generator = helpers.generator_factory({
            command = "tclint",
            args = function (params)
                local rv = {}
                -- check if there is a config file in the root directory, if so
                -- insert the -c argument with it
                if vim.fn.filereadable(vim.fn.expand("~/.tcllint.toml")) == 1 then
                    table.insert(rv, '-c=' .. vim.fn.expand("~/.tcllint.toml"))
                end
                table.insert(rv, "$FILENAME")
                return rv
            end,
            cwd = nil,
            check_exit_code = function () return true end,
            from_stderr = false,
            ignore_stderr = true,
            to_stdin = true,
            to_temp_file = false,
            format = "line",
            multiple_files = false,
            -- TODO: Probably want to rework this so that I can generate actual severity levels for the different types
            -- of errors/warnings from the output, since it doesn't print "warning" or anything. That might also be
            -- something to create as a feature request on tclint instead
            on_output = helpers.diagnostics.from_patterns({
                {
                    pattern = [[.*:(%d+):(%d+):%s+(.*)%[(.*)%]$]],
                    groups = { 'row', 'col', 'message', 'code' },
                    overrides = {
                        severities = {
                            ["ERROR"] = 3,
                            ["WARNING"] = 3,
                            ["INFORMATION"] = 3,
                            ["HINT"] = 4,
                        },
                        diagnostic = {
                            -- I don't want red everywhere when using this for style checks. Those should be warnings
                            severity = vim.diagnostic.severity.WARN
                        }
                    }
                }
            }),
        })
    }

    local vsg_format = {
        name = "VSG Formatting",
        method = null_ls.methods.FORMATTING,
        filetypes = { "vhdl" },
        generator = helpers.formatter_factory({
            command = "vsg",
            args = { "-c$ROOT/vsg_config.yaml", "-f=$FILENAME", "-of=syntastic", "--fix" },
            cwd = nil,
            check_exit_code = { 0, 1 },
            ignore_stderr = true,
            to_temp_file = true,
            from_temp_file = true,
            to_stdin = false,
            multiple_files = false,
        })
    }

    null_ls.setup({
        on_attach = require('plugins.lsp').on_attach,
        on_init = function (new_client, _)
            new_client.offset_encoding = 'utf-32'
        end,
        diagnostics_format = "[#{c}] #{m} (#{s})",
        sources = {
            vsg_lint,
            vsg_format,
            tcllint,
            null_ls.builtins.code_actions.gitsigns,
        },
        root_dir = function (_)
            return vim.fs.dirname(vim.fs.find({ '.git', 'vsg_config.yaml', '.null-ls-root' }, { upward = true })[1]);
        end,
        temp_dir = "/tmp",
        debug = true
    })
    vim.cmd("command! ToggleVSG lua require('null-ls.sources').toggle('VSG')")
    vim.cmd("command! ToggleTCL lua require('null-ls.sources').toggle('tclint')")

    local notify = vim.notify
    vim.notify = function (msg, ...)
        if msg:match("warning: multiple different client offset_encodings") then
            return
        end

        notify(msg, ...)
    end
end

return M
