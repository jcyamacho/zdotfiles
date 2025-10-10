# ZOXIDE (smarter cd command): https://github.com/ajeetdsouza/zoxide
_install_zoxide() {
  curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh -s -- --bin-dir "$CUSTOM_TOOLS_DIR" > /dev/null
}

if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"

  alias uninstall-z="uninstall-zoxide"
  uninstall-zoxide() {
    info "Uninstalling zoxide..."
    rm -f "$CUSTOM_TOOLS_DIR/zoxide"
    reload
  }

  alias update-z="update-zoxide"
  update-zoxide() {
    info "Updating zoxide..."
    _install_zoxide
  }

  updates+=(update-zoxide)
else
  alias install-z="install-zoxide"
  install-zoxide() {
    info "Installing zoxide..."
    _install_zoxide
    reload
  }
fi
