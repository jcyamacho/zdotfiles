# Orca (IDE for orchestrating AI coding agents across worktrees): https://www.onorca.dev/
if exists orca; then
  export ORCA_TELEMETRY_DISABLED=1

  uninstall-orca() {
    info "Uninstalling Orca..."
    command brew uninstall --cask stablyai/orca/orca || return
    command rm -rf -- "$HOME/Library/Caches/com.stablyai.orca" \
      "$HOME/Library/Caches/com.stablyai.orca.ShipIt"

    local data_dirs=("$HOME/.orca" "$HOME/Library/Application Support/Orca")
    if confirm "Delete Orca data in ${data_dirs[*]}?" no; then
      command rm -rf -- "${data_dirs[@]}"
    fi

    reload
  }
else
  install-orca() {
    info "Installing Orca..."
    command brew install --no-ask --cask stablyai/orca/orca || return
    reload
  }
fi
