# .NET global tools (dotnet tool install -g): https://learn.microsoft.com/dotnet/core/tools/global-tools

exists dotnet-ef || install-dotnet-ef() {
  info "Installing dotnet-ef..."
  command dotnet tool update -g dotnet-ef
}

exists dotnet-outdated || install-dotnet-outdated() {
  info "Installing dotnet-outdated..."
  command dotnet tool update -g dotnet-outdated-tool
}

update-dotnet-tools() {
  info "Updating dotnet tools..."
  command dotnet tool update --all -g
}

updates+=(update-dotnet-tools)
