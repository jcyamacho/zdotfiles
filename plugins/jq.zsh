# jq (command-line JSON processor): https://jqlang.org/

exists brew || return

if exists jq; then
  uninstall-jq() {
    info "Uninstalling jq..."
    command brew uninstall jq || return
    reload
  }
else
  install-jq() {
    info "Installing jq..."
    command brew install --no-ask jq || return
    reload
  }
fi
