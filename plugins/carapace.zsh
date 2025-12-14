# carapace (A multi-shell completion library/binary): https://carapace.sh/
# full list: https://carapace-sh.github.io/carapace-bin/completers.html

if exists carapace; then
  export CARAPACE_BRIDGES="zsh"
  source-cached-init carapace _carapace
fi

if ! exists brew; then
  install-carapace() {
    info "Install docs: https://carapace-sh.github.io/carapace-bin/install.html"
  }

  return
fi

if exists carapace; then
  uninstall-carapace() {
    info "Uninstalling carapace..."
    command brew uninstall carapace
    clear-cached-init carapace
    reload
  }
else
  install-carapace() {
    info "Installing carapace..."
    command brew install carapace
    clear-cached-init carapace
    reload
  }
fi
