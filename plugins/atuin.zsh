# atuin (command-line history): https://atuin.sh/

if exists atuin; then
  typeset -g _atuin_config_file="$HOME/.config/atuin/config.toml"

  # The init output includes settings from the config, such as tmux options.
  source-cached-output --dep "$_atuin_config_file" atuin init zsh --disable-up-arrow

  atuin-config() {
    edit "$_atuin_config_file"
  }

  uninstall-atuin() {
    info "Uninstalling atuin..."
    command brew uninstall atuin || return

    local history_dir="$HOME/.local/share/atuin"
    if confirm "Delete atuin history and sync encryption key in $history_dir?" no; then
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
