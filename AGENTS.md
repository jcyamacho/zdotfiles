# AGENTS.md - Zsh Dotfiles Repository

Repo defaults for AI agents editing this zsh dotfiles project.
Prioritize secure, fast startup and minimal diffs.

## Entry Points

- `zshrc.sh` -> main entry sourced by `~/.zshrc`
- `.zsh_plugins.txt` -> source of truth for Antidote plugin list
- `plugins/` -> local plugins and `install-*`/`uninstall-*`/`update-*` functions
- `_utils.zsh` -> shared helpers (`exists`, `reload`, cache/output helpers)

## Core Rules

- Use 2-space indentation, LF endings, UTF-8, and single blank lines.
- Start plugin files with `# <tool> (<short description>): https://...`.
- Quote scalars (`"$var"`); pass arrays as `"${array[@]}"`.
- Use `[[ ... ]]`, `local`, `${1:?message}`, and `while IFS= read -r line`.
- Use `builtin print -r --` instead of `echo` and `command`/`builtin`
  to bypass aliases.
- Prefer zsh native expansion over subshells/pipes for simple transforms.
- Use `command mkdir -p -- "$dir"` and `command rm -f -- "$path"`.
- Never use `sudo`, interactive installers, or `curl | sh`.
- Never run `eval` on untrusted input; prefer `source-cached-init` for tool init.
- Use `mktemp` for temp files; do not log or cache secrets.
- Escape `%` in untrusted prompt text as `%%`.

## Plugin Patterns

- Default guard pattern: check tool first, then package manager for lifecycle functions.
- Use early return (`exists <pkg_mgr> || return`) only when the
  entire file depends on that package manager.
- Keep simple tools in `plugins/<tool>.zsh`; use
  `plugins/<tool>/<tool>.plugin.zsh` + `README.md` for complex
  or utility plugins.
- Register `_update_<tool>` in `updates`; expose `update-<tool>`
  wrapper that calls updater then `reload`.
- After install/update of tools using shell init, run `clear-cached-init <tool>`.
- Bootstrap only essentials at startup (Antidote, Homebrew, Starship);
  everything else installs via `install-<tool>`.
- Prefer `path=("$NEW_DIR" "${path[@]}")` with `typeset -gU path` for deduped prepends.
- Disable tool telemetry when supported.

## Update and Utility Conventions

- Brew-managed tools are updated by `update-brew` unless they
  require extra post-update steps.
- Self-managed tools (for example `rustup`, `bun`, `mise`)
  should register explicit updater functions.
- Utility-only plugins may omit lifecycle functions but must
  still follow security/performance rules.
- List installable tools in root `README.md`; list utility
  plugins in the Utility Plugins section.

## Adding a Plugin (Checklist)

1. Create plugin file (`plugins/<tool>.zsh` or subdirectory layout for complex plugins).
2. Add plugin to `.zsh_plugins.txt` (use `conditional:"exists <tool>"` where useful).
3. Add file header with tool name and URL.
4. Add guard logic following the guard pattern rules.
5. Add `install-<tool>` and `uninstall-<tool>` when lifecycle management is needed.
6. Add updater registration when the tool has an independent update path.
7. Add cache invalidation if the tool emits shell init code.
8. Update `README.md` with the appropriate tool listing.

## Validation Before Finish

- `zsh -n <file>` for syntax checks on edited files
- `zsh -lic exit` for functional startup sanity
- `zsh-startup-bench` or `zsh-startup-profile` when startup behavior changes

## References

- <https://wiki.zshell.dev/community/zsh_handbook>
- <https://github.com/ohmyzsh/ohmyzsh/wiki/Secure-Code>
- <https://gist.github.com/ChristopherA/562c2e62d01cf60458c5fa87df046fbd>
