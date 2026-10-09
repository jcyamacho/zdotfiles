# .NET SDK env, PATH, completion, lifecycle: https://dotnet.microsoft.com/
if exists dotnet; then
  export DOTNET_CLI_TELEMETRY_OPTOUT=1
  export DOTNET_NOLOGO=1

  # Global tools (dotnet tool install -g) install here.
  path=("$HOME/.dotnet/tools" "${path[@]}")

  # Completion for the dotnet command. The SDK computes candidates from the live
  # command line, so this is a dynamic completion function registered with compdef
  # (which lets fzf-tab wrap it). `dotnet completions script zsh` is not cached
  # because it gives project arguments and most path options no file completion.
  _dotnet() {
    # Only the words up to the cursor, so later arguments do not change the
    # candidates for the word being completed.
    local -a completions=("${(@f)$(command dotnet complete "${words[1,CURRENT]}")}")

    # For path arguments, the SDK returns nothing or only options that contain
    # the typed text, which compadd rejects.
    compadd -- "${(@)completions:#}" || _files
  }
  compdef _dotnet dotnet

  uninstall-dotnet() {
    info "Uninstalling dotnet..."
    # Only dotnet knows where the NuGet caches are, so clear them first.
    command dotnet nuget locals all --clear || warn "Could not clear the NuGet caches"
    command brew uninstall --cask dotnet-sdk || return
    reload
  }
else
  install-dotnet() {
    info "Installing dotnet..."
    command brew install --no-ask --cask dotnet-sdk || return
    reload
  }
fi
