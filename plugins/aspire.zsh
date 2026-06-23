# Aspire (CLI for distributed apps): https://aspire.dev/
if exists aspire; then
  export ASPIRE_CLI_TELEMETRY_OPTOUT=1

  if exists brew; then
    uninstall-aspire() {
      info "Uninstalling aspire..."
      command brew uninstall --cask aspire
      reload
    }
  fi
elif exists brew; then
  install-aspire() {
    info "Installing aspire..."
    command brew install --cask microsoft/aspire/aspire
    reload
  }
fi
