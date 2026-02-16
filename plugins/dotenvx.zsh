# dotenvx (a secure dotenv): https://github.com/dotenvx/dotenvx

if exists dotenvx; then
  uninstall-dotenvx() {
    info "Uninstalling dotenvx..."
    command rm -f -- "$CUSTOM_TOOLS_DIR/dotenvx"
    reload
  }

  _update_dotenvx() {
    info "Updating dotenvx..."
    _run_remote_installer "https://dotenvx.sh" "sh" -- --directory="$CUSTOM_TOOLS_DIR" --force
  }

  update-dotenvx() { _update_dotenvx; reload }
  updates+=(_update_dotenvx)
else
  install-dotenvx() {
    info "Installing dotenvx..."
    _run_remote_installer "https://dotenvx.sh" "sh" -- --directory="$CUSTOM_TOOLS_DIR"
    reload
  }
fi
