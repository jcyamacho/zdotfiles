# ghostty

Installs the [Ghostty](https://ghostty.org/) terminal with a bundled config,
the [Monaspace](https://monaspace.githubnext.com/) font, and
[Catppuccin](https://github.com/catppuccin/ghostty) themes, and adds commands to
edit and restore the config and update the themes.

## Commands

| Command | Description |
| --- | --- |
| `install-ghostty` | Install the `font-monaspace` and `ghostty` casks, download the themes, and copy the bundled config if you have none |
| `uninstall-ghostty` | Uninstall the `ghostty` cask, then ask whether to delete `~/.config/ghostty` (default no) |
| `ghostty-config` | Open `~/.config/ghostty/config` in `$EDITOR` |
| `ghostty-update-themes` | Download the latest Catppuccin themes into `~/.config/ghostty/themes` |
| `ghostty-restore-config` | Download the themes and replace `~/.config/ghostty/config` with the bundled config |

`install-ghostty` exists only when the `ghostty` command is not on `$PATH`. The
other commands exist only when it is. `update-all` runs `ghostty-update-themes`.

## Configuration Paths

| Purpose | Path |
| --- | --- |
| Config directory | `~/.config/ghostty` |
| Config file | `~/.config/ghostty/config` |
| Themes directory | `~/.config/ghostty/themes` |
| Bundled config | [`plugins/ghostty/config`](config) |

## Bundled Configuration

The bundled [`config`](config) uses the Monaspace Neon font and the
`catppuccin-mocha.conf` theme. `ghostty-update-themes` downloads
`catppuccin-mocha.conf`, `catppuccin-macchiato.conf`, `catppuccin-latte.conf`,
and `catppuccin-frappe.conf`. To use another variant, set `theme` in your
config to one of those file names.

## Notes

- `install-ghostty` keeps an existing `~/.config/ghostty/config`, so a
  reinstall keeps the config an uninstall kept. `ghostty-restore-config`
  overwrites it without asking.
- Whenever they copy the bundled config, both commands also delete `config`
  and `config.ghostty` from `~/Library/Application Support/com.mitchellh.ghostty`
  on macOS. Ghostty loads those files after `~/.config/ghostty/config`, so their
  values would override the bundled ones
  ([Ghostty config docs](https://ghostty.org/docs/config)).
- If a theme fails to download, `ghostty-update-themes` (and so `update-all`)
  reports an error; install and restore print a warning and continue.
- `uninstall-ghostty` leaves the Monaspace font installed.
