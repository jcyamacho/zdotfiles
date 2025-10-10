# DENO (javascript runtime): https://deno.land/
export DENO_INSTALL="$HOME/.deno"

_has_deno() {
  [ -s "$DENO_INSTALL/bin/deno" ]
}

if _has_deno; then
  path=("$DENO_INSTALL/bin" $path)

  uninstall-deno() {
    info "Uninstalling deno..."
    rm -rf "$DENO_INSTALL"
    reload
  }

  update-deno() {
    info "Updating deno..."
    deno upgrade
  }

  updates+=(update-deno)
else
  install-deno() {
    info "Installing deno..."
    curl -fsSL https://deno.land/install.sh | sh -s -- --no-modify-path -y
    reload
  }
fi
