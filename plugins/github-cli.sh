# GITHUB_CLI (GitHub on the command line): https://github.com/cli/cli
_has_github_cli() {
  (( $+commands[gh] ))
}

if ! _has_github_cli; then
  return
fi

if (( $+commands[gh] )); then
  uninstall-gh() {
    info "Uninstalling gh-cli..."
    brew uninstall gh
    reload
  }
else
  install-gh() {
    info "Installing gh-cli..."
    brew install gh
    reload
  }
fi
