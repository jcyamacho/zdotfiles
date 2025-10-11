# GITHUB_CLI (GitHub on the command line): https://github.com/cli/cli
if ! exists brew; then
  return
fi

if exists gh; then
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
