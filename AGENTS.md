# AGENTS.md - Zsh Dotfiles Repository

## Overview

Modular zsh configuration using Antidote plugin manager. Entry point: `zshrc.sh`.

## Commands

- `reload` - Reload shell config after changes
- `zsh-startup-bench` - Benchmark startup (10 iterations)
- No automated tests exist; manually test with `zsh -lic exit`

## Code Style

- **Indentation**: 2 spaces, LF line endings, UTF-8 (see `.editorconfig`)
- **Header**: Start each plugin with `# TOOL_NAME: https://...`
- **Guard pattern**: Use `exists <cmd>` before tool-specific code; early `return` if missing
- **Naming**: `install-<tool>`, `uninstall-<tool>`, `update-<tool>` (public), `_update_<tool>` (private)
- **Functions/aliases**: lowercase with hyphens; env vars: UPPERCASE
- **Builtins**: Prefix with `command` or `builtin` to bypass aliases (e.g., `command mkdir -p`)
- **Required params**: Use `${1:?error message}` syntax
- **Output**: Use `info`, `warn`, `error` helpers from `_utils.zsh`
- **Structure**: Simple tools = single `.zsh` file; complex tools = subdirectory with `.plugin.zsh`

## Adding a New Plugin

1. Create `plugins/<tool>.zsh` (or `plugins/<tool>/<tool>.plugin.zsh` for complex tools)
2. Add header comment with tool name and URL
3. Guard with `exists <tool> || return`
4. Provide `install-<tool>` and `uninstall-<tool>` functions
5. Register `_update_<tool>` in `updates` array for `update-all` support
