local cmp = require 'cmp'
local _ = { behavior = cmp.SelectBehavior.Select }

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
        ['<C-p>'] = cmp.mapping.select_prev_item(nil),
        ['<C-n>'] = cmp.mapping.select_next_item(nil),
    }
}
