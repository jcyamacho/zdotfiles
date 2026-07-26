# bun (JavaScript runtime): https://bun.sh/
typeset -g +r _bun_dir="$HOME/.bun"

if [[ -d "$_bun_dir/bin" ]]; then
  path=("$_bun_dir/bin" "${path[@]}")

  exists bun || return

  uninstall-bun() {
    info "Uninstalling bun..."
    command rm -rf -- "$_bun_dir"
    reload
  }

  _update_bun() {
    info "Updating bun..."
    _lock_zshrc
    command bun upgrade
    _unlock_zshrc
  }

  update-bun() {
    _update_bun
    reload
  }

  updates+=(_update_bun)
else
  install-bun() {
    info "Installing bun..."
    _run_remote_installer "https://bun.sh/install" "sh" --env "BUN_INSTALL=$_bun_dir"
    reload
  }
fi
