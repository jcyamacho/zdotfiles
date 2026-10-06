# zoxide (smarter cd command): https://github.com/ajeetdsouza/zoxide

if exists zoxide; then
  source-cached-init zoxide init zsh

  alias uninstall-z="uninstall-zoxide"
  uninstall-zoxide() {
    info "Uninstalling zoxide..."
    command brew uninstall zoxide || return
    reload
  }
else
  alias install-z="install-zoxide"
  install-zoxide() {
    info "Installing zoxide..."
    command brew install --no-ask zoxide || return
    reload
  }
fi
