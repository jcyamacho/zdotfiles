# dotenvx (a secure dotenv): https://github.com/dotenvx/dotenvx

if exists dotenvx; then
  uninstall-dotenvx() {
    info "Uninstalling dotenvx..."
    # The installer also links dx to dotenvx when nothing else owns that name.
    if [[ "$CUSTOM_TOOLS_DIR/dx" -ef "$CUSTOM_TOOLS_DIR/dotenvx" ]]; then
      command rm -f -- "$CUSTOM_TOOLS_DIR/dx" || return
    fi

    command rm -f -- "$CUSTOM_TOOLS_DIR/dotenvx" || return
    reload
  }

  _update_dotenvx() {
    info "Updating dotenvx..."
    _run_remote_installer "https://dotenvx.sh" "sh" -- --directory="$CUSTOM_TOOLS_DIR"
  }

  update-dotenvx() {
    _update_dotenvx || return
    reload
  }
  updates+=(_update_dotenvx)
else
  install-dotenvx() {
    info "Installing dotenvx..."
    _run_remote_installer "https://dotenvx.sh" "sh" -- --directory="$CUSTOM_TOOLS_DIR" || return
    reload
  }
fi
