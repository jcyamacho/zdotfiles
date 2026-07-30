# atuin (command-line history): https://atuin.sh/
typeset -g _atuin_dir="$HOME/.atuin"

if [[ -d "$_atuin_dir/bin" ]]; then
  path=("$_atuin_dir/bin" "${path[@]}")

  exists atuin || return

  source-cached-init atuin init zsh --disable-up-arrow

  atuin-config() {
    edit-open "$HOME/.config/atuin/config.toml"
  }

  uninstall-atuin() {
    info "Uninstalling atuin..."
    command rm -rf -- "$_atuin_dir" || return
    command rm -rf -- "$HOME/.local/share/atuin"
    reload
  }

  _update_atuin() {
    info "Updating atuin..."
    _run_with_zshrc_locked atuin update
  }

  update-atuin() {
    _update_atuin || return
    reload
  }

  updates+=(_update_atuin)
else
  install-atuin() {
    info "Installing atuin..."
    _run_remote_installer "https://setup.atuin.sh" || return
    reload
  }
fi
