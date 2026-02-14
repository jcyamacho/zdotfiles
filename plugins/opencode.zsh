# OpenCode (AI coding agent built for the terminal): https://opencode.ai/
(( $+_opencode_dir )) || typeset -gr _opencode_dir="$HOME/.opencode"
(( $+_opencode_bin_dir )) || typeset -gr _opencode_bin_dir="$_opencode_dir/bin"

if [[ -d "$_opencode_bin_dir" ]]; then
  path=("$_opencode_bin_dir" "${path[@]}")

  exists opencode || return

  cache-completion opencode completion

  (( $+_opencode_config_dir )) || typeset -gr _opencode_config_dir="$HOME/.config/opencode"
  (( $+_opencode_agent_dir )) || typeset -gr _opencode_agent_dir="$_opencode_config_dir/agent"
  (( $+_opencode_command_dir )) || typeset -gr _opencode_command_dir="$_opencode_config_dir/command"
  (( $+_opencode_tool_dir )) || typeset -gr _opencode_tool_dir="$_opencode_config_dir/tool"
  (( $+_opencode_plugin_dir )) || typeset -gr _opencode_plugin_dir="$_opencode_config_dir/plugin"
  (( $+_opencode_settings_file )) || typeset -gr _opencode_settings_file="$_opencode_config_dir/opencode.json"
  (( $+_opencode_global_rules_file )) || typeset -gr _opencode_global_rules_file="$_opencode_config_dir/AGENTS.md"
  (( $+_opencode_cache_dir )) || typeset -gr _opencode_cache_dir="$HOME/.cache/opencode"
  (( $+_opencode_data_dir )) || typeset -gr _opencode_data_dir="$HOME/.local/share/opencode"
  (( $+_opencode_storage_dir )) || typeset -gr _opencode_storage_dir="$_opencode_data_dir/storage"

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
    command rm -rf -- "$_opencode_dir"
    command rm -rf -- "$_opencode_config_dir"
    command rm -rf -- "$_opencode_cache_dir"
    command rm -rf -- "$_opencode_data_dir"
    reload
  }

  _update_opencode() {
    info "Updating opencode..."
    _lock_zshrc
    command opencode upgrade
    _unlock_zshrc
  }

  update-opencode() {
    _update_opencode
    reload
  }

  updates+=(_update_opencode)

  opencode-clear-sessions() {
    warn "This will delete ALL opencode sessions and project data"
    builtin print -n "Continue? [y/N] "
    local response
    builtin read -r response
    [[ $response == [yY] ]] || { info "Aborted"; return 0; }

    command rm -rf -- "$_opencode_storage_dir"
    info "All sessions cleared"
  }

  (( $+_opencode_settings_gist_description )) || typeset -gr _opencode_settings_gist_description="opencode-settings"
  (( $+_opencode_agent_gist_description )) || typeset -gr _opencode_agent_gist_description="opencode-agent-dir"
  (( $+_opencode_command_gist_description )) || typeset -gr _opencode_command_gist_description="opencode-command-dir"
  (( $+_opencode_tool_gist_description )) || typeset -gr _opencode_tool_gist_description="opencode-tool-dir"
  (( $+_opencode_global_rules_gist_description )) || typeset -gr _opencode_global_rules_gist_description="opencode-global-rules"
  (( $+_opencode_plugin_gist_description )) || typeset -gr _opencode_plugin_gist_description="opencode-plugin-dir"

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

else
  install-opencode() {
    info "Installing opencode..."
    _run_remote_installer "https://opencode.ai/install"
    reload
  }
fi
