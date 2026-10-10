# television (terminal fuzzy finder): https://alexpasmantier.github.io/television/

if exists tv; then
  typeset -g _tv_config_file="$HOME/.config/television/config.toml"

  # The init output binds the keys set in [shell_integration.keybindings].
  source-cached-output --dep "$_tv_config_file" tv init zsh

  tv-config() {
    command mkdir -p -- "${_tv_config_file:h}"
    edit "$_tv_config_file"
  }

  uninstall-television() {
    info "Uninstalling television..."
    command brew uninstall television || return
    reload
  }
else
  install-television() {
    info "Installing television..."
    command brew install --no-ask television || return

    # tv's built-in channels shell out to these: `fd` feeds dirs and files, and
    # `bat` renders their previews. Without fd the channels return nothing, so
    # the Ctrl+T binding this plugin installs would be dead.
    info "Installing fd and bat (television channel dependencies)..."
    command brew install --no-ask fd bat || warn "Could not install fd and bat, so television channels may return nothing"

    reload
  }
fi
