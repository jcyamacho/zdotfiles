# Codex (CLI and ChatGPT desktop app): https://developers.openai.com/codex/cli
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

if [[ -d "$HOMEBREW_PREFIX/Caskroom/chatgpt" ]]; then
  uninstall-chatgpt() {
    # --zap must be chosen before the single brew call that removes the app.
    local -a zap=()
    if confirm "Delete ChatGPT desktop app data and sign-in in ~/Library?" no; then
      zap=(--zap)
    fi

    info "Uninstalling chatgpt..."
    command brew uninstall "${zap[@]}" --cask chatgpt || return

    # A plain uninstall leaves the caches the app downloaded.
    command rm -rf -- "$HOME/Library/Caches"/{Codex,com.openai.codex,com.openai.sky.CUAService}

    reload
  }
else
  install-chatgpt() {
    info "Installing chatgpt..."
    command brew install --no-ask --cask --adopt chatgpt || return
    reload
  }
fi

if [[ -d "$HOMEBREW_PREFIX/Caskroom/codex" ]]; then
  alias cdx="codex"

  codex-config() {
    edit "$CODEX_HOME"
  }

  codex-clear-archived-sessions() {
    local archive_dir="${CODEX_HOME:?}/archived_sessions"
    local -a archived_sessions
    archived_sessions=("$archive_dir"/*(N))
    if (( ${#archived_sessions[@]} == 0 )); then
      info "No archived sessions to remove in $archive_dir"
      return 0
    fi

    command rm -rf -- "${archived_sessions[@]}" || return
    info "Removed ${#archived_sessions[@]} archived session(s) from $archive_dir"
  }

  uninstall-codex() {
    info "Uninstalling codex..."
    command brew uninstall --cask codex || return

    if confirm "Delete Codex data in $CODEX_HOME, which the ChatGPT desktop app also uses?" no; then
      command rm -rf -- "$CODEX_HOME"
    fi

    reload
  }
else
  install-codex() {
    info "Installing codex..."
    command brew install --no-ask --cask --adopt codex || return
    # Codex refuses to start when the exported CODEX_HOME does not exist.
    command mkdir -p -- "$CODEX_HOME" || return
    reload
  }
fi
