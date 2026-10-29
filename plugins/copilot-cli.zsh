# GitHub Copilot (desktop app and terminal agent): https://github.com/features/copilot/
if [[ -d "/Applications/GitHub Copilot.app" ]]; then
  uninstall-copilot() {
    info "Uninstalling copilot..."
    command brew uninstall --cask github-copilot-app || return
    reload
  }
else
  install-copilot() {
    info "Installing copilot..."
    command brew install --no-ask --cask --adopt github-copilot-app || return
    reload
  }
fi

if exists copilot; then
  typeset -g _copilot_home="${COPILOT_HOME:-$HOME/.copilot}"

  copilot-config() {
    edit "$_copilot_home"
  }

  uninstall-copilot-cli() {
    info "Uninstalling copilot..."
    command brew uninstall --cask copilot-cli || return

    if confirm "Delete Copilot CLI data in $_copilot_home?" no; then
      command rm -rf -- "$_copilot_home"
    fi

    reload
  }
else
  install-copilot-cli() {
    info "Installing copilot..."
    command brew install --no-ask --cask --adopt copilot-cli || return
    reload
  }
fi
