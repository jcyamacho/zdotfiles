# ghostty (terminal emulator): https://ghostty.org/
typeset -g _ghostty_config_dir="$HOME/.config/ghostty"

_ghostty_update_themes() {
  local themes_url="https://raw.githubusercontent.com/catppuccin/ghostty/refs/heads/main/themes"

  local themes=(
    catppuccin-mocha
    catppuccin-macchiato
    catppuccin-latte
    catppuccin-frappe
  )

  command mkdir -p -- "$_ghostty_config_dir/themes"

  local theme
  for theme in "${themes[@]}"; do
    builtin print -r -- "Downloading ${theme}..."
    command curl -fsSL "${themes_url}/${theme}.conf" -o "$_ghostty_config_dir/themes/${theme}.conf"
  done
}

_ghostty_restore_config() {
  if is-macos; then
    # Remove existing macOS config file
    command rm -f -- "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
  fi

  _ghostty_update_themes

  builtin print -r -- "Copying default config..."
  command mkdir -p -- "$_ghostty_config_dir"
  command cp -- "$ZDOTFILES_DIR/plugins/ghostty/config" "$_ghostty_config_dir/config"
}

if exists ghostty; then
  alias ghostty-restore-config="_ghostty_restore_config"

  ghostty-config() {
    edit-open "$_ghostty_config_dir/config"
  }

  ghostty-update-themes() {
    info "Updating ghostty themes..."
    _ghostty_update_themes
  }

  # No _update_ pattern needed: theme updates don't affect shell state, no reload required
  updates+=(ghostty-update-themes)

  if exists brew; then
    uninstall-ghostty() {
      info "Uninstalling ghostty..."
      command brew uninstall --cask ghostty || return
      command rm -rf -- "$_ghostty_config_dir"
      reload
    }
  fi
elif exists brew; then
  install-ghostty() {
    info "Installing ghostty..."
    command brew install --no-ask --cask font-monaspace || return
    command brew install --no-ask --cask ghostty || return
    _ghostty_restore_config
    reload
  }
fi
