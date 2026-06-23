# .NET global tools (dotnet tool install -g): https://learn.microsoft.com/dotnet/core/tools/global-tools

exists dotnet-ef || install-dotnet-ef() {
  info "Installing dotnet-ef..."
  command dotnet tool update -g dotnet-ef
}

exists dotnet-outdated || install-dotnet-outdated() {
  info "Installing dotnet-outdated..."
  command dotnet tool update -g dotnet-outdated-tool
}

_update_dotnet_tools() {
  info "Updating dotnet tools..."
  command dotnet tool update --all -g
}

update-dotnet() {
  if exists brew; then
    info "Updating dotnet SDK..."
    command brew upgrade --cask dotnet-sdk
  fi
  _update_dotnet_tools
  reload
}

# update-all upgrades the SDK cask via update-brew; register only the tools here.
updates+=(_update_dotnet_tools)
