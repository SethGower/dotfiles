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

M.matchup = function()
    vim.g.matchup_matchparen_offscreen = {} -- disables the showing match offscreen. This was annoying
end

M.harpoon = function()
    require('telescope').load_extension('harpoon')
end

M.indentline = function()
    vim.opt.list = true
    vim.opt.listchars:append "space:⋅"
    vim.opt.listchars:append "eol:↴"

    require("indent_blankline").setup {
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
    }
end
return M
