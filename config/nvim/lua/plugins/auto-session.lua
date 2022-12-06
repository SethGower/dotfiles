------------------------- AUTO SESSIONS -------------------------

-- function to close floating windows. When they are open when a session is
-- saved, it causes the command window on the bottom to take up the whole
-- buffer https://github.com/rmagatti/auto-session/wiki/Troubleshooting#issue-cmdheight-after-restore-is-incorrect
function _G.close_all_floating_wins()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= '' then
            vim.api.nvim_win_close(win, false)
        end
    end
end

require("telescope").load_extension("session-lens")
require('auto-session').setup({
    pre_save_cmds = { _G.close_all_floating_wins },
    log_level = "error",
    auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
    auto_save_enabled = true,
})

require('session-lens').setup({
    path_display = { 'shorten' },
    previewer = true
})
