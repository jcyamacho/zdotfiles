# codex

Manages the [OpenAI Codex CLI](https://developers.openai.com/codex/cli)
through its Homebrew cask and adds a `cdx` alias and helpers for the Codex home
directory.

## Commands

| Command | Description |
| --- | --- |
| `cdx [args...]` | Alias for `codex` |
| `codex-config` | Open the `$CODEX_HOME` directory in `$EDITOR` |
| `codex-clear-archived-sessions` | Delete the files and directories in `$CODEX_HOME/archived_sessions` without asking |
| `install-codex` | Install the `codex` cask and create `$CODEX_HOME` if missing |
| `uninstall-codex` | Uninstall the `codex` cask, then ask whether to delete `$CODEX_HOME` (default no) |

## Environment Variables

| Variable | Default |
| --- | --- |
| `CODEX_HOME` | `~/.codex` |

The plugin exports `CODEX_HOME` even when Codex is not installed, and keeps
any value you set before it loads.

## Notes

- `install-codex` exists only while `codex` is missing from `PATH`. The other
  commands exist only after Codex is installed.
- `update-brew` keeps Codex up to date. The plugin has no separate updater.
- The `codex` cask installs the zsh completion into Homebrew's
  `site-functions`. `cdx` uses the same completions as `codex`.
