# fabric (AI prompts framework): https://github.com/danielmiessler/fabric
exists fabric || {
  install-fabric() {
    info "Installing fabric..."
    _run_remote_installer "https://raw.githubusercontent.com/danielmiessler/fabric/main/scripts/installer/install.sh" \
      --env "INSTALL_DIR=$CUSTOM_TOOLS_DIR" || return
    info "Run 'fabric --setup' to configure API keys"
    reload
  }
  return
}

typeset -g _fabric_config_dir="$HOME/.config/fabric"

typeset _fabric_pattern
for _fabric_pattern in "$_fabric_config_dir/patterns"/*(N-/:t); do
  alias "$_fabric_pattern"="fabric --pattern ${(q)_fabric_pattern} --stream"
done
unset _fabric_pattern

yt() {
  local transcript_flag="--transcript"
  if [[ ${1-} == "-t" || ${1-} == "--timestamps" ]]; then
    transcript_flag="--transcript-with-timestamps"
    shift
  fi

  if (( $# != 1 )); then
    builtin print -r -- "Usage: yt [-t | --timestamps] youtube-link"
    builtin print -r -- "Use the '-t' flag to get the transcript with timestamps."
    return 1
  fi

  local video_link="$1"
  command fabric -y "$video_link" "$transcript_flag"
}

uninstall-fabric() {
  info "Uninstalling fabric..."
  command rm -f -- "$(whence -p fabric)" || return

  if confirm "Delete fabric config, API keys, and patterns in $_fabric_config_dir?" no; then
    command rm -rf -- "$_fabric_config_dir"
  fi

  reload
}

_update_fabric() {
  info "Updating fabric..."
  _run_remote_installer "https://raw.githubusercontent.com/danielmiessler/fabric/main/scripts/installer/install.sh" \
    --env "INSTALL_DIR=$CUSTOM_TOOLS_DIR"
}

update-fabric() {
  _update_fabric || return
  reload
}

updates+=(_update_fabric)

fabric-config() {
  edit-open "$_fabric_config_dir"
}
