-- Pull in the wezterm API
local wezterm = require 'wezterm'

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

config.font = wezterm.font 'Monaco'
config.font_size = 16
config.color_scheme = 'Adventure Time (Gogh)'

config.disable_default_key_bindings = true

return config

