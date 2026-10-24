# codex

Manages the [OpenAI Codex CLI](https://developers.openai.com/codex/cli) and the
[ChatGPT](https://chatgpt.com/) desktop app, which includes Codex, through
their Homebrew casks, and adds a `cdx` alias and helpers for the Codex home
directory.

## Commands

| Command | Description |
| --- | --- |
| `cdx [args...]` | Alias for `codex` |
| `codex-config` | Open the `$CODEX_HOME` directory in `$EDITOR` |
| `codex-clear-archived-sessions` | Delete the files and directories in `$CODEX_HOME/archived_sessions` without asking |
| `install-codex` | Install the `codex` cask and create `$CODEX_HOME` if missing |
| `uninstall-codex` | Uninstall the `codex` cask, then ask whether to delete `$CODEX_HOME` (default no) |
| `install-chatgpt` | Install the `chatgpt` cask |
| `uninstall-chatgpt` | Ask whether to delete the app's data and sign-in in `~/Library` (default no), uninstall the `chatgpt` cask, and delete its caches in `~/Library/Caches` |

## Environment Variables

| Variable | Default |
| --- | --- |
| `CODEX_HOME` | `~/.codex` |

The plugin exports `CODEX_HOME` even when Codex is not installed, and keeps
any value you set before it loads. Apps opened from the Dock or Finder do not
inherit shell exports, so a custom `CODEX_HOME` does not reach the ChatGPT
desktop app opened that way.

## Notes

- `install-codex` exists only while `codex` is missing from `PATH`, and the
  other Codex CLI commands exist only after it is installed. Likewise,
  `install-chatgpt` exists only while `/Applications/ChatGPT.app` is missing,
  and `uninstall-chatgpt` only while it exists.
- `update-brew` keeps the Codex CLI up to date, and the ChatGPT desktop app
  updates itself. The plugin has no separate updater.
- The ChatGPT desktop app reads its Codex config from `~/.codex` and bundles
  its own `codex`. `uninstall-chatgpt` keeps the data in `$CODEX_HOME`; the
  cask's zap removes `~/.codex` only when it is empty.
- The `codex` cask installs the zsh completion into Homebrew's
  `site-functions`. `cdx` uses the same completions as `codex`.
