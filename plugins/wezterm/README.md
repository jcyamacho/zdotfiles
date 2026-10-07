# wezterm

Installs [WezTerm](https://wezterm.org/), a GPU-accelerated terminal emulator
configured in Lua, with a bundled config and commands to edit or restore it.

## Commands

| Command | Description |
| --- | --- |
| `install-wezterm` | Install the WezTerm cask with Homebrew and copy the bundled config to `$WEZTERM_CONFIG_FILE` |
| `uninstall-wezterm` | Uninstall the WezTerm cask and delete `~/.config/wezterm` |
| `wezterm-config` | Open `$WEZTERM_CONFIG_FILE` in `$EDITOR` |
| `wezterm-restore-config` | Replace `$WEZTERM_CONFIG_FILE` with the bundled config |

`install-wezterm` exists only while `wezterm` is not on your `PATH`. The other
commands exist only after WezTerm is installed.

`install-wezterm` and `wezterm-restore-config` overwrite any existing file at
`$WEZTERM_CONFIG_FILE` without asking. `uninstall-wezterm` deletes
`~/.config/wezterm` without asking, even when `WEZTERM_CONFIG_FILE` points to a
file elsewhere.

## Environment Variables

| Variable | Default |
| --- | --- |
| `WEZTERM_CONFIG_FILE` | `~/.config/wezterm/wezterm.lua` |

WezTerm loads its config from `WEZTERM_CONFIG_FILE` when it is set
([config file lookup](https://wezterm.org/config/files.html)). The plugin
exports the variable, and the install, restore, and config commands use it. To
use another path, set it in `~/.zshrc` before the `source` line.

## Bundled Configuration

[`wezterm.lua`](wezterm.lua) configures:

- Catppuccin Mocha colors, including the tab bar
- Monaspace Neon at 14 pt (install it with `install-fonts`)
- Windows that open at 120 columns by 40 rows, with the window buttons in the
  tab bar instead of a title bar (`INTEGRATED_BUTTONS|RESIZE`), 92% opacity,
  and background blur
- A tab bar at the bottom that hides when only one tab is open
- A steady, non-blinking bar cursor and 100,000 lines of scrollback
- Left Option for composing characters, such as accented letters, instead of a
  plain Alt key
- No confirmation prompt when closing a window

## Notes

- WezTerm reloads the config when the file changes
  ([upstream docs](https://wezterm.org/config/files.html)), so edits apply
  without a restart.
- `update-brew` keeps WezTerm current.
