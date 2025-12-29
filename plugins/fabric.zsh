# fabric (AI prompts framework): https://github.com/danielmiessler/fabric
exists fabric || {
  install-fabric() {
    info "Installing fabric..."
    _run_remote_installer "https://raw.githubusercontent.com/danielmiessler/fabric/main/scripts/installer/install.sh" "bash" \
      --env "INSTALL_DIR=$CUSTOM_TOOLS_DIR"
    info "Run 'fabric --setup' to configure API keys"
    reload
  }
  return
}

(( $+_fabric_config_dir )) || typeset -gr _fabric_config_dir="$HOME/.config/fabric"
(( $+_fabric_patterns_dir )) || typeset -gr _fabric_patterns_dir="$_fabric_config_dir/patterns"

_fabric_load_patterns() {
  [[ -d "$_fabric_patterns_dir" ]] || return
  local pattern_file
  local pattern_name
  for pattern_file in "$_fabric_patterns_dir"/*(N-.); do
    pattern_name="${pattern_file:t}"
    unalias "$pattern_name" 2>/dev/null || :
    alias "$pattern_name"="fabric --pattern ${(q)pattern_name} --stream"
  done
}

_fabric_load_patterns

yt() {
  if (( $# == 0 || $# > 2 )); then
    builtin print -r -- "Usage: yt [-t | --timestamps] youtube-link"
    builtin print -r -- "Use the '-t' flag to get the transcript with timestamps."
    return 1
  fi

  local transcript_flag="--transcript"
  if [[ $1 == "-t" || $1 == "--timestamps" ]]; then
    transcript_flag="--transcript-with-timestamps"
    shift
  fi

  local video_link="$1"
  command fabric -y "$video_link" "$transcript_flag"
}

uninstall-fabric() {
  info "Uninstalling fabric..."
  command rm -f -- "${commands[fabric]}"
  command rm -rf -- "$_fabric_config_dir"
  reload
}

update-fabric() {
  info "Updating fabric..."
  _run_remote_installer "https://raw.githubusercontent.com/danielmiessler/fabric/main/scripts/installer/install.sh" "bash" \
    --env "INSTALL_DIR=$CUSTOM_TOOLS_DIR"
}

updates+=(update-fabric)

fabric-config() {
  edit "$_fabric_config_dir"
}
