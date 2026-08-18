# Codex CLI: https://developers.openai.com/codex/cli
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

if exists codex; then
  cache-completion codex completion zsh
  autoload -Uz _codex
  compdef _codex codex cdx

  cdx() {
    # Human launcher with opinionated terminal UX; use `codex` directly for scripting.
    local exit_code=0
    {
      builtin printf '%s' $'\e]11;#1e1e1e\a'
      command clear
      command codex "$@"
      exit_code=$?
    } always {
      builtin printf '%s' $'\e]111\a'
    }
    return $exit_code
  }

  codex-config() {
    edit-open "$CODEX_HOME"
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

if exists brew; then
  if exists codex; then
    uninstall-codex() {
      info "Uninstalling codex..."
      command brew uninstall --cask codex || return
      command rm -rf -- "$CODEX_HOME"
      reload
    }
  else
    install-codex() {
      info "Installing codex..."
      command brew install --no-ask --cask codex || return
      command mkdir -p -- "$CODEX_HOME/prompts"
      reload
    }
  fi
fi
