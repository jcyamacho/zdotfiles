# ZED (A modern text editor): https://zed.dev/

if exists zed; then
  # Use ZED as the default editor if EDITOR is not set
  export EDITOR="${EDITOR:-zed --wait}"

  zd() {
    local dir="${1:-$PWD}"
    command zed "$dir"
  }

  # Save/Load Zed Settings using GitHub Gist
  if exists gh; then
    (( $+_zed_settings_path )) || typeset -gr _zed_settings_path="$HOME/.config/zed/settings.json"
    (( $+_zed_gist_description )) || typeset -gr _zed_gist_description="zed-settings"

    zed-settings-load-from-gist() {
      load-file-from-gist "${_zed_settings_path}" "${_zed_gist_description}"
    }

    zed-settings-save-to-gist() {
      save-file-to-gist "${_zed_settings_path}" "${_zed_gist_description}"
    }
  fi
fi

exists brew || return

if exists zed; then
  uninstall-zed() {
    info "Uninstalling zed..."
    command brew uninstall --cask zed
    reload
  }
else
  install-zed() {
    info "Installing zed..."
    command brew install --cask zed
    reload
  }
fi
