return {
    -- Null LS provides linting for linters that don't support LSP, adding for VSG, can use for others. None LS is a
    -- community maintained version of null-ls since null-ls was deprecated/archived by the original author
    -- 'nvimtools/none-ls.nvim',
    'SethGower/none-ls.nvim',
    branch = "vsg-vhdl-style-guide",
    config = function ()
        local null_ls = require('null-ls')
        local helpers = require('null-ls.helpers')

        null_ls.setup({
            -- on_attach = require('plugins.lsp').on_attach,
            on_init = function (new_client, _)
                new_client.offset_encoding = 'utf-32'
            end,
            diagnostics_format = "[#{c}] #{m} (#{s})",
            sources = {
                null_ls.builtins.diagnostics.vsg.with({
                    config = {
                        config_file_name = "vsg_config.yaml"
                    }
                }),
                null_ls.builtins.formatting.vsg.with({
                    config = {
                        config_file_name = "vsg_config.yaml"
                    }
                }),
                null_ls.builtins.code_actions.gitsigns,
                null_ls.builtins.formatting.alejandra,
                null_ls.builtins.formatting.shellharden,
                null_ls.builtins.diagnostics.checkmake,
                null_ls.builtins.hover.dictionary
            },
            root_dir = function (_)
                return vim.fs.dirname(vim.fs.find({ '.git', 'vsg_config.yaml', '.null-ls-root' },
                                                  { upward = true })[1]);
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
    ,
}
