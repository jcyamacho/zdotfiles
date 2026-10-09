# AGENTS.md

Prioritize a secure, fast shell startup and minimal diffs.

## Architecture

`zshrc.sh` is sourced by `~/.zshrc` and loads, in order:

1. The cache directory, the completions directory on `$fpath`, and
   `$CUSTOM_TOOLS_DIR` on `$path`
2. `_utils.zsh`: shared helpers
3. The `updates` array and `update-all`
4. `_brew.zsh`: Homebrew discovery, bootstrap install, `site-functions` on
   `$fpath`, and updater
5. `_starship.zsh`: prompt bootstrap, configuration, and updater
6. `compinit`
7. Antidote: builds `.zsh_plugins.zsh` from `.zsh_plugins.txt` and sources it

Put code in a root-level `_<name>.zsh` file only when it is not optional or
must run before Antidote, for example to reach `$fpath` before `compinit`.
Anything that depends on an optional binary belongs in `plugins/`.

Bootstrap only Antidote, Homebrew, and Starship at startup. Everything else
installs through `install-<tool>`.

### Plugin list

- Edit `.zsh_plugins.txt`, never the generated `.zsh_plugins.zsh`. The shell
  regenerates it when the list is newer.
- Keep this load order:
  1. Tool, completion, history, and keybinding plugins load before UX plugins,
     so later ZLE hooks wrap the final widget state.
  2. Dev-tool managers such as mise load after tool plugins, because their
     activation overrides other plugins' shims and paths.
  3. UX plugins (autosuggestions, syntax highlighting, you-should-use) load
     last.
- To load a remote plugin only when a condition holds, use
  `conditional:"<expr>"`, for example `conditional:"exists fzf"`. Antidote
  pastes the expression verbatim as an `if` condition.
- Never use `kind:defer`. Deferred plugins block input after the prompt
  appears, so the shell feels frozen
  (see <https://github.com/romkatv/zsh-defer/issues/13>).

### Completions

`zshrc.sh` runs `compinit` before Antidote sources the plugins, so:

- A plugin's `$fpath` addition is too late for `compinit`. Put anything
  `compinit` must see in a root-level `_<name>.zsh`.
- Plugins can call `compdef` to register dynamic completion functions.
- Never call `compinit -C`. Without it, `compinit` rescans `$fpath` by
  directory mtime, which is how the next shell picks up completions that
  `cache-completion` wrote during plugin load.
- A completion generated for the first time appears in the next shell or
  `reload`, because `compinit` already ran when the plugin wrote it. Do not
  work around it.

### Key helpers (`_utils.zsh`)

- `exists <cmd>`: checks `$path` for an executable, ignoring aliases and
  functions. Use it instead of `$commands[cmd]`, which rehashes every `$path`
  directory after a path change.
- `source-cached-init <cmd> <args...>`: caches a tool's shell init output and
  sources it. It regenerates the cache when the binary or the calling plugin
  file is newer, so argument changes apply on the next load. Use it only for
  output that is identical in every session; for example, `mise activate zsh`
  includes the current `PATH`, so it is not cached. For `#compdef` output, use
  `cache-completion`.
- `cache-completion <cmd> <args...>`: writes a tool's `#compdef` completion to
  `$ZDOTFILES_CACHE_DIR/completions/_<cmd>`, a directory already on `$fpath`.
  It regenerates like `source-cached-init`.
- `_run_remote_installer <url> [shell [--env K=V]... [-- args...]]`: downloads
  the script over HTTPS to a temp file and runs it with `shell` (default `sh`)
  while `~/.zshrc` is locked. Pass the shell explicitly whenever `--env` or
  `--` follows, because the second argument is always read as the shell.
- `_run_with_zshrc_locked <cmd> [args...]`: locks `~/.zshrc` while an updater
  known to write it runs, then unlocks it, even when the command fails.
- `confirm <prompt> [yes|no]`: terminal-only yes/no prompt. It accepts `y`,
  `yes`, `n`, `no`, or Enter for the default, and re-prompts on invalid input.
- `edit` and `edit-open`: open a file in `$EDITOR`. Use `edit-open` in
  `*-config` helpers so the shell does not wait. Use `edit` only when the next
  step needs the saved file, as `starship-config` does before `reload`.
- `info`, `warn`, `error`: colored output.
- `reload`: replaces the shell with `exec zsh`, which loads `~/.zshrc` from a
  clean state. Only exported variables carry over. Lifecycle functions end with
  it, and code after it never runs. It returns 0 without restarting in scripts,
  `zsh -c`, and subshells, and while `_zdotfiles_reload_deferred` is set, and
  returns 1 while jobs are running or stopped. A function that calls several
  lifecycle functions runs its loop in an anonymous function that sets
  `local _zdotfiles_reload_deferred=1`, then reports failures and calls
  `reload` once, as `install-recommended` does. Do not `unset` the variable
  instead, because an unset local hides a caller's deferral.

## Core rules

- Follow `.editorconfig` and keep single blank lines.
- Keep implementations minimal. Add logic or state only when it delivers
  clear, lasting user value.
- Start plugin files with `# <tool> (<short description>): https://...`.
- Quote scalars (`"$var"`) and pass arrays as `"${array[@]}"`.
- Use `[[ ... ]]`, `local`, `${1:?message}`, and
  `while IFS= read -r line`.
- Give variables the smallest useful scope. Separate declaration from
  assignment when the command's exit status matters.
- Use `builtin print -r --` instead of `echo`. Prefix external commands with
  `command` and builtins with `builtin` to bypass aliases, and pass `--` before
  path operands, as in `command rm -f -- "$path"`. Exception: macOS `chmod`
  rejects `--` and treats it as a file name.
- Prefer zsh expansion over subshells and pipes for simple transforms.
- Use `confirm` for destructive yes/no prompts instead of custom `read` logic.
  When the prompt guards the whole command, abort on decline with
  `confirm "..." no || { info "Aborted"; return 0; }`.
- Never use `sudo`, interactive installers, or `curl | sh`.
- Never `eval` untrusted input. Use `source-cached-init` for tool init.
- Use `mktemp` for temp files, and never log or cache secrets.
- Escape `%` as `%%` in untrusted text passed to prompt expansion, such as
  `print -P`.

## Plugin patterns

Choose the ownership model first:

| Pattern | Ownership | Use when |
| --- | --- | --- |
| Brew-managed | Homebrew owns install, removal, and updates | A formula or cask has no heavy dependencies (check `brew info`) |
| Self-managed | The tool's installer owns the binary and updates | Brew would pull extra runtimes such as node or python |

### Guards

- Guard on the tool itself. Homebrew is a required bootstrap dependency, so
  never guard on `exists brew`.
- Guard lifecycle functions on optional package managers such as `npm`. Use an
  early `exists npm || return` only when the whole file depends on it.
- When a tool registers shell hooks, for example through
  `source-cached-init`, define empty stubs in the else branch so plugins that
  call those hooks do not fail.

### Lifecycle

- Add an updater only when the tool has an independent update path: always for
  self-managed tools, and for brew-managed tools only when they need extra
  post-update steps. `update-brew` updates the rest.
- Implement an updater as `_update_<tool>`, registered in `updates`, plus a
  public `update-<tool>` that runs `_update_<tool> || return` and then
  `reload`. When an update never needs `reload` (models, themes, data), define
  one public function and register it directly in `updates`.
- Propagate the failure of the primary operation before `reload`, and of any
  step that later steps depend on, with `command ... || return`.
- Keep secondary cleanup and optional configuration best-effort unless their
  success is part of the command's contract.
- Uninstallers always remove the tool and its own caches (for example
  `~/.cache/<tool>`). They delete user data and configuration (history,
  sessions, credentials, API keys, config directories, workspaces such as
  `$GOPATH`) only inside `if confirm "Delete ... in <path>?" no; then ... fi`,
  so declining keeps them. Cached init and completion files in
  `$ZDOTFILES_CACHE_DIR` can stay; `zdotfiles-cache-clean` removes them.
- Installers copy bundled config only when the user has none, so a
  reinstall keeps the config an uninstall kept. Explicit `*-restore-config`
  and copy commands overwrite.
- Pass `--no-ask` to scripted `brew install` and `brew upgrade` calls. Do not
  export `HOMEBREW_NO_ASK`, so manual commands keep Homebrew's confirmation.
- Utility-only plugins (aliases or helper functions, no managed binary) may
  omit lifecycle functions.

### Canonical templates

Use these templates for branch structure and lifecycle ownership. Replace the
placeholders and add only the configuration the tool requires.

Brew-managed:

```zsh
if exists tool; then
  # Tool configuration, aliases, and functions.

  uninstall-tool() {
    info "Uninstalling tool..."
    command brew uninstall tool || return
    reload
  }
else
  install-tool() {
    info "Installing tool..."
    command brew install --no-ask tool || return
    reload
  }
fi
```

Self-managed (remove `source-cached-init` when the tool has no shell init):

```zsh
if exists tool; then
  source-cached-init tool init zsh

  uninstall-tool() {
    info "Uninstalling tool..."
    command rm -f -- "$CUSTOM_TOOLS_DIR/tool" || return
    reload
  }

  _update_tool() {
    info "Updating tool..."
    command tool self-update
  }

  update-tool() {
    _update_tool || return
    reload
  }

  updates+=(_update_tool)
else
  install-tool() {
    info "Installing tool..."
    _run_remote_installer "https://..." "sh" \
      -- --bin-dir "$CUSTOM_TOOLS_DIR" || return
    reload
  }
fi
```

### Variables and paths

- Prepend directories with `path=("$NEW_DIR" "${path[@]}")`. `zshrc.sh`
  already declares `path` with `typeset -gU`, so do not redeclare it; `-U`
  keeps prepends deduplicated across reloads. Append instead when the
  directory must not outrank existing entries, as `_brew.zsh` and
  `cursor.zsh` do.
- Disable tool telemetry when the tool supports it.
- For temporary variables used only while sourcing a file, use
  `typeset _name="value"` and `unset _name` after the last use.
- Use `typeset -g _name="value"` only when plugin functions need private state
  after the file is sourced. Reassigning it on `reload` is intentional.
- Use a plain global assignment for user configuration that the shell
  consumes, and `export` only for variables that external processes consume.
- Before removing or renaming an exported variable, check the tool's current
  contract in its official documentation or source, and find out why the
  variable was introduced. A missing local reference does not prove that
  child processes ignore it.
- Derive secondary paths from their owning base path at the point of use.

### File layout

- Use a single file, `plugins/<tool>.zsh`, by default.
- Use a subdirectory, `plugins/<tool>/` with `<tool>.plugin.zsh` and a
  `README.md`, when the plugin ships config files or needs detailed docs.

## Adding a plugin

1. Choose the ownership model and file layout.
2. Add the entry at the correct position in `.zsh_plugins.txt`.
3. Add the standard header, guards, and lifecycle functions.
4. Add an updater only where the lifecycle rules call for one.
5. List installable tools in the root `README.md`, and utility-only plugins in
   its Utility Plugins section.

## Validation

- Run `zsh -n <file>` on every edited shell file.
- After changing `zshrc.sh`, a root-level `_*.zsh`, `.zsh_plugins.txt`, or
  code that runs while a plugin loads, run `zsh -lic exit`. It must finish
  without errors or unexpected output.
- When a change can affect startup time, compare before and after with
  `zsh -ic zsh-startup-bench` (10 timed runs) and
  `zsh -ic zsh-startup-profile` (zprof).

## References

Style and security guides behind these rules:

- <https://wiki.zshell.dev/community/zsh_handbook>
- <https://github.com/ohmyzsh/ohmyzsh/wiki/Secure-Code>
- <https://gist.github.com/ChristopherA/562c2e62d01cf60458c5fa87df046fbd>
