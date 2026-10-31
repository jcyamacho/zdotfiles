# .NET SDK through dotnetup (user-level toolchain manager): https://learn.microsoft.com/dotnet/core/tools/dotnetup/
typeset -g _dotnetup_data_dir="$HOME/Library/Application Support/dotnetup"

if [[ -x "$CUSTOM_TOOLS_DIR/dotnetup" ]]; then
  export DOTNET_CLI_TELEMETRY_OPTOUT=1
  export DOTNET_NOLOGO=1

  # The SDK is not in the machine-wide location, so framework-dependent apps,
  # including global tools, need DOTNET_ROOT to find the runtime. dotnetup does
  # not read DOTNET_ROOT: it installs into the root in its data directory unless
  # a command passes --install-path or global.json sets sdk.paths, so this value
  # must match that root and cannot move it.
  export DOTNET_ROOT="$_dotnetup_data_dir/dotnet"

  # Global tools (dotnet tool install -g) install in ~/.dotnet/tools.
  path=("$DOTNET_ROOT" "$HOME/.dotnet/tools" "${path[@]}")

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
    command rm -rf -- "$HOME/.dotnet/tools" "$_dotnetup_data_dir" "$CUSTOM_TOOLS_DIR/dotnetup" || return
    reload
  }

  _update_dotnet() {
    info "Updating dotnet..."
    command dotnetup self update || return
    command dotnetup update
  }

  update-dotnet() {
    _update_dotnet || return
    reload
  }

  updates+=(_update_dotnet)
else
  install-dotnet() {
    info "Installing dotnet..."
    _run_remote_installer "https://aka.ms/dotnetup/get-dotnetup.sh" \
      -- --install-dir "$CUSTOM_TOOLS_DIR" || return
    # The opt-outs above are not exported until dotnetup is installed.
    DOTNET_CLI_TELEMETRY_OPTOUT=1 DOTNET_NOLOGO=1 \
      command "$CUSTOM_TOOLS_DIR/dotnetup" install lts --interactive false || return
    reload
  }
fi
