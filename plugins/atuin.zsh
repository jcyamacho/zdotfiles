# atuin (command-line history): https://atuin.sh/
typeset -g +r _atuin_dir="$HOME/.atuin"

if [[ -d "$_atuin_dir/bin" ]]; then
  path=("$_atuin_dir/bin" "${path[@]}")

  exists atuin || return

  source-cached-init atuin init zsh --disable-up-arrow

  atuin-config() {
    edit-open "$HOME/.config/atuin/config.toml"
  }

  uninstall-atuin() {
    info "Uninstalling atuin..."
    command rm -rf -- "$_atuin_dir"
    command rm -rf -- "$HOME/.local/share/atuin"
    reload
  }

  _update_atuin() {
    info "Updating atuin..."
    _lock_zshrc
    command atuin update
    _unlock_zshrc
  }

  update-atuin() {
    _update_atuin
    reload
  }

  updates+=(_update_atuin)
else
  install-atuin() {
    info "Installing atuin..."
    _run_remote_installer "https://setup.atuin.sh"
    reload
  }
fi
