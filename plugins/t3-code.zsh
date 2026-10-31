# T3 Code (desktop GUI for coding agents): https://t3.codes/
if [[ -d "$HOMEBREW_PREFIX/Caskroom/t3-code" ]]; then
  export T3CODE_TELEMETRY_ENABLED=false

  uninstall-t3-code() {
    local t3_home="$HOME/.t3"

    # --zap must be chosen before the single brew call that removes the app.
    local -a zap=()
    if confirm "Delete T3 Code threads, settings, and credentials in $t3_home/userdata and ~/Library?" no; then
      zap=(--zap)
    fi

    info "Uninstalling T3 Code..."
    command brew uninstall "${zap[@]}" --cask t3-code || return

    # Even --zap leaves the CLI shim, downloaded tools, and updater caches.
    command rm -rf -- "$t3_home"/{bin,caches,tools} \
      "$HOME/Library/Caches"/{com.t3tools.t3code{,.ShipIt},t3-code-desktop-updater,t3code-updater}

    if confirm "Delete T3 Code worktrees and their uncommitted changes in $t3_home/worktrees?" no; then
      command rm -rf -- "$t3_home/worktrees"
    fi

    reload
  }
else
  install-t3-code() {
    info "Installing T3 Code..."
    # --adopt takes over a copy installed from the website, which the guard
    # does not detect.
    command brew install --no-ask --cask --adopt t3-code || return
    reload
  }
fi
