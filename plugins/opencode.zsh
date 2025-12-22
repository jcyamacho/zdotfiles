# OpenCode (AI coding agent built for the terminal): https://opencode.ai/

export OPENCODE_HOME="$HOME/.opencode"

[[ -d "$OPENCODE_HOME/bin" ]] && path=("$OPENCODE_HOME/bin" "${path[@]}")

if exists opencode; then
  typeset -gr _opencode_config_dir="$HOME/.config/opencode"
  typeset -gr _opencode_agent_dir="$_opencode_config_dir/agent"
  typeset -gr _opencode_command_dir="$_opencode_config_dir/command"
  typeset -gr _opencode_tool_dir="$_opencode_config_dir/tool"
  typeset -gr _opencode_plugin_dir="$_opencode_config_dir/plugin"
  typeset -gr _opencode_settings_file="$_opencode_config_dir/opencode.json"
  typeset -gr _opencode_global_rules_file="$_opencode_config_dir/AGENTS.md"
  typeset -gr _opencode_cache_dir="$HOME/.cache/opencode"

  alias oc="opencode"

  opencode-config() {
    # https://opencode.ai/docs/agents#markdown
    [[ -d "$_opencode_agent_dir" ]] || command mkdir -p -- "$_opencode_agent_dir"

    # https://opencode.ai/docs/commands#markdown
    [[ -d "$_opencode_command_dir" ]] || command mkdir -p -- "$_opencode_command_dir"

    # https://opencode.ai/docs/custom-tools
    [[ -d "$_opencode_tool_dir" ]] || command mkdir -p -- "$_opencode_tool_dir"

    # https://opencode.ai/docs/rules/#global
    [[ -f "$_opencode_global_rules_file" ]] || command touch -- "$_opencode_global_rules_file"

    # https://opencode.ai/docs/plugins
    [[ -d "$_opencode_plugin_dir" ]] || command mkdir -p -- "$_opencode_plugin_dir"

    [[ -f "$_opencode_settings_file" ]] || builtin print -r -- '{ "$schema": "https://opencode.ai/config.json" }' >| "$_opencode_settings_file"

    edit "$_opencode_config_dir"
  }

  opencode-install-agents() {
    exists bunx || {
      warn "Missing bunx; install bun first"
      return 1
    }

    info "Installing agents via agentic-cli..."
    command bunx agentic-cli pull -g
  }

  uninstall-opencode() {
    info "Uninstalling opencode..."
    command rm -rf -- "$OPENCODE_HOME"
    command rm -rf -- "$_opencode_config_dir"
    command rm -rf -- "$_opencode_cache_dir"
    reload
  }

  update-opencode() {
    info "Updating opencode..."
    _lock_zshrc
    command opencode upgrade
    _unlock_zshrc
  }

  updates+=(update-opencode)

  if exists gh; then
    typeset -gr _opencode_settings_gist_description="opencode-settings"
    typeset -gr _opencode_agent_gist_description="opencode-agent-dir"
    typeset -gr _opencode_command_gist_description="opencode-command-dir"
    typeset -gr _opencode_tool_gist_description="opencode-tool-dir"
    typeset -gr _opencode_global_rules_gist_description="opencode-global-rules"
    typeset -gr _opencode_plugin_gist_description="opencode-plugin-dir"


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
