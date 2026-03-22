# television (terminal fuzzy finder): https://alexpasmantier.github.io/television/

(( $+_tv_config_file )) || typeset -gr _tv_config_file="$HOME/.config/television/config.toml"

if exists tv; then
  if ! exists atuin; then
    source-cached-init tv init zsh
  fi

  tv-config() {
    command mkdir -p -- "${_tv_config_file:h}"
    edit "$_tv_config_file"
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
