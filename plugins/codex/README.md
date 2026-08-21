# codex

OpenAI Codex CLI for AI-assisted coding.

- <https://developers.openai.com/codex/cli>

## Environment Variables

| Variable | Default |
| --- | --- |
| `CODEX_HOME` | `~/.codex` |

## Functions

| Function | Description |
| --- | --- |
| `install-codex` | Install Codex with Homebrew |
| `uninstall-codex` | Remove Codex and its configuration |
| `codex-config` | Open the Codex home directory in your editor |
| `cdx` | Interactive Codex launcher that clears the screen |
| `codex-clear-archived-sessions` | Remove archived Codex session directories |

## Notes

- Uses Homebrew for installation, removal, and updates through `update-brew`
- `cdx` forwards arguments to Codex and respects the user's Codex configuration
- `cdx` is a human-facing launcher that clears the screen without changing
  the terminal's colors
- Use raw `codex` directly for scripting, piping, or other non-interactive workflows
- Caches generated shell completions
