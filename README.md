# ZDOTFILES

Compact Zsh setup that wires in [Antidote](https://github.com/mattmc3/antidote) for plugins and [Starship](https://starship.rs) for the prompt. Everything is driven by a single `zshrc.sh` so you can drop it into any machine quickly.

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
- Adjust where tools like Starship install by overriding `CUSTOM_TOOLS_DIR`.

## Plugins

Antidote reads `.zsh_plugins.txt` and builds a static `.zsh_plugins.zsh`. The default setup enables:

- **Always-on shell UX**: Starship prompt, `zsh-autosuggestions`, syntax highlighting (`F-Sy-H`), and “you-should-use”.
- **Oh My Zsh helpers + curated plugins**: pulls in OMZ core helpers plus plugins like `git` and `brew`.
- **Local plugin helpers**: small `plugins/*` scripts that add `install-*`, `update-*`, `uninstall-*`, and `*-config` helpers.

Many integrations are **conditional** (they only activate when the underlying binary exists) to keep startup fast and avoid errors.

## Installable Tools

These are the tool install helpers shipped in `plugins/` (run the command to install; once installed the integration auto-wires on next shell start):

- `install-atuin` – [Atuin](https://atuin.sh/) history
- `install-bun` – [Bun](https://bun.sh/) runtime
- `install-carapace` – [Carapace](https://carapace.sh/) completions
- `install-claude-code` – [Claude Code](https://www.anthropic.com/claude-code) CLI
- `install-code` – [VS Code](https://code.visualstudio.com/)
- `install-codex` – [OpenAI Codex CLI](https://developers.openai.com/codex/cli)
- `install-cursor` – [Cursor](https://www.cursor.com/)
- `install-deno` – [Deno](https://deno.land/) runtime
- `install-direnv` – [direnv](https://direnv.net/) + hook
- `install-docker` – [Docker](https://www.docker.com/) CLI
- `install-fabric-ai` – [Fabric](https://github.com/danielmiessler/fabric)
- `install-flutter` – [Flutter](https://flutter.dev/) SDK
- `install-fnm` (or `install-node`) – [fnm](https://github.com/Schniz/fnm) + LTS activation
- `install-fzf` – [fzf](https://junegunn.github.io/fzf/) (enables `fzf-tab` if present)
- `install-gemini` – [Gemini CLI](https://github.com/google/gemini-cli)
- `install-ghostty` – [Ghostty](https://ghostty.org/) terminal + config restore
- `install-gh` – [GitHub CLI](https://github.com/cli/cli)
- `install-go` – [Go](https://golang.org/) + [golangci-lint](https://golangci-lint.run/)
- `install-jq` – [jq](https://jqlang.org/)
- `install-lsd` – [lsd](https://github.com/lsd-rs/lsd) + config/theme
- `install-mise` – [mise](https://mise.jdx.dev/)
- `install-ollama` – [Ollama](https://ollama.com/)
- `install-opencode` – [OpenCode](https://opencode.ai/)
- `install-rbenv` (or `install-ruby`) – [rbenv](https://github.com/rbenv/rbenv)
- `install-rust` – [rustup](https://rustup.rs/)
- `install-uv` (or `install-python`) – [uv](https://docs.astral.sh/uv/) + Python tooling
- `install-zed` – [Zed](https://zed.dev/)
- `install-zig` – [Zig](https://ziglang.org/)
- `install-zoxide` (or `install-z`) – [zoxide](https://github.com/ajeetdsouza/zoxide)
- `install-antigravity` – [Antigravity](https://antigravity.google/)
- `install-fonts` – [Homebrew](https://brew.sh/) font casks

Tip: use `update-all` to run every registered updater in one shot.

## Updating

Run `update-zdotfiles` to pull the latest repo changes and reload automatically. `update-all` runs all registered updaters (including `update-zdotfiles`) and reloads at the end.

## Performance

- Benchmark before/after changes with `zsh-startup-bench`.
- Use `zsh-startup-profile` for a quick zprof-enabled timing run.
- Quick sanity check without launching an interactive shell: `zsh -lic exit`.
