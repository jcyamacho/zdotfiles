# codex

OpenAI Codex CLI for AI-assisted coding.

- <https://developers.openai.com/codex/cli>

## Environment Variables

| Variable            | Value               |
| ------------------- | ------------------- |
| `CODEX_HOME`        | `~/.codex`          |
| `CODEX_PROMPTS_DIR` | `~/.codex/prompts`  |
| `CODEX_SECURE_MODE` | `1`                 |

## Functions

| Function | Description |
| --- | --- |
| `install-codex` | Install Codex (Homebrew preferred, npm fallback) |
| `uninstall-codex` | Remove Codex and its configuration |
| `update-codex` | Update Codex (npm install only) |
| `codex-config` | Open the Codex home directory in your editor |
| `cdx` | Interactive Codex launcher with defaults and terminal polish |
| `codex-clear-archived-sessions` | Remove archived Codex session directories |

## Notes

- Prefers Homebrew install over npm
- `cdx` enables web search, workspace-write sandbox, and approval on-request
- `cdx` is a human-facing launcher: it clears the screen, sets a darker
  terminal background, and restores terminal state on exit
- Use raw `codex` directly for scripting, piping, or other non-interactive workflows
- Uses cached init for shell completions
