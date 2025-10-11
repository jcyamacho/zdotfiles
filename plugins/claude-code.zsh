# Claude Code CLI: https://www.anthropic.com/claude-code
export CLAUDE_CODE_PATH="$HOME/.claude"

if ! exists npm; then
  return
fi

_update_claude_agents() {
    info "Downloading agents..."

    local agents_catalog="$CLAUDE_CODE_PATH/_agents"
    local agents_path="$CLAUDE_CODE_PATH/agents"
    command mkdir -p "$agents_path"

    command rm -fr "$agents_catalog"
    git clone https://github.com/wshobson/agents.git "$agents_catalog"
    command rm "$agents_catalog/README.md"

    command cp -fv "$agents_catalog"/*.md "$agents_path/" > /dev/null
}

_update_commands() {
    info "Downloading commands..."

    local commands_catalog="$CLAUDE_CODE_PATH/_commands"
    local commands_path="$CLAUDE_CODE_PATH/commands"

    command mkdir -p "$commands_path/workflows"
    command mkdir -p "$commands_path/tools"

    command rm -fr "$commands_catalog"
    git clone https://github.com/wshobson/commands.git "$commands_catalog"

    command cp -fv "$commands_catalog/tools"/*.md "$commands_path/tools/" > /dev/null
    command cp -fv "$commands_catalog/workflows"/*.md "$commands_path/workflows/" > /dev/null
}

_install_claude() {
  npm install -g @anthropic-ai/claude-code@latest > /dev/null
  _update_claude_agents
  _update_commands
}

if exists claude; then
  update-claude() {
    info "Updating claude..."
    _install_claude
  }

  uninstall-claude() {
    info "Uninstalling claude..."
    npm uninstall -g @anthropic-ai/claude-code > /dev/null
    command rm -rf "$CLAUDE_CODE_PATH"
    reload
  }

  updates+=(update-claude)
else
  install-claude() {
    info "Installing claude code..."
    _install_claude
    reload
  }
fi
