# Claude (desktop app and Claude Code terminal agent): https://claude.com/download
if [[ -d "/Applications/Claude.app" ]]; then
  typeset -g _claude_desktop_dir="$HOME/Library/Application Support/Claude"

  claude-desktop-config() {
    edit "$_claude_desktop_dir/claude_desktop_config.json"
  }

  uninstall-claude-desktop() {
    # --zap must be chosen before the single brew call that removes the app.
    local -a zap=()
    if confirm "Delete Claude desktop sessions, settings, MCP servers, and sign-in in $_claude_desktop_dir and ~/Library?" no; then
      zap=(--zap)
    fi

    info "Uninstalling claude desktop..."
    command brew uninstall "${zap[@]}" --cask claude || return

    # A plain uninstall leaves the Claude Code builds, VM image, and caches the
    # app downloaded.
    command rm -rf -- "$_claude_desktop_dir"/{claude-code,claude-code-vm,Cache,"Code Cache",GPUCache} \
      "$HOME/Library/Caches"/com.anthropic.claudefordesktop{,.ShipIt}

    reload
  }
else
  install-claude-desktop() {
    info "Installing claude desktop..."
    command brew install --no-ask --cask claude || return
    reload
  }
fi

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
    if confirm "Delete Claude Code data in $_claude_home, $state_file, and $worktrees_dir, which the Claude desktop app also uses?" no; then
      command rm -rf -- "$_claude_home" "$state_file" "$state_file.backup" "$worktrees_dir"
    fi

    reload
  }

  claude-code-config() {
    edit "$_claude_home"
  }

  claude-code-settings-load-from-gist() {
    load-file-from-gist "$_claude_home/settings.json" "claude-code-settings"
  }

  claude-code-settings-save-to-gist() {
    save-file-to-gist "$_claude_home/settings.json" "claude-code-settings"
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
  alias cc-config="claude-code-config"

  updates+=(_update_claude_code)
else
  install-claude-code() {
    info "Installing claude code..."
    _run_remote_installer "https://claude.ai/install.sh" || return
    reload
  }
fi
