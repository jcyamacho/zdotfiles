# bun (JavaScript runtime): https://bun.sh/
typeset -g _bun_dir="$HOME/.bun"

if [[ -x "$_bun_dir/bin/bun" ]]; then
  path=("$_bun_dir/bin" "${path[@]}")

  # Bun has no tool-specific opt-out; other tools honor this convention too.
  export DO_NOT_TRACK=1

  # Sourced, not autoloaded from $fpath: the script only defines _bun and
  # calls compdef, so autoloading it would waste the first Tab.
  source-cached-init bun completions

  uninstall-bun() {
    info "Uninstalling bun..."
    command rm -rf -- "$_bun_dir" "$HOME/Library/Caches/bun" || return
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
    _run_remote_installer "https://bun.sh/install" --env "BUN_INSTALL=$_bun_dir" || return
    reload
  }
fi
