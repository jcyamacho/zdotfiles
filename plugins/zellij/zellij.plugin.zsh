# zellij (terminal workspace): https://zellij.dev/

export ZELLIJ_CONFIG_DIR="$HOME/.config/zellij"

_zellij_copy_layouts() {
  local layouts_dir="$ZELLIJ_CONFIG_DIR/layouts"
  info "Copying zellij layouts..."
  command mkdir -p -- "$layouts_dir"
  command cp -R -- "$ZDOTFILES_DIR/plugins/zellij/layouts/." "$layouts_dir/"
}

if exists zellij; then
  # Completions must be deferred - they call _arguments which only works in completion context
  zsh-defer source-cached-init zellij setup --generate-completion zsh

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

    command zellij attach "$session_name" 2>/dev/null || command zellij -s "$session_name"
  }

  zellij-config() {
    edit "$ZELLIJ_CONFIG_DIR"
  }

  zellij-copy-layouts() {
    _zellij_copy_layouts
  }

  if exists brew; then
    uninstall-zellij() {
      info "Uninstalling zellij..."
      command brew uninstall zellij
      command rm -rf -- "$ZELLIJ_CONFIG_DIR"
      clear-cached-init zellij
      reload
    }
  fi
elif exists brew; then
  install-zellij() {
    info "Installing zellij..."
    command brew install zellij
    _zellij_copy_layouts
    reload
  }
fi
