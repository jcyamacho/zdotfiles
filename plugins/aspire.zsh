# Aspire (CLI for distributed apps): https://aspire.dev/
if exists aspire; then
  export ASPIRE_CLI_TELEMETRY_OPTOUT=1

  uninstall-aspire() {
    info "Uninstalling aspire..."
    command aspire cache clear || warn "Could not clear the aspire cache"
    command brew uninstall --cask aspire || return

    if confirm "Delete Aspire config and deployment state in $HOME/.aspire?" no; then
      command rm -rf -- "$HOME/.aspire"
    fi

    reload
  }
else
  install-aspire() {
    info "Installing aspire..."
    command brew install --no-ask --cask microsoft/aspire/aspire || return
    reload
  }
fi
