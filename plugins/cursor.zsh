# Cursor (IDE and terminal agent): https://www.cursor.com/

if exists cursor; then
  cr() {
    local dir="${1:-$PWD}"

    command cursor --classic "$dir"
  }

  if exists brew; then
    uninstall-cursor() {
      info "Uninstalling cursor..."
      command brew uninstall --cask cursor || return
      reload
    }
  fi
elif exists brew; then
  install-cursor() {
    info "Installing cursor..."
    command brew install --no-ask --cask cursor || return
    reload
  }
fi

# The native CLI installer always uses ~/.local/bin.
path=("$HOME/.local/bin" "${path[@]}")

if exists cursor-agent; then
  uninstall-cursor-cli() {
    info "Uninstalling cursor CLI..."
    if [[ "$HOME/.local/bin/agent" -ef "$HOME/.local/bin/cursor-agent" ]]; then
      command rm -f -- "$HOME/.local/bin/agent" || return
    fi

    command rm -f -- "$HOME/.local/bin/cursor-agent" || return
    command rm -rf -- "$HOME/.local/share/cursor-agent" || return
    reload
  }

  _update_cursor_cli() {
    info "Updating cursor CLI..."
    command cursor-agent update
  }

  update-cursor-cli() {
    _update_cursor_cli || return
    reload
  }

  updates+=(_update_cursor_cli)
else
  install-cursor-cli() {
    info "Installing cursor CLI..."
    _run_remote_installer "https://cursor.com/install" "bash" || return
    reload
  }
fi
