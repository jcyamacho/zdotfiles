# wezterm (terminal emulator): https://wezterm.org/

export WEZTERM_CONFIG_FILE="${WEZTERM_CONFIG_FILE:-$HOME/.config/wezterm/wezterm.lua}"

_wezterm_restore_config() {
  builtin print -r -- "Copying default config..."
  command mkdir -p -- "${WEZTERM_CONFIG_FILE:h}" || return
  command cp -- "$ZDOTFILES_DIR/plugins/wezterm/wezterm.lua" "$WEZTERM_CONFIG_FILE"
}

if exists wezterm; then
  alias wezterm-restore-config="_wezterm_restore_config"

  wezterm-config() {
    edit-open "$WEZTERM_CONFIG_FILE"
  }

  uninstall-wezterm() {
    info "Uninstalling wezterm..."
    command brew uninstall --cask wezterm || return

    # WezTerm exports the file it loaded, such as ~/.wezterm.lua, so only a
    # directory named wezterm is safe to delete as a whole.
    local config_path="${WEZTERM_CONFIG_FILE:h}"
    [[ "${config_path:t}" == wezterm ]] || config_path="$WEZTERM_CONFIG_FILE"
    if confirm "Delete WezTerm config in $config_path?" no; then
      command rm -rf -- "$config_path"
    fi

    reload
  }
else
  install-wezterm() {
    info "Installing wezterm..."
    command brew install --no-ask --cask font-monaspace || return
    command brew install --no-ask --cask wezterm || return
    [[ -f "$WEZTERM_CONFIG_FILE" ]] || _wezterm_restore_config
    reload
  }
fi
