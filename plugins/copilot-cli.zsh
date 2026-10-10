# GitHub Copilot CLI (Copilot coding agent in the terminal): https://github.com/features/copilot/cli/
if exists copilot; then
  typeset -g _copilot_home="${COPILOT_HOME:-$HOME/.copilot}"

  copilot-config() {
    edit "$_copilot_home"
  }

  uninstall-copilot() {
    info "Uninstalling copilot..."
    command brew uninstall --cask copilot-cli || return

    if confirm "Delete Copilot CLI data in $_copilot_home?" no; then
      command rm -rf -- "$_copilot_home"
    fi

    reload
  }
else
  install-copilot() {
    info "Installing copilot..."
    command brew install --no-ask --cask copilot-cli || return
    reload
  }
fi
