------------------------- GIT SIGNS -------------------------
require('gitsigns').setup {
    signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '│' },
        topdelete    = { text = '│' },
        changedelete = { text = '│' },
        untracked    = { text = '┆' },
    },
    current_line_blame = true,
    -- current_line_blame_delay = 100
}
