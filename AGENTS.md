# AGENTS.md - Zsh Dotfiles Repository

Repo defaults for AI agents editing this zsh dotfiles project.
Prioritize secure, fast startup and minimal diffs.

## Architecture

`zshrc.sh` is sourced by `~/.zshrc` and bootstraps in order:

1. Cache dir (`$ZDOTFILES_CACHE_DIR`), private completions dir on
   `$fpath`, and `$CUSTOM_TOOLS_DIR`
   on `$path`
2. `_utils.zsh` — shared helpers (see below)
3. The `updates` array and `update-all` dispatcher
4. `_brew.zsh` — Homebrew discovery, `$HOMEBREW_PREFIX`, its
   `site-functions` on `$fpath`, bootstrap install, and updater
5. `compinit` (see Completions below)
6. Antidote — reads `.zsh_plugins.txt`, generates/compiles
   `.zsh_plugins.zsh`, sources it

Root-level `_<name>.zsh` files are sourced directly by `zshrc.sh`, not
loaded as plugins. Use one when the code is not optional or has to run
before Antidote (e.g. it must reach `$fpath` before `compinit`). Anything
that can be conditional on a binary belongs in `plugins/` instead.

Antidote sources entries in `.zsh_plugins.txt` in order. Each local plugin
runs its own guard logic and conditionally defines
`install-*`/`uninstall-*`/`update-*` functions.

### Antidote annotations

Entries in `.zsh_plugins.txt` support these annotations:

- `conditional:"<expr>"` — wraps the entry in `if <expr>; then ... fi`
  in the generated `.zsh_plugins.zsh`. The expression is pasted
  verbatim as the `if` condition. Any valid shell expression works:
  - `conditional:"exists <cmd>"` — loads only when `<cmd>` is present.
  - `conditional:"[[ $VAR == value ]]"` — loads based on a variable.
- `path:plugins/<name>` — loads a sub-path from a remote repo.

### Load order rules

Order in `.zsh_plugins.txt` matters:

1. Tool, completion, history, and keybinding plugins load before UX
   plugins so later ZLE hooks wrap the final widget state.
2. Dev-tool managers (e.g. mise) load after tool plugins — their
   activate hooks override other plugins' shims and paths.
3. UX plugins (autosuggestions, syntax highlighting, you-should-use)
   load last.

### Completions

`zshrc.sh` owns `compinit` and runs it before Antidote sources the
plugins. Consequences to respect:

- Anything that must be on `$fpath` for `compinit` to see it belongs in
  a root-level `_<name>.zsh`, not in a plugin. A plugin's `fpath`
  addition is too late.
- `compdef` is available inside plugins, so tools with a dynamic
  completion function can register directly.
- Never call `compinit -C`. The `$fpath` rescan by directory mtime is
  what picks up completions written by `cache-completion` during plugin
  load, on the next shell.
- A completion generated for the first time appears one shell later.
  This self-heals because `install-<tool>` ends in `reload`.

### Key helpers (`_utils.zsh`)

- `exists <cmd>` - checks the current `$commands` entry for an executable
- `source-cached-init <cmd> <args...>` - caches tool init output
  and sources it; regenerates when binary is newer
  - Use only when output is deterministic/static across sessions.
  - Do not cache commands that emit per-session values (PID,
    timestamps, temp paths). Example: do not cache `fnm env --shell zsh`.
  - Do not use for `#compdef` completion scripts; use
    `cache-completion` instead.
- `cache-completion <cmd> <args...>` - caches `#compdef` completion
  output to `$ZDOTFILES_CACHE_DIR/completions/_<cmd>` and adds it to
  `fpath`; regenerates when binary is newer. Use instead of
  `source-cached-init` when the tool outputs a `#compdef` file
  (completion functions that use `_arguments`).
- `_run_remote_installer <url> [shell] [--env K=V]... [-- args...]` -
  secure download-and-run with `~/.zshrc` write-lock
- `info`, `warn`, `error` - colored output helpers
- `confirm <prompt> [yes|no]` - terminal-only yes/no prompt that accepts
  `y`/`yes`, `n`/`no`, or bare `Enter` for the default, and re-prompts on
  invalid input
- `reload` - re-sources `zshrc.sh`

## Core Rules

- 2-space indentation, LF endings, UTF-8, single blank lines.
- Keep implementations minimal: avoid extra logic/state unless it delivers
  clear, lasting user value.
- Start plugin files with `# <tool> (<short description>): https://...`.
- Quote scalars (`"$var"`); pass arrays as `"${array[@]}"`.
- Use `[[ ... ]]`, `local`, `${1:?message}`, and `while IFS= read -r line`.
- Give variables the smallest useful scope. Separate declaration from assignment
  when the command's exit status matters.
- Use `builtin print -r --` instead of `echo`; prefix external calls
  with `command`/`builtin` to bypass aliases.
- Prefer zsh native expansion over subshells/pipes for simple transforms.
- Use `command mkdir -p -- "$dir"` and `command rm -f -- "$path"`.
- Use `_utils.zsh`'s `confirm` helper for destructive yes/no prompts
  instead of hand-rolled `read` logic. Abort on decline with the
  canonical pattern `confirm "..." no || { info "Aborted"; return 0; }`.
- Never use `kind:defer` in `.zsh_plugins.txt`. Deferred plugins
  block input after the prompt appears, making the shell feel frozen
  (see <https://github.com/romkatv/zsh-defer/issues/13>).
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

Choose the ownership model first. The templates below define the canonical
guard and lifecycle structure.

| Pattern | Ownership |
| --- | --- |
| Brew-managed | The entire plugin depends on Homebrew |
| Brew-optional | The tool works independently; Homebrew owns lifecycle |
| Self-managed | The installer owns the binary and updater |

### Lifecycle

- Register `_update_<tool>` in `updates`; expose `update-<tool>`
  wrapper that calls updater then `reload`.
- If the update never needs `reload` under any circumstance (e.g.,
  pulling models, themes, or data), skip the split: define a single
  public function and register it directly in `updates`. Otherwise use
  the `_update_<tool>` plus `update-<tool>` split.
- Brew-managed tools are updated by `update-brew` unless they
  need extra post-update steps.
- Pass `--no-ask` to scripted `brew install` and `brew upgrade` calls.
  Do not export `HOMEBREW_NO_ASK`; manual commands keep Homebrew's
  confirmation behavior.
- Self-managed tools (e.g. `rustup`, `bun`, `mise`) need explicit
  updater functions.
- Bootstrap only essentials at startup (Antidote, Homebrew, Starship);
  everything else installs via `install-<tool>`.
- Utility-only plugins (only aliases or helper functions, no managed
  binary) may omit lifecycle functions.
- Prefer brew-managed when the formula has no heavy dependencies
  (check `brew info`). Fall back to self-managed (script install
  to `$CUSTOM_TOOLS_DIR`) when brew would pull extra runtimes
  (e.g. node, python).
- List installable tools in root `README.md`; list utility
  plugins in the Utility Plugins section.

### Canonical templates

Use these templates for branch structure and lifecycle ownership. Replace
placeholders and add only the configuration required by the tool.

#### Brew-managed

Use when the entire plugin depends on Homebrew.

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
    command brew install --no-ask tool
    reload
  }
fi
```

#### Brew-optional

Use when the tool works independently and Homebrew owns only installation and
removal.

```zsh
if exists tool; then
  # Tool configuration, aliases, and functions.

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
    command brew install --no-ask tool
    reload
  }
fi
```

#### Self-managed

Use when the tool's installer owns the binary and the tool has an independent
update path. Remove `source-cached-init` when the tool has no shell init.

```zsh
if exists tool; then
  source-cached-init tool init zsh

  uninstall-tool() {
    info "Uninstalling tool..."
    command rm -f -- "$CUSTOM_TOOLS_DIR/tool"
    reload
  }

  _update_tool() {
    info "Updating tool..."
    command tool self-update
  }

  update-tool() {
    _update_tool
    reload
  }

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

- Prepend to `PATH` with `path=("$NEW_DIR" "${path[@]}")`. `path` is
  already declared `typeset -gU` in `zshrc.sh`, so do not redeclare it
  per plugin; the global `-U` keeps prepends deduped across reloads.
- Disable tool telemetry when supported.
- Use `local` for function state.
- Use `typeset -g _name="value"` only when plugin functions need private
  state after the file is sourced. Reassigning it on `reload` is intentional.
- Use a normal global assignment for user configuration that the shell consumes.
- Use `export` only for environment variables consumed by external processes.
- Before removing or renaming an exported variable, verify the tool's current
  contract in its official documentation or source and inspect why the variable
  was introduced. Absence of local references is not evidence that child
  processes ignore it.
- Derive secondary paths from their owned base path at the point of use.

### File layout

- **Simple** (`plugins/<tool>.zsh`): single file, brew guard,
  conditional install/uninstall.
- **Self-managed** (`plugins/<tool>.zsh`): binary in
  `$CUSTOM_TOOLS_DIR`, uses `source-cached-init`, registers in
  `updates`.
- **Complex** (`plugins/<tool>/<tool>.plugin.zsh` + `README.md`):
  subdirectory for plugins with configs or detailed docs.

## Adding a Plugin (Checklist)

1. Choose the matching plugin pattern and file layout.
2. Add the entry at the correct position in `.zsh_plugins.txt`.
3. Add the standard header, guards, and required lifecycle functions.
4. Register an updater only when the tool has an independent update path.
5. Update the relevant tool or utility listing in `README.md`.

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
