# GitHub Copilot CLI (Copilot coding agent in the terminal): https://github.com/features/copilot/cli/
if exists copilot; then
  typeset -g _copilot_home="${COPILOT_HOME:-$HOME/.copilot}"

  copilot-config() {
    edit-open "$_copilot_home"
  }
fi

exists brew || return

if exists copilot; then
  uninstall-copilot() {
    info "Uninstalling copilot..."
    command brew uninstall --cask copilot-cli || return
    command rm -rf -- "$_copilot_home"
    reload
  }
else
  install-copilot() {
    info "Installing copilot..."
    command brew install --no-ask --cask copilot-cli || return
    reload
  }
fi
