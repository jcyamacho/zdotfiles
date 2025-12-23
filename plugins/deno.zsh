# DENO (javascript runtime): https://deno.land/
export DENO_INSTALL="$HOME/.deno"

if [[ -f "$DENO_INSTALL/bin/deno" ]]; then
  path=("$DENO_INSTALL/bin" "${path[@]}")

  uninstall-deno() {
    info "Uninstalling deno..."
    command rm -rf -- "$DENO_INSTALL"
    reload
  }

  update-deno() {
    info "Updating deno..."
    command deno upgrade
  }

  updates+=(update-deno)
else
  install-deno() {
    info "Installing deno..."
    _run_remote_installer "https://deno.land/install.sh" "sh" -- --no-modify-path -y
    reload
  }
fi
