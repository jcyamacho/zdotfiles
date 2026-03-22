# worktrunk (git worktree management): https://worktrunk.dev

(( $+_worktrunk_config_file )) || typeset -gr _worktrunk_config_file="$HOME/.config/worktrunk/config.toml"
(( $+_worktrunk_providers_dir )) || typeset -gr _worktrunk_providers_dir="$ZDOTFILES_DIR/plugins/worktrunk/config"

_wt_set_provider() {
  local provider="${1:?provider name required}"
  local provider_file="$_worktrunk_providers_dir/${provider}.toml"

  if [[ ! -f "$provider_file" ]]; then
    error "Unknown provider: $provider"
    return 1
  fi

  command mkdir -p -- "${_worktrunk_config_file:h}"
  command cp -- "$provider_file" "$_worktrunk_config_file"
  info "Worktrunk commit provider set to $provider"
}

if exists wt; then
  source-cached-init wt config shell init zsh

  alias wtl="wt list"
  alias wtm="wt merge"
  alias wts="wt switch"
  alias wtcm="wt step commit"

  wt-config() {
    command mkdir -p -- "${_worktrunk_config_file:h}"
    edit "$_worktrunk_config_file"
  }

  wt-commit-claude() { _wt_set_provider claude; }
  wt-commit-codex() { _wt_set_provider codex; }

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

    if exists claude; then
      _wt_set_provider claude
    elif exists codex; then
      _wt_set_provider codex
    fi

    reload
  }
fi
