# jq (command-line JSON processor): https://jqlang.org/

if ! exists brew; then
  return
fi

if exists jq; then
  uninstall-jq() {
    info "Uninstalling jq..."
    command brew uninstall jq
    reload
  }
else
  install-jq() {
    info "Installing jq..."
    command brew install jq
    reload
  }
fi
