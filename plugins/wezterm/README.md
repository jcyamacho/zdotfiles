# wezterm

GPU-accelerated terminal emulator with Lua configuration.

- <https://wezterm.org/>

## Environment Variables

| Variable              | Value                           |
| --------------------- | ------------------------------- |
| `WEZTERM_CONFIG_DIR`   | `~/.config/wezterm`             |
| `WEZTERM_CONFIG_FILE`  | `~/.config/wezterm/wezterm.lua` |

## Functions

| Function                | Description                              |
| ----------------------- | ---------------------------------------- |
| `install-wezterm`       | Install WezTerm via Homebrew cask        |
| `uninstall-wezterm`     | Remove WezTerm and its configuration     |
| `wezterm-restore-config` | Reset config to the default from repo   |
| `wezterm-config`        | Edit the WezTerm config file             |

## Notes

- Configuration is written in Lua
- Default config is copied from `plugins/wezterm/wezterm.lua`
