------------------------- TREE-SITTER -------------------------

local ts = require('nvim-treesitter.configs')

ts.setup {
    ensure_installed = 'all',
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
    -- matchup = {
    --   enable =false,
    -- },
    playground = {
        enable = true,
        disable = {},
        updatetime = 25,         -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = 'o',
            toggle_hl_groups = 'i',
            toggle_injected_languages = 't',
            toggle_anonymous_nodes = 'a',
            toggle_language_display = 'I',
            focus_language = 'f',
            unfocus_language = 'F',
            update = 'R',
            goto_node = '<cr>',
            show_help = '?',
        },
    },
    context_commentstring = {
        enable = true,
    },
}


local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.vhdl = {
    install_info = {
        url = "~/.local/share/tree-sitter/tree-sitter-vhdl",
        files = { "src/parser.c" }
    },
    filetype = "vhdl"
}
