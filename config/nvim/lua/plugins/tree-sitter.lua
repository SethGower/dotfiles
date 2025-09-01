------------------------- TREE-SITTER -------------------------


local parser_config = require "nvim-treesitter.parsers".get_parser_configs()

local ts = require('nvim-treesitter.configs')

ts.setup {
    ensure_installed = 'all',
    ignore_install = { 'norg', 'ipkg' }, -- this is failing with a cc1plus error and I can't figure it out. I don't need it, so ignore it
    query_linter = {
        enabled = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
    },
    highlight = { -- built in
        additional_vim_regex_highlighting = false,
        enable = true,
        disable = { 'html' }
    },
    indent = { -- built in
        enable = true
    },
    rainbow = {                -- added by p00f/nvim-ts-rainbow
        enable = true,
        extended_mode = true,  -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
        max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
    },
    autotag = {                -- added by windwp/nvim-ts-autotag
        enable = true,
    },
    autopairs = {
        enable = false,
    },
}
require 'treesitter-context'.setup {
    enable = true,          -- Enable this plugin (Can be enabled/disabled later via commands)
    multiwindow = false,    -- Enable multiwindow support.
    max_lines = 3,          -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0,  -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20, -- Maximum number of lines to show for a single context
    trim_scope = 'outer',   -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = 'cursor',        -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
    zindex = 20,   -- The Z-index of the context window
    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}
require('ts_context_commentstring').setup {
    enable_autocmd = false,
}
