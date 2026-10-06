# atuin (command-line history): https://atuin.sh/

if exists atuin; then
  source-cached-init atuin init zsh --disable-up-arrow

  atuin-config() {
    edit-open "$HOME/.config/atuin/config.toml"
  }

  uninstall-atuin() {
    info "Uninstalling atuin..."
    command brew uninstall atuin || return
    command rm -rf -- "$HOME/.local/share/atuin"
    reload
  }
else
  install-atuin() {
    info "Installing atuin..."
    command brew install --no-ask atuin || return
    reload
  }
fi
