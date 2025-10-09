local wezterm = require('wezterm')
local config = wezterm.config_builder()

config.default_prog = { 'zellij', '-l', 'welcome' }

config.font = wezterm.font(
    'IosevkaTerm Nerd Font Mono',
    { stretch = 'Expanded', weight = 'Regular' }
)

local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
    local tab, pane, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
end)

return config
