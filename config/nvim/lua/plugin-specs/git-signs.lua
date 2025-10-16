------------------------- GIT SIGNS -------------------------
return { -- Git modification signs
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
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
}
