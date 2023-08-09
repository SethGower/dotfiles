------------------------- AUTO PAIRS -------------------------
local npairs = require('nvim-autopairs')
npairs.setup({
    check_ts = true,
    fast_wrap = {
        map = '<C-e>',
    },
    enable_check_bracket_line = false
})

-- skip it, if you use another global object
_G.MUtils = {}

MUtils.completion_confirm = function ()
    if vim.fn.pumvisible() ~= 0 then
        return npairs.esc("<cr>") -- simply the plugins wrapper for termcode replacement
    else
        return npairs.autopairs_cr()
    end
end
