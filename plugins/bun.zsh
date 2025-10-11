# BUN (javascript runtime): https://bun.sh/
export BUN_INSTALL="$HOME/.bun"

if [ -s "$BUN_INSTALL" ]; then
  path=("$BUN_INSTALL/bin" $path)
fi

if exists bun; then
  uninstall-bun() {
    info "Uninstalling bun..."
    command rm -rf "$BUN_INSTALL"
    reload
  }

  update-bun() {
    info "Updating bun..."
    bun upgrade
  }

  updates+=(update-bun)
else
  install-bun() {
    local zshrc_file="$HOME/.zshrc"
    info "Installing bun..."
    command chmod -w "$zshrc_file"
    curl -fsSL https://bun.sh/install | sh
    command chmod +w "$zshrc_file"
    reload
  }
fi
