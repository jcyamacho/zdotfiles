# wezterm (terminal emulator): https://wezterm.org/

export WEZTERM_CONFIG_DIR="$HOME/.config/wezterm"
export WEZTERM_CONFIG_FILE="$WEZTERM_CONFIG_DIR/wezterm.lua"

_wezterm_restore_config() {
  builtin print -r -- "Copying default config..."
  command mkdir -p -- "$WEZTERM_CONFIG_DIR"
  command cp -- "$ZDOTFILES_DIR/plugins/wezterm/wezterm.lua" "$WEZTERM_CONFIG_FILE"
}

if exists wezterm; then
  alias wezterm-restore-config="_wezterm_restore_config"

  wezterm-config() {
    edit "$WEZTERM_CONFIG_FILE"
  }

  if exists brew; then
    uninstall-wezterm() {
      info "Uninstalling wezterm..."
      command brew uninstall --cask wezterm
      command rm -rf -- "$WEZTERM_CONFIG_DIR"
      reload
    }
  fi
elif exists brew; then
  install-wezterm() {
    info "Installing wezterm..."
    command brew install --cask wezterm
    _wezterm_restore_config
    reload
  }
fi
