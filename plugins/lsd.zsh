# lsd (ls alternative): https://github.com/lsd-rs/lsd
typeset -g _lsd_config_dir="$HOME/.config/lsd"

if exists lsd; then
  ll() {
    command lsd -lahg "$@"
  }

  lt() {
    command lsd --tree "$@"
  }

  lsd-config() {
    edit-open "$_lsd_config_dir/config.yaml"
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
    builtin print -r -- $'color:\n  theme: custom\n' >| "$_lsd_config_dir/config.yaml"
  }

  install-lsd() {
    info "Installing lsd..."
    command brew install --no-ask lsd
    _lsd_restore_config
    reload
  }
fi
