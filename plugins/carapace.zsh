# carapace (A multi-shell completion library/binary): https://carapace.sh/
# full list: https://carapace-sh.github.io/carapace-bin/completers.html

if exists carapace; then
  export CARAPACE_BRIDGES="zsh"
  source <(carapace _carapace)
else
  install-carapace() {
    builtin print "check: https://carapace-sh.github.io/carapace-bin/install.html"
  }
fi

if ! exists brew; then
  return
fi

if exists carapace; then
  uninstall-carapace() {
    info "Uninstalling carapace..."
    brew uninstall carapace
    reload
  }
else
  install-carapace() {
    info "Installing carapace..."
    brew install carapace
    reload
  }
fi
