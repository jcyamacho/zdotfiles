# television (terminal fuzzy finder): https://alexpasmantier.github.io/television/

if exists tv; then
  if ! exists atuin; then
    source-cached-init tv init zsh
  fi

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
