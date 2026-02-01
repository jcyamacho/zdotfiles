# zellij (terminal workspace): https://zellij.dev/

export ZELLIJ_CONFIG_DIR="$HOME/.config/zellij"

if exists zellij; then
  source-cached-init zellij setup --generate-completion zsh

  alias zj="zellij"

  za() {
    local session_name=${1:-${PWD:t}}
    command zellij attach "$session_name" 2>/dev/null || command zellij -s "$session_name"
  }

  zellij-config() {
    edit "$ZELLIJ_CONFIG_DIR"
  }

  if exists brew; then
    uninstall-zellij() {
      info "Uninstalling zellij..."
      command brew uninstall zellij
      command rm -rf -- "$ZELLIJ_CONFIG_DIR"
      clear-cached-init zellij
      reload
    }
  fi
elif exists brew; then
  install-zellij() {
    info "Installing zellij..."
    command brew install zellij
    command mkdir -p -- "$ZELLIJ_CONFIG_DIR"
    reload
  }
fi
