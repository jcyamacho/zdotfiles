# fabric (AI prompts framework): https://github.com/danielmiessler/fabric
exists fabric || {
  install-fabric() {
    info "Installing fabric..."
    _run_remote_installer "https://raw.githubusercontent.com/danielmiessler/fabric/main/scripts/installer/install.sh" "bash" \
      --env "INSTALL_DIR=$CUSTOM_TOOLS_DIR" || return
    info "Run 'fabric --setup' to configure API keys"
    reload
  }
  return
}

typeset -g _fabric_config_dir="$HOME/.config/fabric"

_fabric_load_patterns() {
  [[ -d "$_fabric_config_dir/patterns" ]] || return
  local pattern_file
  local pattern_name
  for pattern_file in "$_fabric_config_dir/patterns"/*(N-.); do
    pattern_name="${pattern_file:t}"
    unalias "$pattern_name" || :
    alias "$pattern_name"="fabric --pattern ${(q)pattern_name} --stream"
  done
}

_fabric_load_patterns

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
  command rm -f -- "${commands[fabric]}" || return
  command rm -rf -- "$_fabric_config_dir"
  reload
}

_update_fabric() {
  info "Updating fabric..."
  _run_remote_installer "https://raw.githubusercontent.com/danielmiessler/fabric/main/scripts/installer/install.sh" "bash" \
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
