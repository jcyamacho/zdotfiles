# yazi (terminal file manager): https://yazi-rs.github.io

export YAZI_CONFIG_HOME="${YAZI_CONFIG_HOME:-$HOME/.config/yazi}"

_yazi_restore_config() {
  info "Installing catppuccin-mocha flavor..."
  command ya pkg add yazi-rs/flavors:catppuccin-mocha ||
    warn "Could not install the catppuccin-mocha flavor"

  info "Copying config files..."
  command mkdir -p -- "$YAZI_CONFIG_HOME" || return
  command cp -- "$ZDOTFILES_DIR/plugins/yazi/"{yazi,theme}.toml "$YAZI_CONFIG_HOME/"
}

if exists yazi; then
  # Shell wrapper that changes CWD when exiting yazi
  y() {
    local tmp cwd result=0
    tmp="$(command mktemp -t "yazi-cwd.XXXXXX")" || return
    command yazi "$@" --cwd-file="$tmp" || result=$?
    IFS= builtin read -r cwd < "$tmp" || :
    if [[ -n $cwd && $cwd != "$PWD" && -d $cwd ]]; then
      builtin cd -- "$cwd"
    fi
    command rm -f -- "$tmp"
    return "$result"
  }

  # ZLE widget for Ctrl+o keybinding
  _yazi_widget() {
    y
    zle reset-prompt
  }
  zle -N _yazi_widget
  bindkey '^o' _yazi_widget

  alias yazi-restore-config="_yazi_restore_config"

  yazi-config() {
    edit-open "$YAZI_CONFIG_HOME"
  }

  uninstall-yazi() {
    info "Uninstalling yazi..."
    command brew uninstall yazi || return

    if confirm "Delete yazi config in $YAZI_CONFIG_HOME?" no; then
      command rm -rf -- "$YAZI_CONFIG_HOME"
    fi

    reload
  }
else
  install-yazi() {
    info "Installing yazi..."
    command brew install --no-ask yazi || return
    [[ -d "$YAZI_CONFIG_HOME" ]] || _yazi_restore_config
    reload
  }
fi
