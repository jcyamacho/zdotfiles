local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
config.window_padding = {
  left = 5,
  right = 5,
  top = 20,
  bottom = 0,
}

config.window_close_confirmation = "NeverPrompt"

config.use_dead_keys = true
config.send_composed_key_when_left_alt_is_pressed = true

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

config.initial_cols = 120
config.initial_rows = 40

config.font_size = 15
config.font = wezterm.font_with_fallback {
  'Monaspace Neon',
}
config.color_scheme = 'catppuccin-mocha'

config.colors = {
  tab_bar = {
    background = "#11111b", -- crust
    active_tab = {
      bg_color = "#1e1e2e", -- base
      fg_color = "#cdd6f4", -- text
      intensity = "Bold",
      underline = "None",
      italic = false,
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = "#181825", -- mantle
      fg_color = "#a6adc8", -- subtext0
    },
    inactive_tab_hover = {
      bg_color = "#313244", -- surface0
      fg_color = "#cdd6f4",
      italic = false,
    },
    new_tab = {
      bg_color = "#181825",
      fg_color = "#a6adc8",
    },
    new_tab_hover = {
      bg_color = "#313244",
      fg_color = "#a6e3a1", -- subtle green accent
      italic = false,
    },
  },
}

return config
