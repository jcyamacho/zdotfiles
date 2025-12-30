# atuin (command-line history): https://atuin.sh/
(( $+_atuin_dir )) || typeset -gr _atuin_dir="$HOME/.atuin"
(( $+_atuin_bin_dir )) || typeset -gr _atuin_bin_dir="$_atuin_dir/bin"

if [[ -d "$_atuin_bin_dir" ]]; then
  path=("$_atuin_bin_dir" "${path[@]}")

  exists atuin || return

  source-cached-init atuin init zsh --disable-up-arrow

  atuin-config() {
    edit "$HOME/.config/atuin/config.toml"
  }

  uninstall-atuin() {
    info "Uninstalling atuin..."
    command rm -rf -- "$_atuin_dir"
    command rm -rf -- "$HOME/.local/share/atuin"
    clear-cached-init atuin
    reload
  }

  update-atuin() {
    info "Updating atuin..."
    _lock_zshrc
    if command atuin update; then
      clear-cached-init atuin
    fi
    _unlock_zshrc
  }

  updates+=(update-atuin)
else
  install-atuin() {
    info "Installing atuin..."
    _run_remote_installer "https://setup.atuin.sh"
    reload
  }
fi
