return {
    'saghen/blink.cmp',
    version = '*',
    dependencies = 'rafamadriz/friendly-snippets',
    opts = {
        keymap = {
            preset = 'enter',
            ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<C-e>'] = { 'hide', 'fallback' },
            ['<Tab>'] = {
                'select_next',
                'snippet_forward',
                'fallback'
            },
            ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
            ['<Up>'] = { 'select_prev', 'fallback' },
            ['<Down>'] = { 'select_next', 'fallback' },

            ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

            ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
        },

        appearance = {
            -- Sets the fallback highlight groups to nvim-cmp's highlight groups
            -- Useful for when your theme doesn't support blink.cmp
            -- Will be removed in a future release
            use_nvim_cmp_as_default = true,
            -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono'
        },

        -- Default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, due to `opts_extend`
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },

        -- Blink.cmp uses a Rust fuzzy matcher by default for typo resistance and significantly better performance
        -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
        -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
        --
        -- See the fuzzy documentation for more information
        fuzzy = { implementation = "prefer_rust" },
        cmdline = {
            enabled = true,
            keymap = {
                ['<Tab>'] = { 'select_next' },
                ['<S-Tab>'] = { 'select_prev' },
                ['<CR>'] = { 'accept_and_enter', 'fallback' },
            },
            sources = function ()
                local type = vim.fn.getcmdtype()
                -- Search forward and backward
                if type == '/' or type == '?' then return { 'buffer' } end
                -- Commands
                if type == ':' or type == '@' then return { 'cmdline' } end
                return {}
            end,
            completion = {
                trigger = {
                    show_on_blocked_trigger_characters = {},
                    show_on_x_blocked_trigger_characters = {},
                },
                list = {
                    selection = {
                        -- When `true`, will automatically select the first item in the completion list
                        preselect = false,
                        -- When `true`, inserts the completion item automatically when selecting it
                        auto_insert = true,
                    },
                },
                -- Whether to automatically show the window when new completion items are available
                menu = { auto_show = true },
                -- Displays a preview of the selected item on the current line
                ghost_text = { enabled = true }
            }
        },
        completion = {
            keyword = {
                -- 'prefix' will fuzzy match on the text before the cursor
                -- 'full' will fuzzy match on the text before *and* after the cursor
                -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
                range = "full",
            },
            menu = {
                border = "single",
            },
            documentation = {
                auto_show = true,
                window = {
                    border = "single",
                },
            },
            ghost_text = {
                enabled = false,
            },
        },
        snippets = {
            preset = "luasnip"
        },

    },
    opts_extend = { "sources.default" },
}
