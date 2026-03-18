# ZDOTFILES

Compact Zsh setup that wires in [Antidote](https://github.com/mattmc3/antidote) for plugins and [Starship](https://starship.rs) as the default prompt, with [Powerlevel10k](https://github.com/romkatv/powerlevel10k) as an option. Everything is driven by a single `zshrc.sh` so you can drop it into any machine quickly.

<p align="center">
  <img src="docs/avatar.webp" alt="ZDOTFILES avatar" width="220">
</p>

## Install

1. Clone the repo (defaults to `~/.zdotfiles`):

   ```sh
   git clone git@github.com:jcyamacho/zdotfiles.git "$HOME/.zdotfiles"
   ```

2. Source the main file from your `~/.zshrc`:

   ```sh
   source "${ZDOTFILES_DIR:-$HOME/.zdotfiles}/zshrc.sh"
   ```

## Customizing

- Keep the repo elsewhere by setting `ZDOTFILES_DIR` before sourcing.
- Change the editor used by helper commands by exporting `EDITOR`.
- Adjust where self-managed tools install by overriding `CUSTOM_TOOLS_DIR`.
- Switch prompt theme with `ZSH_PROMPT` (see below).
- Set `GIT_WORKTREE_BASE` to change where `gwt-new` creates worktrees (see [git-worktree](plugins/git-worktree/README.md)).

### Prompt theme (`ZSH_PROMPT`)

Set `ZSH_PROMPT` **before** sourcing `zshrc.sh` to choose the prompt:

| Value      | Theme                                                          |
| ---------- | -------------------------------------------------------------- |
| `starship` | [Starship](https://starship.rs) (default)                      |
| `p10k`     | [Powerlevel10k](https://github.com/romkatv/powerlevel10k)      |

```sh
# In ~/.zshrc, before the source line:
export ZSH_PROMPT=p10k
source "${ZDOTFILES_DIR:-$HOME/.zdotfiles}/zshrc.sh"
```

Starship is cross-shell but slower due to fork+exec on every prompt.
Powerlevel10k uses instant prompt for near-zero first-prompt lag and
async git status for fast command lag. See
[powerlevel10k](plugins/powerlevel10k/README.md) and
[starship](plugins/starship/README.md) for per-theme details.

### Disable alias suggestions (`ZSH_DISABLE_YOU_SHOULD_USE`)

By default, [zsh-you-should-use](https://github.com/MichaelAquilina/zsh-you-should-use) reminds you when you type a command that has an alias. To disable these suggestions:

```sh
# In ~/.zshrc, before the source line:
export ZSH_DISABLE_YOU_SHOULD_USE=1
source "${ZDOTFILES_DIR:-$HOME/.zdotfiles}/zshrc.sh"
```

## Plugins

Antidote reads `.zsh_plugins.txt` and builds a static `.zsh_plugins.zsh`. The default setup enables:

- **Always-on shell UX**: prompt theme (see above), `zsh-autosuggestions`, syntax highlighting (`F-Sy-H`), and “you-should-use”.
- **Oh My Zsh helpers + curated plugins**: pulls in OMZ core helpers plus plugins like `git` and `brew`.
- **Local plugin helpers**: small `plugins/*` scripts that add `install-*`, `update-*`, `uninstall-*`, and `*-config` helpers.

Many integrations are **conditional** (they only activate when the underlying binary exists) to keep startup fast and avoid errors.

## Installable Tools

These are the `install-*` helpers (run the command to install; integrations load on `reload`/next shell start). Tools are grouped by how useful they are for the default shell experience.

### Recommended (not installed by default)

- `install-fzf` – [fzf](https://junegunn.github.io/fzf/) fuzzy finder (enables `fzf-tab` if present)
- `install-zoxide` (or `install-z`) – [zoxide](https://github.com/ajeetdsouza/zoxide) smarter `cd`
- `install-atuin` – [Atuin](https://atuin.sh/) synced, searchable history
- `install-carapace` – [Carapace](https://carapace.sh/) completions
- `install-direnv` – [direnv](https://direnv.net/) + hook

### Optional

- `install-bat` – [bat](https://github.com/sharkdp/bat) `cat` clone
- `install-bun` – [Bun](https://bun.sh/) runtime
- `install-claude-code` – [Claude Code](https://www.anthropic.com/claude-code) CLI
- `install-code` – [VS Code](https://code.visualstudio.com/)
- `install-codex` – [OpenAI Codex CLI](https://developers.openai.com/codex/cli)
- `install-cmux` – [cmux](https://www.cmux.dev/) native macOS terminal for AI agents
- `install-cursor` – [Cursor](https://www.cursor.com/)
- `install-deno` – [Deno](https://deno.land/) runtime
- `install-docker` – [Docker](https://www.docker.com/) CLI
- `install-dotenvx` – [dotenvx](https://github.com/dotenvx/dotenvx) a secure dotenv
- `install-fabric` – [Fabric](https://github.com/danielmiessler/fabric)
- `install-flutter` – [Flutter](https://flutter.dev/) SDK
- `install-fnm` (or `install-node`) – [fnm](https://github.com/Schniz/fnm) + LTS activation
- `install-gemini` – [Gemini CLI](https://github.com/google/gemini-cli)
- `install-ghostty` – [Ghostty](https://ghostty.org/) terminal + config restore
- `install-wezterm` – [WezTerm](https://wezterm.org/) terminal + config restore
- `install-gh` – [GitHub CLI](https://github.com/cli/cli)
- `install-go` – [Go](https://golang.org/) + [golangci-lint](https://golangci-lint.run/)
- `install-jq` – [jq](https://jqlang.org/)
- `install-just` – [just](https://just.systems/) command runner
- `install-lsd` – [lsd](https://github.com/lsd-rs/lsd) + config/theme
- `install-mise` – [mise](https://mise.jdx.dev/)
- `install-ollama` – [Ollama](https://ollama.com/)
- `install-openspec` – [OpenSpec](https://openspec.dev/) workflow CLI ([openspec](plugins/openspec/README.md))
- `install-opencode` – [OpenCode](https://opencode.ai/)
- `install-rbenv` (or `install-ruby`) – [rbenv](https://github.com/rbenv/rbenv)
- `install-rust` – [rustup](https://rustup.rs/)
- `install-uv` (or `install-python`) – [uv](https://docs.astral.sh/uv/) + Python tooling ([python](plugins/python/README.md))
- `install-worktrunk` – [Worktrunk](https://worktrunk.dev) git worktree management
- `install-yazi` – [yazi](https://yazi-rs.github.io/) terminal file manager
- `install-zed` – [Zed](https://zed.dev/)
- `install-zsh-bench` – [zsh-bench](https://github.com/romkatv/zsh-bench) benchmark for interactive zsh
- `install-zellij` – [Zellij](https://zellij.dev/) terminal workspace ([zellij](plugins/zellij/README.md))
- `install-zig` – [Zig](https://ziglang.org/)
- `install-antigravity` – [Antigravity](https://antigravity.google/)
- `install-fonts` – [Homebrew](https://brew.sh/) font casks

## Utility Plugins

Additional helper functions (no external tool required):

- [git-utils](plugins/git-utils/README.md) – `git-pull`, `git-pull-all` with hook support
- [git-worktree](plugins/git-worktree/README.md) – `gwt-*` helpers for managing Git worktrees

## Utility Functions

Shell helpers from `_utils.zsh`:

- `mkcd <dir>` – create a directory and cd into it
- `edit <file>` – open a file in `$EDITOR` (defaults to vim)
- `home` – cd to `$HOME`
- `zsh-config` – edit `~/.zshrc` and reload
- `kill-port <port>` – kill the process listening on a given port
- `zdotfiles-cache-clean` – remove all zdotfiles caches and reload
- `cls` – alias for `clear`
- `rmf` – alias for `rm -rf`
- `cd..` – alias for `cd ..`

## Gist Sync

Sync files and directories to/from private GitHub Gists. See [github-cli](plugins/github-cli/README.md) for details on `save-file-to-gist`, `load-file-from-gist`, and related functions.

## Updating

- `reload` – reload the configuration.
- `update-zdotfiles` – pull the latest repo changes and reload.
- `update-antidote` – update Antidote and reload.
- `update-all` – run all registered updaters and reload.

### The `updates` Array

`update-all` iterates over the `updates` array and calls each registered function. Plugins register their updaters like this:

```zsh
_update_mytool() {
  info "Updating mytool..."
  # update logic here
}

updates+=(_update_mytool)
```

Use an internal `_update_*` function (no `reload`) so `update-all` can batch updates and reload once at the end. Tools installed via Homebrew don't need individual updaters since `update-brew` runs `brew upgrade --greedy`.

## Performance

- Benchmark before/after changes with `zsh-startup-bench`.
- Use `zsh-startup-profile` for a quick zprof-enabled timing run.
- Quick sanity check without launching an interactive shell: `zsh -lic exit`.
