# carapace (A multi-shell completion library/binary): https://carapace.sh/
# full list: https://carapace-sh.github.io/carapace-bin/completers.html

if exists carapace; then
  source-cached-init carapace _carapace zsh

  uninstall-carapace() {
    info "Uninstalling carapace..."
    command brew uninstall carapace || return
    reload
  }
else
  install-carapace() {
    info "Installing carapace..."
    command brew install --no-ask carapace || return
    reload
  }
fi
