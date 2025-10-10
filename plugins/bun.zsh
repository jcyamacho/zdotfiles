# BUN (javascript runtime): https://bun.sh/
export BUN_INSTALL="$HOME/.bun"

_has_bun() {
  [ -s "$BUN_INSTALL/_bun" ]
}

if _has_bun; then
  path=("$BUN_INSTALL/bin" $path)

  uninstall-bun() {
    info "Uninstalling bun..."
    command rm -rf -- "$BUN_INSTALL"
    reload
  }

  update-bun() {
    info "Updating bun..."
    bun upgrade
  }

  updates+=(update-bun)
else
  install-bun() {
    info "Installing bun..."
    chmod -w ~/.zshrc
    curl -fsSL https://bun.sh/install | sh
    chmod +w ~/.zshrc
    reload
  }
fi
