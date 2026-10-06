# atuin (command-line history): https://atuin.sh/

if exists atuin; then
  source-cached-init atuin init zsh --disable-up-arrow

  atuin-config() {
    edit-open "$HOME/.config/atuin/config.toml"
  }

  uninstall-atuin() {
    info "Uninstalling atuin..."
    command brew uninstall atuin || return

    local history_dir="$HOME/.local/share/atuin"
    if confirm "Delete atuin history in $history_dir?" no; then
      command rm -rf -- "$history_dir"
    fi

    reload
  }
else
  install-atuin() {
    info "Installing atuin..."
    command brew install --no-ask atuin || return
    reload
  }
fi
