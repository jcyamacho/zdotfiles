# lsd (ls alternative): https://github.com/lsd-rs/lsd
export LSD_CONFIG_DIR="$HOME/.config/lsd"
export LSD_CONFIG_FILE="$LSD_CONFIG_DIR/config.yaml"

if exists lsd; then
  ll() {
    command lsd -lahg "$@"
  }

  lt() {
    command lsd --tree "$@"
  }

  lsd-config() {
    edit "$LSD_CONFIG_FILE"
  }
fi

_lsd_restore_config() {
  command mkdir -p "$LSD_CONFIG_DIR"
  info "Downloading color theme..."
  command curl -fsSL https://raw.githubusercontent.com/catppuccin/lsd/refs/heads/main/themes/catppuccin-mocha/colors.yaml -o "$LSD_CONFIG_DIR/colors.yaml"
  info "Writing config file..."
  builtin print "color:\n  theme: custom" > "$LSD_CONFIG_FILE"
}

if ! exists brew; then
  return
fi

if exists lsd; then
  uninstall-lsd() {
    info "Uninstalling lsd..."
    command brew uninstall lsd
    command rm -rf -- "$LSD_CONFIG_DIR"
    reload
  }

else
  install-lsd() {
    info "Installing lsd..."
    command brew install lsd
    _lsd_restore_config
    reload
  }
fi
