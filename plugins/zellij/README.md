# zellij

Installs [Zellij](https://zellij.dev/), a terminal workspace manager, with
Homebrew. Adds a session helper, a config shortcut, and layouts that run Claude
Code or Codex above a shell.

## Commands

| Command | Description |
| --- | --- |
| `install-zellij` | Install Zellij with Homebrew and copy the bundled layouts |
| `zj` | Alias for `zellij` |
| `za [session]` | Attach to a session or create it; see [Session Names](#session-names) |
| `zellij-config` | Open `$ZELLIJ_CONFIG_DIR` in `$EDITOR` without waiting |
| `zellij-copy-layouts` | Copy the bundled layouts to `$ZELLIJ_CONFIG_DIR/layouts` |
| `uninstall-zellij` | Uninstall Zellij with Homebrew, then delete `$ZELLIJ_CONFIG_DIR` without asking |

`install-zellij` exists only while `zellij` is not on `PATH`. The other
commands exist whenever `zellij` is on `PATH`, however it was installed, but
`uninstall-zellij` works only for a Homebrew install.

## Environment Variables

| Variable | Default |
| --- | --- |
| `ZELLIJ_CONFIG_DIR` | `$HOME/.config/zellij` |

The plugin exports `ZELLIJ_CONFIG_DIR` and keeps any value set before it loads.
Zellij reads its configuration from this directory
([configuration docs](https://zellij.dev/documentation/configuration.html)).

## Session Names

`za` builds the session name, then runs `zellij attach -c` to attach to that
session or create it:

1. Uses the argument, or the current directory's name when there is none
2. Replaces each `/` with `-`, so `za work/api` uses `work-api`
3. Shortens names longer than 36 characters to exactly 36: the start of the
   name, a `-`, and a `cksum` checksum of the whole name

## Layouts

`install-zellij` and `zellij-copy-layouts` copy these layouts to
`$ZELLIJ_CONFIG_DIR/layouts`, replacing files with the same names:

| Layout | Opens |
| --- | --- |
| [`claude`](layouts/claude.kdl) | A borderless `claude` pane at 70% height above a `zsh` pane |
| [`codex`](layouts/codex.kdl) | A borderless `codex` pane at 70% height above a `zsh` pane |

Zellij finds layouts in that directory by name
([layouts docs](https://zellij.dev/documentation/layouts.html)), so start one
with `zellij --layout claude`. The `claude` layout needs Claude Code
(`install-claude-code`), and the `codex` layout needs Codex (`install-codex`).

## Notes

- Zsh completions come from `zellij setup --generate-completion zsh` and are
  cached in `$ZDOTFILES_CACHE_DIR/completions/_zellij`. The cache regenerates
  when the `zellij` binary or the plugin file is newer than the cache.
