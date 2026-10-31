# .NET global tools (dotnet tool install -g): https://learn.microsoft.com/dotnet/core/tools/global-tools

[[ -x "$HOME/.dotnet/tools/dotnet-ef" ]] || install-dotnet-ef() {
  info "Installing dotnet-ef..."
  command dotnet tool update -g dotnet-ef || return
  reload
}

[[ -x "$HOME/.dotnet/tools/dotnet-outdated" ]] || install-dotnet-outdated() {
  info "Installing dotnet-outdated..."
  command dotnet tool update -g dotnet-outdated-tool || return
  reload
}

update-dotnet-tools() {
  info "Updating dotnet tools..."
  command dotnet tool update --all -g
}

updates+=(update-dotnet-tools)
