# .NET SDK env, PATH, completion, lifecycle: https://dotnet.microsoft.com/
if exists dotnet; then
  export DOTNET_CLI_TELEMETRY_OPTOUT=1
  export DOTNET_NOLOGO=1

  # Global tools (dotnet tool install -g) install here.
  path=("$HOME/.dotnet/tools" "${path[@]}")

  # Completion for the dotnet command. The SDK computes candidates from the live
  # command line, so this is a dynamic completion function registered with compdef
  # (which lets fzf-tab wrap it); there is no static #compdef script to cache.
  _dotnet() {
    local completions=("${(@f)$(command dotnet complete "$words")}")
    compadd -- "${(@)completions:#}"
  }
  compdef _dotnet dotnet

  if exists brew; then
    uninstall-dotnet() {
      info "Uninstalling dotnet..."
      command brew uninstall --cask dotnet-sdk
      reload
    }
  fi
elif exists brew; then
  install-dotnet() {
    info "Installing dotnet..."
    command brew install --cask dotnet-sdk
    reload
  }
fi
