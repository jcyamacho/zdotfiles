# DIRENV (per directory env vars via .envrc): https://direnv.net/
export DIRENV_CONFIG_DIR="$HOME/.config/direnv"
export DIRENV_CONFIG_FILE="$DIRENV_CONFIG_DIR/direnv.toml"

_install_direnv() {
  export bin_path="$CUSTOM_TOOLS_DIR"
  command curl -sfL https://direnv.net/install.sh | command bash > /dev/null
  unset bin_path

  if [[ ! -f $DIRENV_CONFIG_FILE ]]; then
    command mkdir -p -- "$DIRENV_CONFIG_DIR"
    command cp -- "$ZDOTFILES_DIR/plugins/direnv/direnv.toml" "$DIRENV_CONFIG_FILE"
  fi
}

if exists direnv; then
  source-cached-init direnv hook zsh

  uninstall-direnv() {
    info "Uninstalling direnv..."
    command rm -f -- "$CUSTOM_TOOLS_DIR/direnv"
    command rm -rf -- "$DIRENV_CONFIG_DIR"
    clear-cached-init direnv
    reload
  }

  update-direnv() {
    info "Updating direnv..."
    _install_direnv
    clear-cached-init direnv
  }

  direnv-config() {
    edit "$DIRENV_CONFIG_FILE"
  }

  updates+=(update-direnv)
else
  install-direnv() {
    info "Installing direnv..."
    _install_direnv
    clear-cached-init direnv
    reload
  }

  _direnv_hook() {}
fi
