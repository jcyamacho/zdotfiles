# Codex CLI: https://developers.openai.com/codex/cli
export CODEX_HOME="$HOME/.codex"
export CODEX_PROMPTS_DIR="$CODEX_HOME/prompts"
export CODEX_SECURE_MODE=1

if exists codex; then
  source-cached-init codex completion zsh

  cdx() {
    command codex --search --sandbox workspace-write --ask-for-approval on-request "$@"
  }

  codex-config() {
    edit "$CODEX_HOME"
  }

  codex-clear-archived-sessions() {
    local archive_dir="${CODEX_HOME:?}/archived_sessions"
    if [[ ! -d "$archive_dir" ]]; then
      warn "No archived sessions directory found at $archive_dir"
      return 0
    fi

    local -a archived_sessions
    archived_sessions=("$archive_dir"/*(N))
    if (( ${#archived_sessions[@]} == 0 )); then
      info "No archived sessions to remove in $archive_dir"
      return 0
    fi

    command rm -rf -- "${archived_sessions[@]}" || :
    info "Removed ${#archived_sessions[@]} archived session(s) from $archive_dir"
  }
fi

# prioritize brew install
if exists brew; then
  builtin source "$ZDOTFILES_DIR/plugins/codex/codex-brew.zsh"
elif exists npm; then
  builtin source "$ZDOTFILES_DIR/plugins/codex/codex-npm.zsh"
fi
