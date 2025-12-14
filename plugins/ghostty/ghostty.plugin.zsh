# ghostty (terminal emulator): https://ghostty.org/
export GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"
export GHOSTTY_THEMES_DIR="$GHOSTTY_CONFIG_DIR/themes"
export GHOSTTY_CONFIG_FILE="$GHOSTTY_CONFIG_DIR/config"

_ghostty_update_themes() {
  local themes_url="https://raw.githubusercontent.com/catppuccin/ghostty/refs/heads/main/themes"

  local themes=(
    catppuccin-mocha
    catppuccin-macchiato
    catppuccin-latte
    catppuccin-frappe
  )

  command mkdir -p -- "$GHOSTTY_THEMES_DIR"

  for theme in "${themes[@]}"; do
    builtin print -r "Downloading ${theme}..."
    command curl -fsSL "${themes_url}/${theme}.conf" -o "$GHOSTTY_THEMES_DIR/${theme}.conf"
  done
}

_ghostty_restore_config() {
  # Remove existing macOS config file
  command rm -f -- "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

  _ghostty_update_themes

  builtin print -r "Copying default config..."
  command mkdir -p -- "$GHOSTTY_CONFIG_DIR"
  command cp -- "$ZDOTFILES_DIR/plugins/ghostty/config" "$GHOSTTY_CONFIG_FILE"
}

if exists ghostty; then
  alias ghostty-restore-config="_ghostty_restore_config"
  alias ghostty-config='edit "$GHOSTTY_CONFIG_FILE"'

  ghostty-update-themes() {
    info "Updating ghostty themes..."
    _ghostty_update_themes
  }

  updates+=(ghostty-update-themes)
fi

if ! exists brew; then
  return
fi

if exists ghostty; then
  uninstall-ghostty() {
    info "Uninstalling ghostty..."
    command brew uninstall --cask ghostty
    command rm -rf -- "$GHOSTTY_CONFIG_DIR"
    reload
  }
else
  install-ghostty() {
    info "Installing ghostty..."
    command brew install --cask ghostty
    _ghostty_restore_config
    reload
  }
fi
