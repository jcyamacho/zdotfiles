# worktrunk (git worktree management): https://worktrunk.dev

if exists wt; then
  (( $+_worktrunk_config_file )) || typeset -gr _worktrunk_config_file="$HOME/.config/worktrunk/config.toml"

  source-cached-init wt config shell init zsh

  alias wtl="wt list"
  alias wtm="wt merge"
  alias wts="wt switch"
  alias wtcm="wt step commit"

  wt-config() {
    command mkdir -p -- "${_worktrunk_config_file:h}"
    edit "$_worktrunk_config_file"
  }

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
