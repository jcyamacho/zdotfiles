# OpenCode (AI coding agent built for the terminal): https://opencode.ai/
(( $+_opencode_dir )) || typeset -gr _opencode_dir="$HOME/.opencode"
(( $+_opencode_bin_dir )) || typeset -gr _opencode_bin_dir="$_opencode_dir/bin"

if [[ -d "$_opencode_bin_dir" ]]; then
  path=("$_opencode_bin_dir" "${path[@]}")

  exists opencode || return

  cache-completion opencode completion

  (( $+_opencode_config_dir )) || typeset -gr _opencode_config_dir="$HOME/.config/opencode"
  (( $+_opencode_settings_file )) || typeset -gr _opencode_settings_file="$_opencode_config_dir/opencode.json"
  (( $+_opencode_data_dir )) || typeset -gr _opencode_data_dir="$HOME/.local/share/opencode"

  alias oc="opencode"

  opencode-config() {
    [[ -d "$_opencode_config_dir" ]] || command mkdir -p -- "$_opencode_config_dir"
    [[ -f "$_opencode_settings_file" ]] || builtin print -r -- '{ "$schema": "https://opencode.ai/config.json" }' >| "$_opencode_settings_file"

    edit "$_opencode_config_dir"
  }

  uninstall-opencode() {
    info "Uninstalling opencode..."
    command rm -rf -- "$_opencode_dir"
    command rm -rf -- "$_opencode_config_dir"
    command rm -rf -- "$HOME/.cache/opencode"
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

    command rm -rf -- "$_opencode_data_dir/storage"
    info "All sessions cleared"
  }

  opencode-config-load-from-gist() {
    load-file-from-gist "${_opencode_settings_file}" "opencode-settings"
  }

  opencode-config-save-to-gist() {
    save-file-to-gist "${_opencode_settings_file}" "opencode-settings"
  }

else
  install-opencode() {
    info "Installing opencode..."
    _run_remote_installer "https://opencode.ai/install"
    reload
  }
fi
