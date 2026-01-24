# yazi (terminal file manager): https://yazi-rs.github.io

export YAZI_CONFIG_HOME="$HOME/.config/yazi"

_yazi_restore_config() {
  info "Installing catppuccin-mocha flavor..."
  command ya pkg add yazi-rs/flavors:catppuccin-mocha

  builtin print -r "Copying config files..."
  command mkdir -p -- "$YAZI_CONFIG_HOME"
  command cp -- "$ZDOTFILES_DIR/plugins/yazi/yazi.toml" "$YAZI_CONFIG_HOME/yazi.toml"
  command cp -- "$ZDOTFILES_DIR/plugins/yazi/theme.toml" "$YAZI_CONFIG_HOME/theme.toml"
}

if exists yazi; then
  # Shell wrapper that changes CWD when exiting yazi
  y() {
    local tmp cwd
    tmp="$(command mktemp -t "yazi-cwd.XXXXXX")"
    command yazi "$@" --cwd-file="$tmp"
    IFS= builtin read -r cwd < "$tmp" || :
    if [[ -n $cwd && $cwd != "$PWD" && -d $cwd ]]; then
      builtin cd -- "$cwd"
    fi
    command rm -f -- "$tmp"
  }

  # ZLE widget for Ctrl+O keybinding
  _yazi_widget() {
    y
    zle reset-prompt
  }
  zle -N _yazi_widget
  bindkey '^o' _yazi_widget

  alias yazi-restore-config="_yazi_restore_config"
  alias yazi-config='edit "$YAZI_CONFIG_HOME"'

  if exists brew; then
    uninstall-yazi() {
      info "Uninstalling yazi..."
      command brew uninstall yazi
      command rm -rf -- "$YAZI_CONFIG_HOME"
      reload
    }
  fi
elif exists brew; then
  install-yazi() {
    info "Installing yazi..."
    command brew install yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick
    _yazi_restore_config
    reload
  }
fi
