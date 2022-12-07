local M = {}

M.session_lens = function()
    require("telescope").load_extension("session-lens")
    require('session-lens').setup({
        path_display = { 'shorten' },
        previewer = true
    })
end

M.lsp_toggle = function()
    require('lsp-toggle').setup {
        create_cmds = true, -- Whether to create user commands
        telescope = true, -- Whether to load telescope extensions
    }
end

M.ultisnips = function()
    vim.g.UltiSnipsExpandTrigger       = '<C-j>'
    vim.g.UltiSnipsJumpForwardTriggeru = '<C-j>'
    vim.g.UltiSnipsJumpBackwardTrigger = '<C-k>'
end

return M
