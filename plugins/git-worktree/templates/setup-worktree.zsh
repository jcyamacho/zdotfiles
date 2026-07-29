# Setup script for new git worktrees. Sourced, not executed, by `gwt <branch>`
# after it creates one: zsh syntax is available, and any state it changes
# persists in the shell you land in.
#
# Available environment variables:
#   $ROOT_WORKTREE_PATH — absolute path to the main (bare/root) worktree
#
# Examples:
#   - Copy local config:  cp "$ROOT_WORKTREE_PATH/.env" .env
#   - Install deps:       npm install
#   - Link node_modules:  ln -sfn "$ROOT_WORKTREE_PATH/node_modules" node_modules

claude_settings=".claude/settings.local.json"
if [[ -f "${ROOT_WORKTREE_PATH}/${claude_settings}" ]]; then
  mkdir -p ".claude"
  ln -sf "${ROOT_WORKTREE_PATH}/${claude_settings}" "${claude_settings}"
fi
