# ghostty

GPU-accelerated terminal emulator.

- <https://ghostty.org/>

## Environment Variables

| Variable             | Value                         |
| -------------------- | ----------------------------- |
| `GHOSTTY_CONFIG_DIR`  | `~/.config/ghostty`           |
| `GHOSTTY_THEMES_DIR`  | `~/.config/ghostty/themes`    |
| `GHOSTTY_CONFIG_FILE` | `~/.config/ghostty/config`    |

## Functions

| Function                | Description                                    |
| ----------------------- | ---------------------------------------------- |
| `install-ghostty`       | Install Ghostty via Homebrew cask              |
| `uninstall-ghostty`     | Remove Ghostty and its configuration           |
| `ghostty-update-themes` | Download latest Catppuccin themes              |
| `ghostty-restore-config` | Reset config to default and update themes     |
| `ghostty-config`        | Edit the Ghostty config file                   |

## Notes

- Includes Catppuccin theme variants (mocha, macchiato, latte, frappe)
- On macOS, removes the default macOS config location on restore
- Theme updates are registered with `update-all`
