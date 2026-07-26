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
    command brew install television
    reload
  }
fi
