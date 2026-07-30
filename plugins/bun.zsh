# bun (JavaScript runtime): https://bun.sh/
typeset -g _bun_dir="$HOME/.bun"

if [[ -d "$_bun_dir/bin" ]]; then
  path=("$_bun_dir/bin" "${path[@]}")

  exists bun || return

  cache-completion bun completions

  uninstall-bun() {
    info "Uninstalling bun..."
    command rm -rf -- "$_bun_dir" || return
    reload
  }

  _update_bun() {
    info "Updating bun..."
    _run_with_zshrc_locked bun upgrade
  }

  update-bun() {
    _update_bun || return
    reload
  }

  updates+=(_update_bun)
else
  install-bun() {
    info "Installing bun..."
    _run_remote_installer "https://bun.sh/install" "sh" --env "BUN_INSTALL=$_bun_dir" || return
    reload
  }
fi
