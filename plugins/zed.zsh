# zed (modern text editor): https://zed.dev/

if exists zed; then
  export EDITOR="${EDITOR:-zed --wait}"

  zd() {
    command zed "${@:-$PWD}"
  }

  zed-settings-load-from-gist() {
    load-file-from-gist "$HOME/.config/zed/settings.json" "zed-settings"
  }

  zed-settings-save-to-gist() {
    save-file-to-gist "$HOME/.config/zed/settings.json" "zed-settings"
  }

  uninstall-zed() {
    info "Uninstalling zed..."
    command brew uninstall --cask zed || return
    command rm -rf -- "$HOME/Library/Caches/Zed" "$HOME/Library/Caches/dev.zed.Zed"

    local -a data_dirs=("$HOME/.config/zed" "$HOME/Library/Application Support/Zed")
    if confirm "Delete Zed settings and data in ${data_dirs[*]}?" no; then
      command rm -rf -- "${data_dirs[@]}"
    fi

    reload
  }
else
  # reload keeps exported variables, so drop the default set above once zed is
  # gone.
  [[ ${EDITOR-} == "zed --wait" ]] && unset EDITOR

  install-zed() {
    info "Installing zed..."
    command brew install --no-ask --cask zed || return
    reload
  }
fi
