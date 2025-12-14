# BUN (javascript runtime): https://bun.sh/
export BUN_INSTALL="$HOME/.bun"

if [[ -d $BUN_INSTALL/bin ]]; then
  path=("$BUN_INSTALL/bin" $path)
fi

if exists bun; then
  uninstall-bun() {
    info "Uninstalling bun..."
    command rm -rf -- "$BUN_INSTALL"
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
    _lock_zshrc
    command curl -fsSL https://bun.sh/install | command sh
    _unlock_zshrc
    reload
  }
fi
