# claude (Anthropic coding assistant): https://www.anthropic.com/claude-code
if exists claude; then
  typeset -g _claude_home="$HOME/.claude"

  uninstall-claude-code() {
    info "Uninstalling claude..."
    # The native installer always places its launcher here; another claude on
    # $PATH belongs to npm or Homebrew.
    command rm -f -- "$HOME/.local/bin/claude" || return
    command rm -rf -- "$HOME/.local/share/claude"

    local state_file="$HOME/.claude.json"
    local worktrees_dir="$HOME/.claude-worktrees"
    if confirm "Delete Claude Code data in $_claude_home, $state_file, and $worktrees_dir?" no; then
      command rm -rf -- "$_claude_home" "$state_file" "$state_file.backup" "$worktrees_dir"
    fi

    reload
  }

  claude-config() {
    edit "$_claude_home"
  }

  _update_claude_code() {
    info "Updating claude code..."
    command claude update
  }

  update-claude-code() {
    _update_claude_code || return
    reload
  }

  alias cc="CLAUDE_CODE_NO_FLICKER=1 command claude"

  updates+=(_update_claude_code)
else
  install-claude-code() {
    info "Installing claude code..."
    _run_remote_installer "https://claude.ai/install.sh" || return
    reload
  }
fi
