local cmp = require 'cmp'
local select_opts = {behavior = cmp.SelectBehavior.Select}

cmp.setup {
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    sources = {
        { name = 'buffer' },
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' }
    },
    mappings = {
        ['<Tab>'] = cmp.mapping.select_prev_item(select_opts),
        ['<S-Tab>'] = cmp.mapping.select_next_item(select_opts),
    }
}

