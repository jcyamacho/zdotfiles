# yazi

Blazing fast terminal file manager written in Rust, based on async I/O.

- <https://yazi-rs.github.io/>

## Environment Variables

| Variable           | Value               |
| ------------------ | ------------------- |
| `YAZI_CONFIG_HOME` | `~/.config/yazi`    |

## Functions

| Function              | Description                                |
| --------------------- | ------------------------------------------ |
| `install-yazi`        | Install yazi and dependencies via Homebrew |
| `uninstall-yazi`      | Remove yazi and its configuration          |
| `yazi-restore-config` | Reset config and reinstall flavor          |
| `yazi-config`         | Open the yazi config directory in editor   |
| `y`                   | Launch yazi with CWD change on exit        |

## Keybindings

| Key      | Description                              |
| -------- | ---------------------------------------- |
| `Ctrl+o` | Open yazi (same as `y`, with prompt fix) |

## Config Files

| File         | Description                         |
| ------------ | ----------------------------------- |
| `yazi.toml`  | Main config (show_hidden enabled)   |
| `theme.toml` | Theme config (catppuccin-mocha)     |

## Notes

- Installs catppuccin-mocha flavor via `ya pkg`
- Press `q` to quit and change directory, `Q` to quit without changing
- Optional dependencies (for previews/search): ffmpeg, sevenzip, jq, poppler,
  fd, ripgrep, fzf, zoxide, resvg, imagemagick
