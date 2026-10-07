# zellij (terminal workspace): https://zellij.dev/

export ZELLIJ_CONFIG_DIR="${ZELLIJ_CONFIG_DIR:-$HOME/.config/zellij}"

# Extra arguments go to cp: install passes -n to keep existing layouts.
_zellij_copy_layouts() {
  local layouts_dir="$ZELLIJ_CONFIG_DIR/layouts"
  info "Copying zellij layouts..."
  command mkdir -p -- "$layouts_dir" || return
  command cp -R "$@" -- "$ZDOTFILES_DIR/plugins/zellij/layouts/." "$layouts_dir/"
}

if exists zellij; then
  cache-completion zellij setup --generate-completion zsh

  alias zj="zellij"

  za() {
    local max_session_name_len=36
    local session_name=${1:-${PWD:t}}

    session_name="${session_name//\//-}"
    if (( ${#session_name} > max_session_name_len )); then
      local session_hash="$(builtin print -r -- "$session_name" | command cksum)"
      session_hash="${session_hash%% *}"
      local prefix_len=$(( max_session_name_len - ${#session_hash} - 1 ))
      session_name="${session_name[1,prefix_len]}-$session_hash"
    fi

    command zellij attach -c "$session_name"
  }

  zellij-config() {
    edit-open "$ZELLIJ_CONFIG_DIR"
  }

  zellij-copy-layouts() {
    _zellij_copy_layouts
  }

  uninstall-zellij() {
    info "Uninstalling zellij..."
    command brew uninstall zellij || return

    if confirm "Delete zellij config in $ZELLIJ_CONFIG_DIR?" no; then
      command rm -rf -- "$ZELLIJ_CONFIG_DIR"
    fi

    reload
  }
else
  install-zellij() {
    info "Installing zellij..."
    command brew install --no-ask zellij || return
    _zellij_copy_layouts -n
    reload
  }
fi
