# zellij (terminal workspace): https://zellij.dev/

exists brew || return

export ZELLIJ_CONFIG_DIR="$HOME/.config/zellij"

if exists zellij; then
  source-cached-init zellij setup --generate-completion zsh

  alias zj="zellij"

  zellij-config() {
    edit "$ZELLIJ_CONFIG_DIR"
  }

  uninstall-zellij() {
    info "Uninstalling zellij..."
    command brew uninstall zellij
    command rm -rf -- "$ZELLIJ_CONFIG_DIR"
    clear-cached-init zellij
    reload
  }
else
  install-zellij() {
    info "Installing zellij..."
    command brew install zellij
    command mkdir -p -- "$ZELLIJ_CONFIG_DIR"
    reload
  }
fi
