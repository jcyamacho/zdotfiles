# worktrunk (git worktree management): https://worktrunk.dev

if exists wt; then
  source-cached-init wt config shell init zsh

  if exists brew; then
    uninstall-worktrunk() {
      info "Uninstalling worktrunk..."
      command brew uninstall worktrunk
      reload
    }
  fi
elif exists brew; then
  install-worktrunk() {
    info "Installing worktrunk..."
    command brew install worktrunk
    reload
  }
fi
