# Aspire (CLI for distributed apps): https://aspire.dev/
if exists aspire; then
  export ASPIRE_CLI_TELEMETRY_OPTOUT=1

  uninstall-aspire() {
    info "Uninstalling aspire..."
    command brew uninstall --cask aspire || return
    reload
  }
else
  install-aspire() {
    info "Installing aspire..."
    command brew install --no-ask --cask microsoft/aspire/aspire || return
    reload
  }
fi
