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

Antidote reads `.zsh_plugins.txt` and, by default, pulls in `getantidote/use-omz` so you get Oh My Zsh core helpers along with curated `ohmyzsh/ohmyzsh` plugins (git, brew, docker, etc.) plus a handful of local snippets under `plugins/`.

## Recommended Tools

To enhance your shell experience, consider installing these optional tools:

- **[fzf](https://junegunn.github.io/fzf/)** – Fuzzy finder for command-line autocomplete and file searching

  ```sh
  install-fzf
  ```

- **[Carapace](https://carapace.sh/)** – Multi-shell completion engine with 1000+ completers

  ```sh
  install-carapace
  ```

- **[Atuin](https://atuin.sh/)** – Magical shell history with sync, search, and context

  ```sh
  install-atuin
  ```

These tools integrate seamlessly once installed and will significantly improve your command-line workflow.

## Updating

Run `update-zdotdir` to pull the latest repo changes and reload automatically. `update-all` is also available if you want a one-liner that refreshes everything before reloading the shell.
