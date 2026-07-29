# television (terminal fuzzy finder): https://alexpasmantier.github.io/television/

if exists tv; then
  source-cached-init tv init zsh

  tv-config() {
    command mkdir -p -- "$HOME/.config/television"
    edit-open "$HOME/.config/television/config.toml"
  }

  if exists brew; then
    uninstall-television() {
      info "Uninstalling television..."
      command brew uninstall television
      reload
    }
  fi
elif exists brew; then
  install-television() {
    info "Installing television..."
    command brew install --no-ask television

    # tv's built-in channels shell out to these: `fd` feeds dirs and files, and
    # `bat` renders their previews. Without fd the channels return nothing, so
    # the Ctrl+T binding this plugin installs would be dead.
    info "Installing fd and bat (television channel dependencies)..."
    command brew install --no-ask fd bat

    reload
  }
fi
