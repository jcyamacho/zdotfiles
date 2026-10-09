# claude (Anthropic coding assistant): https://www.anthropic.com/claude-code
if exists claude; then
  export DISABLE_TELEMETRY=1

  typeset -g _claude_home="$HOME/.claude"

  uninstall-claude-code() {
    info "Uninstalling claude..."
    command rm -f -- "$(whence -p claude)" || return
    command rm -rf -- "$HOME/.local/share/claude"

    local worktrees_dir="$HOME/.claude-worktrees"
    if confirm "Delete Claude Code data in $_claude_home and $worktrees_dir?" no; then
      command rm -rf -- "$_claude_home" "$worktrees_dir"
    fi

    reload
  }

  claude-config() {
    edit-open "$_claude_home"
  }

  _update_claude_code() {
    info "Updating claude code..."
    command claude update
  }

  update-claude-code() {
    _update_claude_code || return
    reload
  }

  cc() {
    # Human launcher with opinionated terminal UX; use `claude` directly for scripting.
    CLAUDE_CODE_NO_FLICKER=1 command claude "$@"
  }

  updates+=(_update_claude_code)
else
  install-claude-code() {
    info "Installing claude code..."
    _run_remote_installer "https://claude.ai/install.sh" "bash" || return
    reload
  }
fi
