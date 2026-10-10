# lsd (ls alternative): https://github.com/lsd-rs/lsd
typeset -g _lsd_config_dir="$HOME/.config/lsd"

if exists lsd; then
  alias ll="command lsd -lahg"
  alias lt="command lsd --tree"

  lsd-config() {
    edit-open "$_lsd_config_dir/config.yaml"
  }

  uninstall-lsd() {
    info "Uninstalling lsd..."
    command brew uninstall lsd || return

    if confirm "Delete lsd config in $_lsd_config_dir?" no; then
      command rm -rf -- "$_lsd_config_dir"
    fi

    reload
  }
else
  _lsd_restore_config() {
    command mkdir -p -- "$_lsd_config_dir" || return
    info "Downloading color theme..."
    # config.yaml selects the custom theme, so it is written only after the
    # theme it needs has downloaded.
    command curl --proto '=https' --tlsv1.2 -fsSL https://raw.githubusercontent.com/catppuccin/lsd/refs/heads/main/themes/catppuccin-mocha/colors.yaml -o "$_lsd_config_dir/colors.yaml" || return
    info "Writing config file..."
    builtin print -r -- $'color:\n  theme: custom\n' >| "$_lsd_config_dir/config.yaml"
  }

  install-lsd() {
    info "Installing lsd..."
    command brew install --no-ask lsd || return
    [[ -f "$_lsd_config_dir/config.yaml" || -f "$_lsd_config_dir/colors.yaml" ]] ||
      _lsd_restore_config || warn "Could not set up the lsd color theme"
    reload
  }
fi
