local wezterm = require('wezterm')
local config = wezterm.config_builder()

config.default_prog = { 'zellij', '-l', 'welcome' }

config.initial_rows = 61
config.initial_cols = 248

return config
