# OpenCode (AI coding agent built for the terminal): https://opencode.ai/

export OPENCODE_HOME="$HOME/.opencode"

if [ -s "$OPENCODE_HOME" ]; then
  path=("$OPENCODE_HOME/bin" $path)
fi

if exists opencode; then
  typeset -r _opencode_config_dir="$HOME/.config/opencode"
  typeset -r _opencode_agent_dir="$_opencode_config_dir/agent"
  typeset -r _opencode_settings_file="$_opencode_config_dir/opencode.json"

  alias oc="opencode"

  opencode-config() {
    if [ ! -d "$_opencode_agent_dir" ]; then
      # https://opencode.ai/docs/agents#markdown
      command mkdir -p "$_opencode_agent_dir"
    fi

    if [ ! -f "$_opencode_settings_file" ]; then
      command mkdir -p "$_opencode_config_dir"
      echo '{ "$schema": "https://opencode.ai/config.json" }' > "$settings_file_path"
    fi

    edit "$_opencode_config_dir"
  }

  uninstall-opencode() {
    info "Uninstalling opencode..."
    command rm -rf "$OPENCODE_HOME"
    command rm -rf "$_opencode_config_dir"
    reload
  }

  update-opencode() {
    info "Updating opencode..."
    _lock_zshrc
    opencode upgrade
    _unlock_zshrc
  }

  updates+=(update-opencode)

  if exists gh; then
    typeset -r _opencode_settings_gist_description="opencode-settings"
    typeset -r _opencode_agent_gist_description="opencode-agent-dir"

    opencode-settings-load-from-gist() {
      load-file-from-gist "${_opencode_settings_file}" "${_opencode_settings_gist_description}"
      load-dir-from-gist "${_opencode_agent_dir}" "${_opencode_agent_gist_description}"
    }

    opencode-settings-save-to-gist() {
      save-file-to-gist "${_opencode_settings_file}" "${_opencode_settings_gist_description}"
      save-dir-to-gist "${_opencode_agent_dir}" "${_opencode_agent_gist_description}"
    }
  fi
else
  install-opencode() {
    info "Installing opencode..."
    _lock_zshrc
    curl -fsSL https://opencode.ai/install | sh
    _unlock_zshrc
    reload
  }
fi
