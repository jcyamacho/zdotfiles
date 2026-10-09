# VSCode (IDE): https://code.visualstudio.com/

if exists code; then
  c() {
    command code "${@:-$PWD}"
  }

  uninstall-code() {
    info "Uninstalling visual studio code..."
    command brew uninstall --cask visual-studio-code || return
    command rm -rf -- "$HOME/Library/Caches/com.microsoft.VSCode" \
      "$HOME/Library/Caches/com.microsoft.VSCode.ShipIt"

    local -a data_dirs=("$HOME/.vscode" "$HOME/Library/Application Support/Code")
    if confirm "Delete VS Code settings and extensions in ${data_dirs[*]}?" no; then
      command rm -rf -- "${data_dirs[@]}"
    fi

    reload
  }
else
  install-code() {
    info "Installing visual studio code..."
    command brew install --no-ask --cask visual-studio-code || return
    reload
  }
fi
