# OpenCode (AI coding agent built for the terminal): https://opencode.ai/

export OPENCODE_HOME="$HOME/.opencode"

if [ -s "$OPENCODE_HOME" ]; then
  path=("$OPENCODE_HOME/bin" $path)
fi

if exists opencode; then
  alias oc="opencode"

  uninstall-opencode() {
    info "Uninstalling opencode..."
    command rm -rf "$OPENCODE_HOME"
    reload
  }

  update-opencode() {
    info "Updating opencode..."
    _lock_zshrc
    opencode upgrade
    _unlock_zshrc
  }

  opencode-config() {
    $EDITOR "$OPENCODE_HOME"
  }

  updates+=(update-opencode)
else
  install-opencode() {
    info "Installing opencode..."
    _lock_zshrc
    curl -fsSL https://opencode.ai/install | sh
    _unlock_zshrc
    reload
  }
fi
