# lsd (ls alternative): https://github.com/lsd-rs/lsd
(( $+_lsd_config_dir )) || typeset -gr _lsd_config_dir="$HOME/.config/lsd"
(( $+_lsd_config_file )) || typeset -gr _lsd_config_file="$_lsd_config_dir/config.yaml"

if exists lsd; then
  ll() {
    command lsd -lahg "$@"
  }

  lt() {
    command lsd --tree "$@"
  }

  lsd-config() {
    edit "$_lsd_config_file"
  }

  if exists brew; then
    uninstall-lsd() {
      info "Uninstalling lsd..."
      command brew uninstall lsd
      command rm -rf -- "$_lsd_config_dir"
      reload
    }
  fi
elif exists brew; then
  _lsd_restore_config() {
    command mkdir -p -- "$_lsd_config_dir"
    info "Downloading color theme..."
    command curl -fsSL https://raw.githubusercontent.com/catppuccin/lsd/refs/heads/main/themes/catppuccin-mocha/colors.yaml -o "$_lsd_config_dir/colors.yaml"
    info "Writing config file..."
    builtin print -r -- $'color:\n  theme: custom\n' >| "$_lsd_config_file"
  }

  install-lsd() {
    info "Installing lsd..."
    command brew install lsd
    _lsd_restore_config
    reload
  }
fi
