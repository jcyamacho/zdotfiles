# worktrunk

Sets up [Worktrunk](https://worktrunk.dev), a Git worktree manager run as `wt`:
shell integration, short aliases, and LLM commit message configs for
[Claude Code](https://www.anthropic.com/claude-code),
[Codex](https://developers.openai.com/codex/cli), and
[Cursor Agent](https://cursor.com/docs/cli/using).

## Commands

| Command | Description |
| --- | --- |
| `install-worktrunk` | Install Worktrunk with Homebrew and, if you have no config yet, apply a commit provider when Claude Code, Codex, or the Cursor Agent CLI is installed |
| `uninstall-worktrunk` | Uninstall Worktrunk with Homebrew, keeping the config file |
| `wt-config` | Open the Worktrunk config file in `$EDITOR`, creating its directory if needed |
| `wt-commit-claude` | Replace the Worktrunk config file with the Claude provider config |
| `wt-commit-codex` | Replace the Worktrunk config file with the Codex provider config |
| `wt-commit-cursor` | Replace the Worktrunk config file with the Cursor provider config |

`install-worktrunk` exists only while `wt` is missing. The other commands and
the aliases exist only while `wt` is installed.

## Aliases

| Alias | Expands to |
| --- | --- |
| `wtl` | `wt list` |
| `wtm` | `wt merge` |
| `wts` | `wt switch` |
| `wtcm` | `wt step commit` |
| `wtcms` | `wt step commit --stage=none` |

According to `wt step commit --help`, the command stages all changes and
commits them with a generated message. With `--stage=none`, it stages nothing,
so `wtcms` commits only what is already staged.

## Configuration Paths

| Purpose | Path |
| --- | --- |
| Worktrunk user config | `~/.config/worktrunk/config.toml` |
| Commit provider commands and shared settings | [`config/`](config) |

## Shell Integration

When `wt` is installed, the plugin sources the output of
`wt config shell init zsh`. That code wraps `wt` in a shell function so
commands such as `wt switch` can change the current directory, and it
registers tab completion. You don't need to run `wt config shell install`.

## Commit Message Providers

Each provider file in [`config/`](config) holds only the
`[commit.generation]` command that generates commit messages with an LLM:

- [`claude.toml`](config/claude.toml): runs `claude -p` with the `haiku` model,
  thinking turned off, and no tools, slash commands, settings files, system
  prompt, or saved session
- [`codex.toml`](config/codex.toml): runs `codex exec` with the `gpt-6-luna`
  model, low reasoning effort, and a read-only sandbox, without saving a
  session, then extracts the reply with `jq`, which must be installed
- [`cursor.toml`](config/cursor.toml): runs `cursor-agent -p` with the
  `composer-2.5-fast` model, text output, and Ask mode, and passes `--trust`
  so a headless run does not stop on the workspace prompt. The CLI saves that
  trust, so every repo you commit in stays trusted. Ask mode blocks edits. The
  CLI can still search the repo, and it has no flag to skip saving the
  session.

[`shared.toml`](config/shared.toml) holds the settings that every provider
uses. Its prompts ask for a Conventional Commits 1.0.0 message with one of the
types `feat`, `fix`, `refactor`, `docs`, `chore`, `test`, `ci`, or `build`, and
a lowercase, imperative summary under 50 characters, not counting type and
scope. A separate squash prompt combines several commits into one message. The
file also sets `[list] summary = true`, which turns on LLM branch summaries in
`wt list --full`.

`wt-commit-claude`, `wt-commit-codex`, and `wt-commit-cursor` write the
provider file followed by `shared.toml` to `~/.config/worktrunk/config.toml`.
This replaces the whole file, so any other settings in it are lost. To keep
extra settings across switches, add them to `shared.toml`. Its first keys
continue the provider's `[commit.generation]` table, so put other tables after
them.

When no config file exists, `install-worktrunk` applies the Claude provider if
`claude` is on the path, otherwise the Codex provider if `codex` is, otherwise
the Cursor provider if `cursor-agent` is. An existing config file is left
alone, so a reinstall keeps your settings.
