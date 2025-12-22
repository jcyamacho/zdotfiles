# atuin (command-line history): https://atuin.sh/
export ATUIN_DIR="$HOME/.atuin"
export ATUIN_BIN_DIR="$ATUIN_DIR/bin"

if [[ -d "$ATUIN_BIN_DIR" ]]; then
  path=("$ATUIN_BIN_DIR" "${path[@]}")

  exists atuin || return

  source-cached-init atuin init zsh --disable-up-arrow

  atuin-config() {
    edit "$HOME/.config/atuin/config.toml"
  }

  uninstall-atuin() {
    info "Uninstalling atuin..."
    command rm -rf -- "$ATUIN_DIR"
    clear-cached-init atuin
    reload
  }

  update-atuin() {
    info "Updating atuin..."
    _lock_zshrc
    if command atuin update; then
      clear-cached-init atuin
    fi
    _unlock_zshrc
  }

  updates+=(update-atuin)
else
  install-atuin() {
    info "Installing atuin..."
    _lock_zshrc
    command curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | command sh
    _unlock_zshrc
    reload
  }
fi
