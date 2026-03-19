# varlock (AI-safe .env files): https://varlock.dev/

exists brew || return

if exists varlock; then
  uninstall-varlock() {
    info "Uninstalling varlock..."
    command brew uninstall varlock
    reload
  }
else
  install-varlock() {
    info "Installing varlock..."
    command brew install dmno-dev/tap/varlock
    reload
  }
fi
