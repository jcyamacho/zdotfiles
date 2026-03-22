# worktrunk

Git worktree management.

- <https://worktrunk.dev>

## Aliases

| Alias  | Command          |
| ------ | ---------------- |
| `wtl`  | `wt list`        |
| `wtm`  | `wt merge`       |
| `wts`  | `wt switch`      |
| `wtcm` | `wt step commit` |

## Functions

| Function               | Description                           |
| ---------------------- | ------------------------------------- |
| `install-worktrunk`    | Install worktrunk via Homebrew        |
| `uninstall-worktrunk`  | Remove worktrunk via Homebrew         |
| `wt-config`            | Edit the worktrunk config file        |
| `wt-commit-claude`     | Set Claude as the LLM commit provider |
| `wt-commit-codex`      | Set Codex as the LLM commit provider  |

## LLM Commit Providers

Worktrunk can generate commit messages using an LLM. Provider configs
are stored in `config/` and applied with `wt-commit-<provider>`.

Available providers:

- `claude` -- uses Claude Code with haiku model
- `codex` -- uses Codex with gpt-5.4-mini model

On install, the plugin auto-configures the first available provider
(claude, then codex).
