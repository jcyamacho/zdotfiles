# direnv (per-directory env vars via .envrc): https://direnv.net/
typeset -g _direnv_config_dir="$HOME/.config/direnv"

if exists direnv; then
  source-cached-init direnv hook zsh

  uninstall-direnv() {
    info "Uninstalling direnv..."
    command brew uninstall direnv || return

    if confirm "Delete direnv config in $_direnv_config_dir?" no; then
      command rm -rf -- "$_direnv_config_dir"
    fi

    reload
  }

  direnv-config() {
    edit-open "$_direnv_config_dir/direnv.toml"
  }
else
  install-direnv() {
    info "Installing direnv..."
    command brew install --no-ask direnv || return

    [[ -f "$_direnv_config_dir/direnv.toml" ]] || {
      command mkdir -p -- "$_direnv_config_dir"
      command cp -- "$ZDOTFILES_DIR/plugins/direnv/direnv.toml" "$_direnv_config_dir/direnv.toml"
    }

    reload
  }

  _direnv_hook() {}
fi
