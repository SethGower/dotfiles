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
        -- show_current_context = true,
        -- show_current_context_start = true,
    }
end

M.trouble = function()
    require("trouble").setup {
        position = "bottom", -- position of the list can be: bottom, top, left, right
        height = 10, -- height of the trouble list when position is top or bottom
        width = 50, -- width of the list when position is left or right
        icons = true, -- use devicons for filenames
        mode = "document_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
        fold_open = "", -- icon used for open folds
        fold_closed = "", -- icon used for closed folds
        group = true, -- group results by file
        padding = true, -- add an extra new line on top of the list
        action_keys = { -- key mappings for actions in the trouble list
            -- map to {} to remove a mapping, for example:
            -- close = {},
            close = { "q", "<leader>d" }, -- close the list
            cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
            refresh = "r", -- manually refresh
            jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
            open_split = { "<c-x>" }, -- open buffer in new split
            open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
            open_tab = { "<c-t>" }, -- open buffer in new tab
            jump_close = { "o" }, -- jump to the diagnostic and close the list
            toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
            toggle_preview = "P", -- toggle auto_preview
            hover = "K", -- opens a small popup with the full multiline message
            preview = "p", -- preview the diagnostic location
            close_folds = { "zM", "zm" }, -- close all folds
            open_folds = { "zR", "zr" }, -- open all folds
            toggle_fold = { "zA", "za" }, -- toggle fold of current file
            previous = "k", -- previous item
            next = "j" -- next item
        },
        indent_lines = true, -- add an indent guide below the fold icons
        auto_open = false, -- automatically open the list when you have diagnostics
        auto_close = false, -- automatically close the list when you have no diagnostics
        auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
        auto_fold = false, -- automatically fold a file trouble list at creation
        auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
        signs = {
            -- icons / text used for a diagnostic
            error = "",
            warning = "",
            hint = "",
            information = "",
            other = "﫠"
        },
        use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
    }
end

M.snippets = function()
    require("luasnip.loaders.from_snipmate").lazy_load()

    vim.cmd([[imap <silent><expr> <C-j> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<C-j>' ]])
    vim.cmd([[inoremap <silent> <C-k> <cmd>lua require'luasnip'.jump(-1)<Cr>]])
    vim.cmd([[snoremap <silent> <C-j> <cmd>lua require('luasnip').jump(1)<Cr>]])
    vim.cmd([[snoremap <silent> <C-k> <cmd>lua require('luasnip').jump(-1)<Cr>]])
end
return M
