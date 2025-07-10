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
    context = { -- added by romgrk/nvim-treesitter-context
        enable = true,
    },
    autopairs = {
        enable = false,
    },
}

require('ts_context_commentstring').setup {
    enable_autocmd = false,
}
