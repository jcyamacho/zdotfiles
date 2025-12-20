local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- Match Ghostty's "glass" feel.
config.color_scheme = 'catppuccin-mocha'

-- Typography
config.font = wezterm.font_with_fallback {
  'Monaspace Neon',
}
config.font_size = 14

-- Window layout
config.initial_cols = 120
config.initial_rows = 40
config.window_padding = {
  left = 10,
  right = 10,
  top = 0,
  bottom = 10,
}

-- macOS window chrome
-- WezTerm disables shadow automatically when opacity < 1.0; force it back on.
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE|MACOS_FORCE_ENABLE_SHADOW'

-- Subtle border to help the window stand out (thin, understated)
-- Pick a tone closer to the Catppuccin base so it doesn't feel "outlined".
config.window_frame = {
  border_left_width = '1px',
  border_right_width = '1px',
  border_bottom_height = '1px',
  border_top_height = '1px',
  border_left_color = '#2a2b3c',
  border_right_color = '#2a2b3c',
  border_bottom_color = '#2a2b3c',
  border_top_color = '#2a2b3c',
}

-- Transparency + blur (macOS)
config.window_background_opacity = 0.92
config.macos_window_background_blur = 18

-- Cursor & input
config.default_cursor_style = 'SteadyBar'
config.cursor_blink_rate = 0
config.use_dead_keys = true
config.send_composed_key_when_left_alt_is_pressed = true

-- Behavior
config.window_close_confirmation = 'NeverPrompt'
config.quit_when_all_windows_are_closed = true
config.scrollback_lines = 100000

-- Tabs (keep minimal; mostly hidden like Ghostty)
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

-- Catppuccin tab bar tuning
config.colors = {
  tab_bar = {
    background = '#11111b', -- crust
    active_tab = {
      bg_color = '#1e1e2e', -- base
      fg_color = '#cdd6f4', -- text
      intensity = 'Bold',
      underline = 'None',
      italic = false,
      strikethrough = false,
    },
    inactive_tab = {
      bg_color = '#181825', -- mantle
      fg_color = '#a6adc8', -- subtext0
    },
    inactive_tab_hover = {
      bg_color = '#313244', -- surface0
      fg_color = '#cdd6f4',
      italic = false,
    },
    new_tab = {
      bg_color = '#181825',
      fg_color = '#a6adc8',
    },
    new_tab_hover = {
      bg_color = '#313244',
      fg_color = '#a6e3a1',
      italic = false,
    },
  },
}

return config
