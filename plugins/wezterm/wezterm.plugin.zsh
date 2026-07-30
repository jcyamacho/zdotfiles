# wezterm (terminal emulator): https://wezterm.org/

export WEZTERM_CONFIG_FILE="${WEZTERM_CONFIG_FILE:-$HOME/.config/wezterm/wezterm.lua}"

_wezterm_restore_config() {
  builtin print -r -- "Copying default config..."
  command mkdir -p -- "${WEZTERM_CONFIG_FILE:h}"
  command cp -- "$ZDOTFILES_DIR/plugins/wezterm/wezterm.lua" "$WEZTERM_CONFIG_FILE"
}

if exists wezterm; then
  alias wezterm-restore-config="_wezterm_restore_config"

  wezterm-config() {
    edit-open "$WEZTERM_CONFIG_FILE"
  }

  if exists brew; then
    uninstall-wezterm() {
      info "Uninstalling wezterm..."
      command brew uninstall --cask wezterm || return
      command rm -rf -- "$HOME/.config/wezterm"
      reload
    }
  fi
elif exists brew; then
  install-wezterm() {
    info "Installing wezterm..."
    command brew install --no-ask --cask wezterm || return
    _wezterm_restore_config
    reload
  }
fi
