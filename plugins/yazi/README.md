# yazi

Shell integration for [yazi](https://yazi-rs.github.io/), a terminal file
manager. It adds a `y` wrapper that changes the shell's directory when yazi
quits, a `Ctrl+o` key binding, and a bundled config that uses the Catppuccin
Mocha flavor from [yazi-rs/flavors](https://github.com/yazi-rs/flavors).

## Commands

| Command | Description |
| --- | --- |
| `y [args]` | Open yazi with `args` and change to its last directory on quit |
| `yazi-config` | Open `$YAZI_CONFIG_HOME` in `$EDITOR` |
| `yazi-restore-config` | Install the flavor and overwrite `yazi.toml` and `theme.toml` with the bundled copies |
| `install-yazi` | Install yazi with Homebrew, then apply the bundled config as `yazi-restore-config` does if `$YAZI_CONFIG_HOME` does not exist |
| `uninstall-yazi` | Uninstall yazi with Homebrew, then ask whether to delete `$YAZI_CONFIG_HOME` (default no) |

`install-yazi` exists only while yazi is missing. The other commands and the
`Ctrl+o` binding exist only when yazi is installed.

According to
[yazi's shell wrapper docs](https://yazi-rs.github.io/docs/quick-start#shell-wrapper),
quitting with `q` changes the directory and quitting with `Q` does not.

## Environment Variables

| Variable | Default |
| --- | --- |
| `YAZI_CONFIG_HOME` | `~/.config/yazi` |

The plugin exports `YAZI_CONFIG_HOME` and keeps any value set before it loads.
Yazi reads its configuration from this directory, which the commands above
also use.

## Key Binding

`Ctrl+o` runs `y` without arguments, then redraws the prompt so it shows the
new directory.

## Bundled Configuration

`yazi-restore-config`, and `install-yazi` when you have no config directory,
first run `ya pkg add yazi-rs/flavors:catppuccin-mocha` to install the flavor.
If that fails, for example because the flavor is already installed, they print
a warning and continue. They then copy these files into `$YAZI_CONFIG_HOME`,
replacing existing copies and leaving other files there unchanged:

| File | Effect |
| --- | --- |
| [`yazi.toml`](yazi.toml) | Shows hidden files (`show_hidden = true` under `[mgr]`) |
| [`theme.toml`](theme.toml) | Uses the `catppuccin-mocha` flavor in dark mode; sets no light-mode flavor |

## Notes

- `install-yazi` installs only the `yazi` Homebrew formula, which provides the
  `yazi` and `ya` commands. Yazi's
  [installation guide](https://yazi-rs.github.io/docs/installation) lists
  optional tools, such as ffmpeg, fd, and ripgrep, that enable previews and
  search.
- An existing `$YAZI_CONFIG_HOME` makes `install-yazi` skip the bundled
  config, so a reinstall keeps the config an uninstall kept.
- The plugin has no updater. `update-brew` upgrades yazi, and
  `ya pkg upgrade` upgrades installed yazi packages such as the flavor.
