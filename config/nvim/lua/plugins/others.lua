local M = {}

M.session_lens = function ()
    require("telescope").load_extension("session-lens")
    require('session-lens').setup({
        path_display = { 'shorten' },
        previewer = true
    })
end

M.lsp_toggle = function ()
    require('lsp-toggle').setup {
        create_cmds = true, -- Whether to create user commands
        telescope = true,   -- Whether to load telescope extensions
    }
end

M.matchup = function ()
    require('nvim-treesitter.configs').setup {
        matchup = {
            enable = true,
        }
    }

    vim.g.matchup_matchparen_deferred = 0
    vim.g.matchup_matchparen_offscreen = {} --{ method = 'popup' }
end

M.harpoon = function ()
    require('telescope').load_extension('harpoon')
end

M.indentline = function ()
    -- vim.opt.list = true
    -- vim.opt.listchars:append "space:⋅"
    -- vim.opt.listchars:append "eol:↴"

    local ibl = require("ibl")
    -- local hooks = require("ibl.hooks")
    -- local indent_chars = {
    --     "▏",
    --     "▎",
    --     "▍",
    --     "▌",
    --     "▋",
    --     "▊",
    --     "▉",
    --     "█",
    --     "│",
    --     "┃",
    --     "┆",
    --     "┇",
    --     "┊",
    --     "┋",
    -- }

    -- hooks.register(hooks.type.HIGHLIGHT_SETUP, function ()
    --     -- Indent line colors
    --     -- Indent scope colors
    --     local colorutils = require("utils.colors")
    --     local sc_hl = vim.api.nvim_get_hl(0, { name = "Normal" })
    --     local sc_hl_bg = colorutils.hl_to_hex(sc_hl.bg or 0x000000)
    --     local sc_hl_fg = colorutils.hl_to_hex(sc_hl.fg or 0xFFFFFF)

    --     local gray = colorutils.blend(sc_hl_fg, sc_hl_bg, 0.50)
    --     local spaces = colorutils.blend(sc_hl_fg, sc_hl_bg, 0.10)

    --     vim.api.nvim_set_hl(0, "IblScope", { fg = gray })
    --     vim.api.nvim_set_hl(0, "IblWhitespace", { fg = spaces })
    -- end)
    -- local blank_line_opts = {
    --     indent = {
    --         char = indent_chars[9],
    --         smart_indent_cap = true,
    --         highlight = "IblIndent",
    --     },
    --     whitespace = {
    --         highlight = "IblWhitespace",
    --     },
    --     exclude = {
    --         filetypes = {
    --             "help", "terminal", "NvimTree",
    --             "TelescopePrompt", "TelescopeResults"
    --         },
    --         buftypes = {
    --             "terminal"
    --         },
    --     },
    --     scope = {
    --         enabled = true,
    --         char = indent_chars[10],
    --         show_start = false,
    --         show_end = false,
    --         highlight = "IblScope",
    --     },
    -- }

    vim.opt.list = true
    vim.opt.listchars:append "space:⋅"
    vim.opt.listchars:append "eol:↴"

    -- Enabled these for endline
    -- vim.opt.list = true
    -- vim.opt.listchars = {
    --     -- eol = "" -- Option 1
    --     -- eol = "↴" -- Option 2
    --     tab = "   ",
    --     lead = "∙",
    --     -- leadmultispace = "⋅˙",
    -- }

    ibl.setup({
        scope = {
            enabled = true
        }
    })
end

M.trouble = function ()
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

M.notify = function ()
    -- vim.o.termguicolors = true
    require("notify").setup({
        background_colour = "#000000"
    })
end
return M
