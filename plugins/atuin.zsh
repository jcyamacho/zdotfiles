# atuin (command-line history): https://atuin.sh/
export ATUIN_DIR="$HOME/.atuin"
export ATUIN_BIN_DIR="$ATUIN_DIR/bin"

if [ -d "$ATUIN_BIN_DIR" ]; then
  path=("$ATUIN_BIN_DIR" $path)

  eval "$(atuin init zsh)"

  atuin-config() {
    edit "$HOME/.config/atuin/config.toml"
  }

  uninstall-atuin() {
    info "Uninstalling atuin..."
    command rm -rf "$ATUIN_DIR"
    reload
  }

  update-atuin() {
    info "Updating atuin..."
    _lock_zshrc
    atuin update
    _unlock_zshrc
  }

  updates+=(update-atuin)
else
  install-atuin() {
    info "Installing atuin..."
    _lock_zshrc
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
    _unlock_zshrc
    reload
  }
fi
