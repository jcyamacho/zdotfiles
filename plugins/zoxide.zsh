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
    clear-cached-init zoxide
    reload
  }

  alias update-z="update-zoxide"
  update-zoxide() {
    info "Updating zoxide..."
    _install_zoxide
    clear-cached-init zoxide
  }

  updates+=(update-zoxide)
else
  alias install-z="install-zoxide"
  install-zoxide() {
    info "Installing zoxide..."
    _install_zoxide
    clear-cached-init zoxide
    reload
  }
fi
