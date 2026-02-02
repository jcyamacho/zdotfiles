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
| `cdx` | Run Codex with sensible defaults |
| `codex-clear-archived-sessions` | Remove archived Codex session directories |

## Notes

- Prefers Homebrew install over npm
- `cdx` enables web search, workspace-write sandbox, and approval on-request
- Uses cached init for shell completions
