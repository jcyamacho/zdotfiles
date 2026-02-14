# zoxide (smarter cd command): https://github.com/ajeetdsouza/zoxide

_install_zoxide() {
  _run_remote_installer "https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh" "sh" -- --bin-dir "$CUSTOM_TOOLS_DIR" > /dev/null
}

if exists zoxide; then
  source-cached-init zoxide init zsh

  alias uninstall-z="uninstall-zoxide"
  uninstall-zoxide() {
    info "Uninstalling zoxide..."
    command rm -f -- "$CUSTOM_TOOLS_DIR/zoxide"
    reload
  }

  _update_zoxide() {
    info "Updating zoxide..."
    _install_zoxide
  }

  alias update-z="update-zoxide"
  update-zoxide() {
    _update_zoxide
    reload
  }

  updates+=(_update_zoxide)
else
  alias install-z="install-zoxide"
  install-zoxide() {
    info "Installing zoxide..."
    _install_zoxide
    reload
  }
fi
