# BUN (javascript runtime): https://bun.sh/
(( $+_bun_dir )) || typeset -gr _bun_dir="$HOME/.bun"
(( $+_bun_bin_dir )) || typeset -gr _bun_bin_dir="$_bun_dir/bin"

if [[ -d "$_bun_bin_dir" ]]; then
  path=("$_bun_bin_dir" "${path[@]}")

  exists bun || return

  uninstall-bun() {
    info "Uninstalling bun..."
    command rm -rf -- "$_bun_dir"
    reload
  }

  update-bun() {
    info "Updating bun..."
    _lock_zshrc
    command bun upgrade
    _unlock_zshrc
  }

  updates+=(update-bun)
else
  install-bun() {
    info "Installing bun..."
    _run_remote_installer "https://bun.sh/install" "sh" --env "BUN_INSTALL=$_bun_dir"
    reload
  }
fi
