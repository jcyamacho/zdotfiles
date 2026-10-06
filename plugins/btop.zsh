# btop (resource monitor): https://github.com/aristocratos/btop

if exists btop; then
  alias bt="btop"

  uninstall-btop() {
    info "Uninstalling btop..."
    command brew uninstall btop || return
    reload
  }
else
  install-btop() {
    info "Installing btop..."
    command brew install --no-ask btop || return
    reload
  }
fi
