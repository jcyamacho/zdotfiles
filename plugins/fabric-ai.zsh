# fabric-ai (AI prompts framework): https://github.com/danielmiessler/fabric

if exists fabric-ai; then
  alias fabric="fabric-ai"

  export FABRIC_AI_DIR="$HOME/.config/fabric"
  export FABRIC_AI_PATTERNS_DIR="$FABRIC_AI_DIR/patterns"

  if [[ -d $FABRIC_AI_PATTERNS_DIR ]]; then
    local pattern_file
    local pattern_name
    for pattern_file in "$FABRIC_AI_PATTERNS_DIR"/*(N-.); do
      pattern_name=${pattern_file:t}
      unalias "$pattern_name" 2>/dev/null
      alias "$pattern_name"="fabric-ai --pattern ${(q)pattern_name} --stream"
    done
  fi

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
    command fabric-ai -y "$video_link" "$transcript_flag"
  }
fi

if ! exists brew; then
  return
fi

if exists fabric-ai; then
  uninstall-fabric-ai() {
    info "Uninstalling fabric-ai..."
    command brew uninstall fabric-ai
    command rm -rf -- "$FABRIC_AI_DIR"
    reload
  }
else
  install-fabric-ai() {
    info "Installing fabric-ai..."
    command brew install fabric-ai
    reload
  }
fi
