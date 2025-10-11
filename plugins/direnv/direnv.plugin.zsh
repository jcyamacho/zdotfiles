# DIRENV (per directory env vars via .envrc): https://direnv.net/
export DIRENV_CONFIG_DIR="$HOME/.config/direnv"
export DIRENV_CONFIG_FILE="$DIRENV_CONFIG_DIR/direnv.toml"

_install_direnv() {
  export bin_path="$CUSTOM_TOOLS_DIR"
  curl -sfL https://direnv.net/install.sh | bash > /dev/null
  unset bin_path

  if [ ! -f "$DIRENV_CONFIG_FILE" ]; then
    command mkdir -p "$DIRENV_CONFIG_DIR"
    command cp "$ZDOTFILES_DIR/plugins/direnv/direnv.toml" "$DIRENV_CONFIG_FILE"
  fi
}

_has_direnv() {
  (( $+commands[direnv] ))
}

if _has_direnv; then
  eval "$(direnv hook zsh)"

  uninstall-direnv() {
    info "Uninstalling direnv..."
    command rm "$CUSTOM_TOOLS_DIR/direnv"
    command rm -rf "$DIRENV_CONFIG_DIR"
    reload
  }

  update-direnv() {
    info "Updating direnv..."
    _install_direnv
  }

  direnvconfig() {
    $EDITOR "$DIRENV_CONFIG_FILE"
  }

  updates+=(update-direnv)
else
  install-direnv() {
    info "Installing direnv..."
    _install_direnv
    reload
  }

  _direnv_hook() {}
fi
