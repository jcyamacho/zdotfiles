# ghostty

GPU-accelerated terminal emulator.

- <https://ghostty.org/>

## Configuration Paths

| Purpose | Path |
| --- | --- |
| Configuration directory | `~/.config/ghostty` |
| Themes directory | `~/.config/ghostty/themes` |
| Configuration file | `~/.config/ghostty/config` |

## Functions

| Function                 | Description                                    |
| ------------------------ | ---------------------------------------------- |
| `install-ghostty`        | Install Ghostty and Monaspace via Homebrew     |
| `uninstall-ghostty`      | Remove Ghostty and its configuration           |
| `ghostty-update-themes`  | Download latest Catppuccin themes              |
| `ghostty-restore-config` | Reset config to default and update themes      |
| `ghostty-config`         | Edit the Ghostty config file                   |

## Notes

- Includes Catppuccin theme variants (mocha, macchiato, latte, frappe)
- On macOS, removes the default macOS config location on restore
- Theme updates are registered with `update-all`
