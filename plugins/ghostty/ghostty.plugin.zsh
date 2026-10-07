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

  command mkdir -p -- "$_ghostty_config_dir/themes" || return

  local theme result=0
  for theme in "${themes[@]}"; do
    builtin print -r -- "Downloading ${theme}..."
    command curl --proto '=https' --tlsv1.2 -fsSL "${themes_url}/${theme}.conf" \
      -o "$_ghostty_config_dir/themes/${theme}.conf" || result=1
  done
  return $result
}

_ghostty_copy_config() {
  if is-macos; then
    # Ghostty loads these after the XDG files, so they would override the copy.
    command rm -f -- "$HOME/Library/Application Support/com.mitchellh.ghostty/"{config,config.ghostty}
  fi

  builtin print -r -- "Copying default config..."
  command mkdir -p -- "$_ghostty_config_dir" || return
  command cp -- "$ZDOTFILES_DIR/plugins/ghostty/config" "$_ghostty_config_dir/config"
}

_ghostty_restore_config() {
  _ghostty_update_themes || warn "Some themes could not be downloaded"
  _ghostty_copy_config
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

  uninstall-ghostty() {
    info "Uninstalling ghostty..."
    command brew uninstall --cask ghostty || return

    if confirm "Delete Ghostty config in $_ghostty_config_dir?" no; then
      command rm -rf -- "$_ghostty_config_dir"
    fi

    reload
  }
else
  install-ghostty() {
    info "Installing ghostty..."
    command brew install --no-ask --cask font-monaspace || return
    command brew install --no-ask --cask ghostty || return
    _ghostty_update_themes || warn "Some themes could not be downloaded"
    [[ -f "$_ghostty_config_dir/config" ]] || _ghostty_copy_config
    reload
  }
fi
