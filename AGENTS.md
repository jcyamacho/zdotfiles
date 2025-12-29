# AGENTS.md - Zsh Dotfiles Repository

## Overview

Modular zsh configuration using Antidote plugin manager. Entry point: `zshrc.sh`.

## Repo Layout

- `zshrc.sh` – entry point sourced by your `~/.zshrc`.
- `.zsh_plugins.txt` – source-of-truth plugin list for Antidote.
- `plugins/` – local plugins + `install-*`/`update-*`/`uninstall-*` helpers.
- `_utils.zsh` – shared helpers (`exists`, `reload`, caching, output).

## Commands

- `reload` – reload shell config after changes
- `update-zdotfiles` – pull repo updates and reload
- `update-antidote` – update Antidote and reload
- `update-all` – run all registered updaters and reload
- `clear-all-cached-init` – remove all cached tool init files (regenerate on next reload)
- `zsh-startup-bench` – benchmark startup (10 iterations)
- `zsh-startup-profile` – profile startup with zprof
- Manual sanity check: `zsh -lic exit`

## Code Style

### Formatting

- **Indentation**: 2 spaces, LF line endings, UTF-8 (see `.editorconfig`)
- **Blank lines**: Single blank lines for separation; no multiple consecutive blank lines
- **Header**: Start each plugin with `# <tool> (<short description>): https://...` (description optional, but keep it short)

### Security (Critical)

- **Quote variables**: Quote scalars to prevent word splitting and globbing: `"$var"`, `"${var}"`. For arrays, follow the **Array expansions** rule below
- **Prefer arrays for command arguments**: Avoid constructing commands as strings; use arrays and invoke with `"${cmd[@]}"` to preserve argument boundaries
- **No eval on untrusted input**: Never use `eval` on strings derived from user input/environment. For tool init code, prefer `source-cached-init` over repeated `eval`
- **Avoid prompt expansion on untrusted text**: Don't use `print -P` with untrusted content; with `setopt promptsubst` it can execute `$()`/backticks. Prefer `builtin print -r -- "$text"` or disable prompt substitution locally with `setopt local_options nopromptsubst`
- **No sudo**: Avoid `sudo` in plugin functions; keep installs/updates non-interactive (principle of least privilege)
- **Non-interactive installers**: All install/update flows must be non-interactive (use `--yes`/`-y`/equivalent flags). Never `curl | sh`; use `_run_remote_installer "<url>" ["sh"|"bash"] [--env "KEY=VALUE"] -- [args...]`. It downloads to `mktemp`, runs under `_lock_zshrc`/`_unlock_zshrc`, and preserves env via `--env`.
- **Secure temp files**: Use `mktemp` for temporary files, not predictable paths
- **Secrets handling**: Never log, cache, or store sensitive data (API keys, tokens) in world-readable files
- **Escape % in prompts**: When placing untrusted content into prompts, replace `%` with `%%` to prevent prompt escapes from expanding

### Correctness

- **Conditionals**: Use `[[ ]]` over `[ ]` (zsh-native, supports pattern matching, safer with unquoted vars)
- **Command substitution quoting**: Always quote: `local var="$(cmd)"` not `local var=$(cmd)`
- **Array expansions**: Quote scalars as `"$var"`. When passing arrays, use `"${array[@]}"` (or `"${(@)array}"`) to preserve elements and whitespace
- **Local variables**: Declare function-local variables with `local` to avoid polluting global scope
- **Required params**: Use `${1:?error message}` syntax for mandatory parameters
- **Safe line iteration**: Use `while IFS= read -r var` to preserve whitespace and handle backslashes
- **Glob qualifiers**: Use `(N)` for null-glob to avoid errors on no matches: `for f in dir/*(N); do`
- **Read-only constants**: Use `typeset -r` for function-local constants. Use `typeset -gr` for globals (especially in deferred plugins) to avoid accidental local scoping. Guard global read-only variables with `(( $+_var_name )) ||` to prevent errors on `reload`: `(( $+_my_var )) || typeset -gr _my_var="value"`
- **Ignore failure**: Use `|| :` to suppress a command's exit status when failure is acceptable (e.g., `command rm -f file || :`). The `:` is the null builtin that always succeeds

### Performance

- **Bypass aliases**: Prefix external commands with `command` and builtins with `builtin` to ensure predictable behavior: `command mkdir`, `builtin print`
- **Avoid subshells**: Prefer `$PWD` over `$(pwd)`, `${var:h}` over `$(dirname "$var")`, `${var:t}` over `$(basename "$var")`
- **Here-strings over pipes**: Prefer `cmd <<< "$var"` over `builtin print -r -- "$var" | cmd` (avoids subshell)
- **Cache tool init**: Use `source-cached-init <cmd> [args...]` for tools that emit shell init code; it auto-regenerates when the tool binary is newer
- **Antidote conditionals**: Prefer `conditional:"exists tool"` for consistency (fast `$+commands[...]` lookup via `exists()`)
- **Minimize command checks**: Avoid repeated `exists <cmd>` within the same file; structure as `if exists foo; then ... elif exists brew; then ... fi`
- **Skip prompt init in dumb terminals**: Guard prompt tooling like Starship with `[[ $TERM != dumb ]]` to avoid errors in non-interactive contexts
- **Compile generated plugin list**: When generating `.zsh_plugins.zsh`, also `zcompile` it to speed startup. Note: source the `.zsh` file; zsh will prefer the `.zwc` when present and newer.
- **Lazy loading**: Defer initialization of tools not needed at every shell start
- **Native operations**: Prefer zsh parameter expansion over external commands:
  - `${array[(r)pattern]}` instead of `grep`
  - `${var//old/new}` instead of `sed`
  - `${(s:,:)var}` instead of `cut` or `awk`

### Output

- **Print statements**: Use `builtin print -r --` instead of `echo` (no escape interpretation, predictable)
- **Colored output**: Use `info`, `warn`, `error` helpers from `_utils.zsh`
- **Output suppression**: Use `> /dev/null` for noisy commands during install/update

### Naming Conventions

- **Functions/aliases**: lowercase with hyphens (e.g., `install-tool`, `update-all`)
- **Environment variables**: UPPERCASE with underscores (e.g., `TOOL_CONFIG_DIR`)
- **Private functions**: Prefix with underscore (e.g., `_update_tool`, `_helper_func`)
- **Public API**: `install-<tool>`, `uninstall-<tool>`, `update-<tool>`
- **Config helpers**: `<tool>-config` for editing tool configuration

### File Operations

- **Removals**: Use `command rm -f -- "$path"` (quote path, use `--` to handle names starting with `-`)
- **Directory creation**: Use `command mkdir -p -- "$dir"`
- **Path safety**: Always quote paths, especially those from variables or command substitution

## Project Conventions

These are specific patterns used in this repository:

- **Guard pattern**: Use `exists <cmd>` before tool-specific code; early `return` if missing
- **Startup installs**: Only bootstrap essentials (Antidote, Homebrew, Starship); these are one-time installs on first load, then not run again. Other tools use `install-<tool>`
- **Updates array**: Register an updater in `updates` for `update-all` (prefer `_update_<tool>` that does not call `reload`)
- **Cache invalidation**: Call `clear-cached-init <cmd>` after installs/updates; use `clear-all-cached-init` to reset all init caches
- **Structure**: Simple tools = single `.zsh` file; complex tools = subdirectory with `.plugin.zsh`
- **Early returns**: Structure as guard → early return → main code (not nested if/else)
- **Lock zshrc**: Use `_lock_zshrc` / `_unlock_zshrc` when external installers might modify `.zshrc`
- **Path prepend**: Use `path=("$NEW_DIR" "${path[@]}")` pattern; `typeset -gU path` handles deduplication
- **Friendly aliases**: Provide alternatives like `alias install-node="install-fnm"`
- **Config exports**: Export `<TOOL>_CONFIG_DIR`, `<TOOL>_CONFIG_FILE` for tools with config
- **Editor helper**: Use `edit` helper instead of `$EDITOR` directly
- **Loop variables**: Use `_` for intentionally ignored variables: `for _ in {1..10}`
- **Unset temporary vars**: Clean up with `unset varname` when no longer needed
- **Function existence**: Use `(( $+functions[name] ))` to check before calling
- **Telemetry opt-out**: Disable analytics/telemetry where tools support it

### Update Functions

Not all tools need a dedicated `update-<tool>` function:

- **Brew-installed tools**: Updated automatically via `update-brew` (runs `brew upgrade --greedy`). No individual updater needed unless the tool has additional update steps (e.g., clearing cached init, downloading themes).
- **Self-updating tools**: Tools with their own update mechanism (e.g., `rustup update`, `bun upgrade`, `mise self-update`) should register an updater in `updates`.
- **Tools with cached init**: If a tool uses `source-cached-init`, its updater must call `clear-cached-init <tool>` after updating to regenerate the cache.

### Pure Utility Plugins

While most plugins wrap external tools and require lifecycle functions, some plugins are **pure utilities** (e.g., `git-worktree.zsh`). For these:

- Lifecycle functions (`install-`, `uninstall-`, `update-`) are optional.
- They do not need to be listed in the `README.md` "Installable Tools" section if they don't require an explicit installation step.
- They should still follow all other conventions (headers, guards, performance, etc.).

## Adding a New Plugin

1. Create `plugins/<tool>.zsh` (or `plugins/<tool>/<tool>.plugin.zsh` for complex tools)
2. Add it to `.zsh_plugins.txt` (use `conditional:"exists <tool>"` when appropriate)
3. Add header comment with tool name and URL
4. Guard with `exists <tool> || return` (or check for package manager first)
5. Provide `install-<tool>` and `uninstall-<tool>` functions
6. If updatable, add an updater and register it in `updates` for `update-all` support
7. For tools with init code, use `source-cached-init` and call `clear-cached-init` on update
8. Update `README.md` to include the new tool in the **Installable Tools** list (with a link), so the README stays a complete reference of what this repo contains.

## Debugging

- **Profile startup**: `ZDOTFILES_PROFILE_STARTUP=1 zsh -lic exit` or use `zsh-startup-profile`
- **Trace execution**: `set -x` / `set +x` around problematic code
- **Check variables**: `typeset -p varname` to inspect variable state
- **Syntax check**: Use `zsh -n <file>` for quick validation

## References

- [Zsh Native Scripting Handbook](https://wiki.zshell.dev/community/zsh_handbook)
- [Oh My Zsh Secure Code Guidelines](https://github.com/ohmyzsh/ohmyzsh/wiki/Secure-Code)
- [Zsh Best Practices Gist](https://gist.github.com/ChristopherA/562c2e62d01cf60458c5fa87df046fbd)
