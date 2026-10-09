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
    command mkdir -p -- "$_direnv_config_dir"
    edit-open "$_direnv_config_dir/direnv.toml"
  }
else
  install-direnv() {
    info "Installing direnv..."
    command brew install --no-ask direnv || return

    # direnv reads the legacy config.toml only when direnv.toml is missing.
    [[ -f "$_direnv_config_dir/direnv.toml" || -f "$_direnv_config_dir/config.toml" ]] || {
      command mkdir -p -- "$_direnv_config_dir"
      command cp -- "$ZDOTFILES_DIR/plugins/direnv/direnv.toml" "$_direnv_config_dir/direnv.toml"
    }

    reload
  }

  _direnv_hook() {}
fi
