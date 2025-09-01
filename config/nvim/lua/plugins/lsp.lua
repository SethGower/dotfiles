------------------------- LSP -------------------------
local lspconfig = require('lspconfig')
local configs = require('lspconfig.configs')
local util = require('lspconfig.util')

local M = {}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
M.on_attach = function (client, bufnr)
    require("mappings").lsp_setup(client, bufnr)

    vim.opt.updatetime = 300

    require('nlspsettings').update_settings(client.name)

    -- Server capabilities spec:
    -- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#serverCapabilities
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
        vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Document Highlight",
        })
        vim.api.nvim_create_autocmd({ "CursorMoved" }, {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Clear All the References",
        })
    end
end

M.setup = function ()
    local on_attach = M.on_attach

    local capabilities = vim.lsp.protocol.make_client_capabilities()

    local cmp_present, blink_cmp = pcall(require, 'blink.cmp')
    if cmp_present then
        capabilities = vim.tbl_extend("force", capabilities, blink_cmp.get_lsp_capabilities())
    end


    local nlspsettings = require("nlspsettings")

    -- Sets the defaults for the server configurations. This way I don't have to specify these for every single one
    lspconfig.util.default_config = vim.tbl_extend("force", lspconfig.util.default_config, {
        capabilities = capabilities,
        on_attach = on_attach,
    })
    if not configs.tclsp then
        configs.tclsp = {
            default_config = {
                cmd = { "tclsp" };
                filetypes = { "tcl" };
                root_dir = function (fname)
                    return util.find_git_ancestor(fname)
                end;
                settings = {};
            };
        }
    end
    -- Use a loop to conveniently call 'setup' on multiple servers and
    -- map buffer local keybindings when the language server attaches
    local servers = { "pylsp", "rust_analyzer", "texlab", "bashls", "vimls", "jsonls", "cmake", "marksman",
        "ginko_ls", "tclsp", "vhdl_ls" }
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
        cmd = { "verible-verilog-ls", "--rules_config_search", "--indentation_spaces", "4" },
        root_dir = function (_)
            return vim.fs.dirname(vim.fs.find({ '.git', 'vhdl_ls.toml' }, { upward = true })[1]);
        end,
        filetypes = { 'systemverilog' }
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
    for _, client in ipairs(vim.lsp.get_clients()) do
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
            null_ls.builtins.code_actions.gitsigns,
            null_ls.builtins.formatting.alejandra
        },
        root_dir = function (_)
            return vim.fs.dirname(vim.fs.find({ '.git', 'vsg_config.yaml', '.null-ls-root' }, { upward = true })[1]);
        end,
        temp_dir = "/tmp",
        debug = false
    })
    vim.cmd("command! ToggleVSG lua require('null-ls.sources').toggle('VSG')")

    local notify = vim.notify
    vim.notify = function (msg, ...)
        if msg:match("warning: multiple different client offset_encodings") then
            return
        end

        notify(msg, ...)
    end
end

return M
