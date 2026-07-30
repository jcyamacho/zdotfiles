# OpenCode (AI coding agent built for the terminal): https://opencode.ai/
typeset -g _opencode_dir="$HOME/.opencode"

if [[ -d "$_opencode_dir/bin" ]]; then
  path=("$_opencode_dir/bin" "${path[@]}")

  exists opencode || return

  cache-completion opencode completion

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
    command rm -rf -- "$_opencode_config_dir"
    command rm -rf -- "$HOME/.cache/opencode"
    command rm -rf -- "$_opencode_data_dir"
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

  opencode-clear-sessions() {
    warn "This will delete ALL opencode sessions and project data"
    confirm "Continue?" no || { info "Aborted"; return 0; }

    command rm -rf -- "$_opencode_data_dir/storage"
    info "All sessions cleared"
  }

  opencode-config-load-from-gist() {
    load-file-from-gist "$_opencode_config_dir/opencode.json" "opencode-settings"
  }

  opencode-config-save-to-gist() {
    save-file-to-gist "$_opencode_config_dir/opencode.json" "opencode-settings"
  }

else
  install-opencode() {
    info "Installing opencode..."
    _run_remote_installer "https://opencode.ai/install" || return
    reload
  }
fi
