# FABRIC_AI (AI prompts framework): https://github.com/danielmiessler/fabric

if ! exists brew; then
  return
fi

if exists fabric-ai; then
  alias fabric="fabric-ai"

  export FABRIC_AI_DIR="$HOME/.config/fabric"
  export FABRIC_AI_PATTERNS_DIR="$FABRIC_AI_DIR/patterns"

  if [ -d "$FABRIC_AI_PATTERNS_DIR" ]; then
    # Loop through all files in the ~/.config/fabric-ai/patterns directory
    for pattern_file in "$FABRIC_AI_PATTERNS_DIR/*"; do
      # Get the base name of the file (i.e., remove the directory path)
      pattern_name=$(basename "$pattern_file")

      # Remove any existing alias with the same name
      unalias "$pattern_name" 2>/dev/null

      # Create an alias
      eval "
      alias $pattern_name="fabric --pattern $pattern_name --stream"
      "
    done
  fi

  uninstall-fabric-ai() {
    info "Uninstalling fabric-ai..."
    brew uninstall fabric-ai
    command rm -rf "$FABRIC_AI_DIR"
    reload
  }

  yt() {
    if [ "$#" -eq 0 ] || [ "$#" -gt 2 ]; then
      print "Usage: yt [-t | --timestamps] youtube-link"
      print "Use the '-t' flag to get the transcript with timestamps."
      return 1
    fi

    local transcript_flag="--transcript"
    if [ "$1" = "-t" ] || [ "$1" = "--timestamps" ]; then
      transcript_flag="--transcript-with-timestamps"
      shift
    fi
    local video_link="$1"
    fabric -y "$video_link" $transcript_flag
  }
else
  install-fabric-ai() {
    info "Installing fabric-ai..."
    brew install fabric-ai
    reload
  }
fi
