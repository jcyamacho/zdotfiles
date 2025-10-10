# jq (command-line JSON processor): https://jqlang.org/
if (( ! $+commands[brew] )); then
  return
fi

if (( $+commands[jq] )); then
  uninstall-jq() {
    info "Uninstalling jq..."
    brew uninstall jq
    reload
  }
else
  install-jq() {
    info "Installing jq..."
    brew install jq
    reload
  }
fi
