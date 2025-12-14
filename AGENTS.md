# AGENTS.md - Zsh Dotfiles Repository

## Overview

Modular zsh configuration using Antidote plugin manager. Entry point: `zshrc.sh`.

## Commands

- `reload` - Reload shell config after changes
- `zsh-startup-bench` - Benchmark startup (10 iterations)
- No automated tests exist; manually test with `zsh -lic exit`

## Code Style

- **Indentation**: 2 spaces, LF line endings, UTF-8 (see `.editorconfig`)
- **Header**: Start each plugin with `# <tool> (<short description>): https://...` (description optional, but if present keep it)
- **Guard pattern**: Use `exists <cmd>` before tool-specific code; early `return` if missing
- **Startup installs**: Auto-installing missing tools during shell startup is acceptable only for bootstrapping defaults (currently Antidote in `zshrc.sh`, Homebrew in `plugins/brew.zsh`, and Starship in `plugins/starship/starship.plugin.zsh`); avoid adding startup installs for other tools—prefer `install-<tool>` instead
- **Naming**: `install-<tool>`, `uninstall-<tool>`, `update-<tool>` (public), `_update_<tool>` (private)
- **Functions/aliases**: lowercase with hyphens; env vars: UPPERCASE
- **Builtins**: Prefix with `command` or `builtin` to bypass aliases (e.g., `command mkdir -p`)
- **No `eval`**: Avoid `eval` in plugins; if a tool outputs init shell code, use `source-cached-init` instead (note: `_utils.zsh` may use `eval` only as a last-resort fallback when no cache exists)
- **Paths**: Prefer `$PWD` over `$(pwd)` to avoid subshells
- **Removals**: Use `command rm -f -- "$path"` / `command rm -rf -- "$path"` and quote variables
- **No `sudo`**: Avoid `sudo` in plugin functions; keep installs/updates non-interactive
- **Editor**: Prefer the `edit` helper over invoking `$EDITOR` directly
- **Required params**: Use `${1:?error message}` syntax
- **Output**: Use `info`, `warn`, `error` helpers from `_utils.zsh`
- **Caching init**: Prefer `source-cached-init <cmd> [args...]` for tools that emit shell init code (uses `$ZDOTFILES_CACHE_DIR/<cmd>/init.zsh` and falls back to sourcing an existing cache or `eval` when needed)
- **Updates array**: Add callables to `updates` that are safe to run from `update-all` (quoted invocation), and prefer clearing cached init when updating tools that generate init code
- **Cache invalidation**: Prefer `clear-cached-init <cmd>` after installs/updates so next shell regen is clean
- **Structure**: Simple tools = single `.zsh` file; complex tools = subdirectory with `.plugin.zsh`
- **Conditionals**: Prefer `[[ ]]` over `[ ]` for tests (zsh-native, supports pattern matching, safer with unquoted vars)
- **Local variables**: Declare function-local variables with `local` to avoid polluting global scope
- **Subshell avoidance**: Prefer `<<< "$var"` (here-string) over `echo "$var" |` when piping to a single command
- **Blank lines**: Use single blank lines for separation; avoid multiple consecutive blank lines
- **Config functions**: Name config-editing helpers as `<tool>-config` (hyphenated) for consistency
- **Print statements**: Use `builtin print -r` instead of `echo` for reliable output (no escape interpretation)
- **Command substitution quoting**: Always quote command substitutions in assignments and tests: `local var="$(cmd)"`
- **Loop variables**: Use `_` for intentionally ignored loop variables (e.g., `for _ in {1..10}`)
- **Early returns**: Structure conditionally loaded plugins as guard → early return → main code (not nested if/else)
- **Whitespace**: No leading whitespace before `command`/`builtin` prefixes; keep indentation consistent

## Adding a New Plugin

1. Create `plugins/<tool>.zsh` (or `plugins/<tool>/<tool>.plugin.zsh` for complex tools)
2. Add header comment with tool name and URL
3. Guard with `exists <tool> || return`
4. Provide `install-<tool>` and `uninstall-<tool>` functions
5. Register `_update_<tool>` in `updates` array for `update-all` support
