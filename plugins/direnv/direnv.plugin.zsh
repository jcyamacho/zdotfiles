# direnv (per-directory env vars via .envrc): https://direnv.net/
typeset -g _direnv_config_dir="$HOME/.config/direnv"

_install_direnv() {
  _run_remote_installer "https://direnv.net/install.sh" "bash" --env "bin_path=$CUSTOM_TOOLS_DIR" > /dev/null

  [[ -f "$_direnv_config_dir/direnv.toml" ]] || {
    command mkdir -p -- "$_direnv_config_dir"
    command cp -- "$ZDOTFILES_DIR/plugins/direnv/direnv.toml" "$_direnv_config_dir/direnv.toml"
  }
}

if exists direnv; then
  source-cached-init direnv hook zsh

  uninstall-direnv() {
    info "Uninstalling direnv..."
    command rm -f -- "$CUSTOM_TOOLS_DIR/direnv"
    command rm -rf -- "$_direnv_config_dir"
    reload
  }

  _update_direnv() {
    info "Updating direnv..."
    _install_direnv
  }

  update-direnv() {
    _update_direnv
    reload
  }

  direnv-config() {
    edit-open "$_direnv_config_dir/direnv.toml"
  }

  updates+=(_update_direnv)
else
  install-direnv() {
    info "Installing direnv..."
    _install_direnv
    reload
  }

  _direnv_hook() {}
fi
