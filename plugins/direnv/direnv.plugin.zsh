# direnv (per-directory env vars via .envrc): https://direnv.net/
export DIRENV_CONFIG_DIR="$HOME/.config/direnv"
export DIRENV_CONFIG_FILE="$DIRENV_CONFIG_DIR/direnv.toml"

_install_direnv() {
  _run_remote_installer "https://direnv.net/install.sh" "bash" --env "bin_path=$CUSTOM_TOOLS_DIR" > /dev/null

  [[ -f "$DIRENV_CONFIG_FILE" ]] || {
    command mkdir -p -- "$DIRENV_CONFIG_DIR"
    command cp -- "$ZDOTFILES_DIR/plugins/direnv/direnv.toml" "$DIRENV_CONFIG_FILE"
  }
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

  _update_direnv() {
    info "Updating direnv..."
    _install_direnv
    clear-cached-init direnv
  }

  update-direnv() {
    _update_direnv
    reload
  }

  direnv-config() {
    edit "$DIRENV_CONFIG_FILE"
  }

  updates+=(_update_direnv)
else
  install-direnv() {
    info "Installing direnv..."
    _install_direnv
    clear-cached-init direnv
    reload
  }

  _direnv_hook() {}
fi
