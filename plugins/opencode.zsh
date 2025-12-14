# OpenCode (AI coding agent built for the terminal): https://opencode.ai/

export OPENCODE_HOME="$HOME/.opencode"

if [[ -d $OPENCODE_HOME/bin ]]; then
  path=("$OPENCODE_HOME/bin" $path)
fi

if exists opencode; then
  typeset -r _opencode_config_dir="$HOME/.config/opencode"
  typeset -r _opencode_agent_dir="$_opencode_config_dir/agent"
  typeset -r _opencode_command_dir="$_opencode_config_dir/command"
  typeset -r _opencode_tool_dir="$_opencode_config_dir/tool"
  typeset -r _opencode_plugin_dir="$_opencode_config_dir/plugin"
  typeset -r _opencode_settings_file="$_opencode_config_dir/opencode.json"
  typeset -r _opencode_global_rules_file="$_opencode_config_dir/AGENTS.md"

  alias oc="opencode"

  opencode-config() {
    if [[ ! -d $_opencode_agent_dir ]]; then
      # https://opencode.ai/docs/agents#markdown
      command mkdir -p -- "$_opencode_agent_dir"
    fi

    if [[ ! -d $_opencode_command_dir ]]; then
      # https://opencode.ai/docs/commands#markdown
      command mkdir -p -- "$_opencode_command_dir"
    fi

    if [[ ! -d $_opencode_tool_dir ]]; then
      # https://opencode.ai/docs/custom-tools
      command mkdir -p -- "$_opencode_tool_dir"
    fi

    if [[ ! -f $_opencode_global_rules_file ]]; then
      # https://opencode.ai/docs/rules/#global
      command touch -- "$_opencode_global_rules_file"
    fi

    if [[ ! -d $_opencode_plugin_dir ]]; then
      # https://opencode.ai/docs/plugins
      command mkdir -p -- "$_opencode_plugin_dir"
    fi

    if [[ ! -f $_opencode_settings_file ]]; then
      builtin print -r -- '{ "$schema": "https://opencode.ai/config.json" }' > "$_opencode_settings_file"
    fi

    edit "$_opencode_config_dir"
  }

  opencode-install-agents() {
    if ! exists bunx; then
      warn "Missing bunx; install bun first"
      return 1
    fi

    info "Installing agents via agentic-cli..."
    command bunx agentic-cli pull -g
  }

  uninstall-opencode() {
    info "Uninstalling opencode..."
    command rm -rf -- "$OPENCODE_HOME"
    command rm -rf -- "$_opencode_config_dir"
    reload
  }

  update-opencode() {
    info "Updating opencode..."
    # force opencode to reinstall plugins
    command rm -rf -- "$HOME/.cache/opencode"
    _lock_zshrc
    command opencode upgrade
    _unlock_zshrc
  }

  updates+=(update-opencode)

  if exists gh; then
    typeset -r _opencode_settings_gist_description="opencode-settings"
    typeset -r _opencode_agent_gist_description="opencode-agent-dir"
    typeset -r _opencode_command_gist_description="opencode-command-dir"
    typeset -r _opencode_tool_gist_description="opencode-tool-dir"
    typeset -r _opencode_global_rules_gist_description="opencode-global-rules"
    typeset -r _opencode_plugin_gist_description="opencode-plugin-dir"


    opencode-settings-load-from-gist() {
      load-file-from-gist "${_opencode_settings_file}" "${_opencode_settings_gist_description}"
      load-file-from-gist "${_opencode_global_rules_file}" "${_opencode_global_rules_gist_description}"
      load-dir-from-gist "${_opencode_agent_dir}" "${_opencode_agent_gist_description}"
      load-dir-from-gist "${_opencode_command_dir}" "${_opencode_command_gist_description}"
      load-dir-from-gist "${_opencode_tool_dir}" "${_opencode_tool_gist_description}"
      load-dir-from-gist "${_opencode_plugin_dir}" "${_opencode_plugin_gist_description}"
    }

    opencode-settings-save-to-gist() {
      save-file-to-gist "${_opencode_settings_file}" "${_opencode_settings_gist_description}"
      save-file-to-gist "${_opencode_global_rules_file}" "${_opencode_global_rules_gist_description}"
      save-dir-to-gist "${_opencode_agent_dir}" "${_opencode_agent_gist_description}"
      save-dir-to-gist "${_opencode_command_dir}" "${_opencode_command_gist_description}"
      save-dir-to-gist "${_opencode_tool_dir}" "${_opencode_tool_gist_description}"
      save-dir-to-gist "${_opencode_plugin_dir}" "${_opencode_plugin_gist_description}"
    }
  fi
else
  install-opencode() {
    info "Installing opencode..."
    _lock_zshrc
    command curl -fsSL https://opencode.ai/install | command sh
    _unlock_zshrc
    reload
  }
fi
