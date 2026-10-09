# Nub (all-in-one Node.js toolkit): https://nubjs.com/

if exists nub; then
  uninstall-nub() {
    info "Uninstalling Nub..."
    command brew uninstall nubjs/tap/nub || return
    command rm -rf -- "$HOME/.cache/nub"
    reload
  }
else
  install-nub() {
    info "Installing Nub..."
    command brew install --no-ask nubjs/tap/nub || return
    reload
  }
fi
