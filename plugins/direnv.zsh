# DIRENV (per directory env vars via .envrc): https://direnv.net/
_install_direnv() {
  export bin_path="$CUSTOM_TOOLS_DIR"
  curl -sfL https://direnv.net/install.sh | bash
  unset bin_path
}

_has_direnv() {
  (( $+commands[direnv] ))
}

if _has_direnv; then
  eval "$(direnv hook zsh)"

  uninstall-direnv() {
    info "Uninstalling direnv..."
    local bin_file="$CUSTOM_TOOLS_DIR/direnv"
    command rm $bin_file
    reload
  }

  update-direnv() {
    info "Updating direnv..."
    _install_direnv
  }

  updates+=(update-direnv)
else
  install-direnv() {
    info "Installing direnv..."
    _install_direnv
    reload
  }
fi
