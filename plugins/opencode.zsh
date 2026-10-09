# OpenCode (AI coding agent built for the terminal): https://opencode.ai/
typeset -g _opencode_dir="$HOME/.opencode"

if [[ -x "$_opencode_dir/bin/opencode" ]]; then
  path=("$_opencode_dir/bin" "${path[@]}")

  # Sourced, not autoloaded from $fpath: a stray quote in the yargs script's
  # autoload check makes it only call compdef, which would waste the first Tab.
  source-cached-init opencode completion

  typeset -g _opencode_config_dir="$HOME/.config/opencode"
  typeset -g _opencode_data_dir="$HOME/.local/share/opencode"

  alias oc="opencode"

  opencode-config() {
    [[ -d "$_opencode_config_dir" ]] || command mkdir -p -- "$_opencode_config_dir"
    [[ -f "$_opencode_config_dir/opencode.json" ]] \
      || builtin print -r -- '{ "$schema": "https://opencode.ai/config.json" }' >| "$_opencode_config_dir/opencode.json"

    edit-open "$_opencode_config_dir"
  }

  uninstall-opencode() {
    info "Uninstalling opencode..."
    command rm -rf -- "$_opencode_dir" || return
    command rm -rf -- "$HOME/.cache/opencode"

    local state_dir="$HOME/.local/state/opencode"
    if confirm "Delete opencode config, sessions, credentials, and history in $_opencode_config_dir, $_opencode_data_dir, and $state_dir?" no; then
      command rm -rf -- "$_opencode_config_dir" "$_opencode_data_dir" "$state_dir"
    fi

    reload
  }

  _update_opencode() {
    info "Updating opencode..."
    _run_with_zshrc_locked opencode upgrade
  }

  update-opencode() {
    _update_opencode || return
    reload
  }

  updates+=(_update_opencode)

  opencode-config-load-from-gist() {
    load-file-from-gist "$_opencode_config_dir/opencode.json" "opencode-settings"
  }

  opencode-config-save-to-gist() {
    save-file-to-gist "$_opencode_config_dir/opencode.json" "opencode-settings"
  }

else
  install-opencode() {
    info "Installing opencode..."
    _run_remote_installer "https://opencode.ai/install" "bash" -- --no-modify-path || return
    reload
  }
fi
