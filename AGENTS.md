# AGENTS.md - Zsh Dotfiles Repository

Repo defaults for AI agents editing this zsh dotfiles project.
Prioritize secure, fast startup and minimal diffs.

## Architecture

`zshrc.sh` is sourced by `~/.zshrc` and bootstraps in order:

1. Cache dir (`$ZDOTFILES_CACHE_DIR`) and `$CUSTOM_TOOLS_DIR` on `$path`
2. `_utils.zsh` — shared helpers (see below)
3. The `updates` array and `update-all` dispatcher
4. Antidote — reads `.zsh_plugins.txt`, generates/compiles
   `.zsh_plugins.zsh`, sources it

Antidote sources entries in `.zsh_plugins.txt` in order. Each local plugin
runs its own guard logic and conditionally defines
`install-*`/`uninstall-*`/`update-*` functions.

### Antidote annotations

Entries in `.zsh_plugins.txt` support these annotations:

- `kind:defer` — defers sourcing until after prompt. Use for plugins
  that only define functions/aliases. **Do not** defer plugins that
  modify `$path`, register hooks (`add-zsh-hook`), or call
  `source-cached-init` (their side effects must happen at load time).
- `conditional:"exists <cmd>"` — loads only when `<cmd>` is present.
  Used on OMZ companion plugins.
- `path:plugins/<name>` — loads a sub-path from a remote repo (used
  for OMZ plugins).

### Load order rules

Order in `.zsh_plugins.txt` matters:

1. UX plugins first (autosuggestions, syntax highlighting) to avoid
   visual flash on startup.
2. Local plugin before its OMZ companion so the companion sees the
   tool on `$path`.
3. Dev-tool managers (e.g. mise) last — their activate hooks override
   other plugins' shims and paths.

### Key helpers (`_utils.zsh`)

- `exists <cmd>` — cached `$+commands` check (cleared on `reload`)
- `source-cached-init <cmd> <args...>` — caches tool init output
  and sources it; regenerates when binary is newer
- `_run_remote_installer <url> [shell] [--env K=V]... [-- args...]` —
  secure download-and-run with `~/.zshrc` write-lock
- `clear-cached-init <cmd>` / `clear-all-cached-init` — invalidate
  cached init files
- `info`, `warn`, `error` — colored output helpers
- `reload` — clear `exists` cache and re-source `zshrc.sh`

## Core Rules

- 2-space indentation, LF endings, UTF-8, single blank lines.
- Keep implementations minimal: avoid extra logic/state unless it delivers
  clear, lasting user value.
- Start plugin files with `# <tool> (<short description>): https://...`.
- Quote scalars (`"$var"`); pass arrays as `"${array[@]}"`.
- Use `[[ ... ]]`, `local`, `${1:?message}`, and `while IFS= read -r line`.
- Declare locals as close as possible to first use (prefer inline declaration
  with assignment). Declare at function top only when reused across most of
  the function.
- Use `builtin print -r --` instead of `echo`; prefix external calls
  with `command`/`builtin` to bypass aliases.
- Prefer zsh native expansion over subshells/pipes for simple transforms.
- Use `command mkdir -p -- "$dir"` and `command rm -f -- "$path"`.
- Never use `sudo`, interactive installers, or `curl | sh`.
- Never `eval` untrusted input; prefer `source-cached-init` for tool init.
- Use `mktemp` for temp files; never log or cache secrets.
- Escape `%` in untrusted prompt text as `%%`.

## Plugin Patterns

### Guards

- Check tool first, then package manager for lifecycle functions.
- Use early return (`exists <pkg_mgr> || return`) only when the
  entire file depends on that package manager.
- When a tool registers shell hooks (e.g. via `source-cached-init`),
  define empty stub functions in the else-branch so other plugins
  calling those hooks don't error.

### Lifecycle

- Register `_update_<tool>` in `updates`; expose `update-<tool>`
  wrapper that calls updater then `reload`.
- Brew-managed tools are updated by `update-brew` unless they
  need extra post-update steps.
- Self-managed tools (e.g. `rustup`, `bun`, `mise`) need explicit
  updater functions.
- Run `clear-cached-init <tool>` after install/update of tools
  using shell init.
- Bootstrap only essentials at startup (Antidote, Homebrew, Starship);
  everything else installs via `install-<tool>`.
- Utility-only plugins may omit lifecycle functions.
- List installable tools in root `README.md`; list utility
  plugins in the Utility Plugins section.
- Brew-managed plugin skeleton:

```zsh
exists brew || return

if exists tool; then
  uninstall-tool() {
    info "Uninstalling tool..."
    command brew uninstall tool
    reload
  }
else
  install-tool() {
    info "Installing tool..."
    command brew install tool
    reload
  }
fi
```

- Brew-optional plugin skeleton (tool works without brew, brew
  used only for lifecycle):

```zsh
if exists tool; then
  # tool config, aliases, functions here

  if exists brew; then
    uninstall-tool() {
      info "Uninstalling tool..."
      command brew uninstall tool
      reload
    }
  fi
elif exists brew; then
  install-tool() {
    info "Installing tool..."
    command brew install tool
    reload
  }
fi
```

- Self-managed plugin skeleton:

```zsh
if exists tool; then
  source-cached-init tool init zsh   # omit if tool has no shell init

  uninstall-tool() {
    info "Uninstalling tool..."
    command rm -f -- "$CUSTOM_TOOLS_DIR/tool"
    clear-cached-init tool
    reload
  }

  _update_tool() {
    info "Updating tool..."
    command tool self-update           # use tool's own upgrade command
    clear-cached-init tool
  }

  update-tool() { _update_tool; reload }
  updates+=(_update_tool)
else
  install-tool() {
    info "Installing tool..."
    _run_remote_installer "https://..." "sh" -- --bin-dir "$CUSTOM_TOOLS_DIR"
    reload
  }
fi
```

### General

- Prefer `path=("$NEW_DIR" "${path[@]}")` with `typeset -gU path`
  for deduped prepends.
- Disable tool telemetry when supported.
- For constants that must survive `reload`, use the readonly guard
  pattern: `(( $+_var )) || typeset -gr _var="value"`. The `$+`
  check prevents reassignment errors on the readonly variable.

### File layout

- **Simple** (`plugins/<tool>.zsh`): single file, brew guard,
  conditional install/uninstall.
- **Self-managed** (`plugins/<tool>.zsh`): binary in
  `$CUSTOM_TOOLS_DIR`, uses `source-cached-init`, registers in
  `updates`.
- **Complex** (`plugins/<tool>/<tool>.plugin.zsh` + `README.md`):
  subdirectory for plugins with configs or detailed docs.

## Adding a Plugin (Checklist)

1. Create plugin file (simple or subdirectory layout).
2. Add entry to `.zsh_plugins.txt` (use `conditional:"exists <tool>"` where useful).
3. Add file header with tool name and URL.
4. Add guard logic.
5. Add `install-<tool>` and `uninstall-<tool>` when lifecycle management is needed.
6. Register updater when the tool has an independent update path.
7. Add `clear-cached-init` call if the tool emits shell init code.
8. Update `README.md` with the tool listing.

## Validation

```sh
zsh -n <file>              # syntax check edited files
zsh -lic exit              # full startup sanity
zsh-startup-bench          # 10-iteration startup benchmark
zsh-startup-profile        # zprof-enabled timing run
```

## References

- <https://wiki.zshell.dev/community/zsh_handbook>
- <https://github.com/ohmyzsh/ohmyzsh/wiki/Secure-Code>
- <https://gist.github.com/ChristopherA/562c2e62d01cf60458c5fa87df046fbd>
