# jq (command-line JSON processor): https://jqlang.org/
_has_jq() {
  (( $+commands[jq] ))
}

if ! _has_brew; then
  return
fi

if _has_jq; then
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
