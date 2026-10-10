# rbenv (Ruby version manager): https://github.com/rbenv/rbenv

update-ruby() {
  local latest_version
  latest_version="$(rbenv install -l | command grep -v - | command tail -1)"
  if [[ -z "$latest_version" ]]; then
    error "Could not determine the latest Ruby version"
    return 1
  fi

  info "Activating Ruby $latest_version..."
  rbenv install -s "$latest_version" || return
  rbenv global "$latest_version"
}

if exists rbenv; then
  source-cached-output rbenv init - --no-rehash zsh

  uninstall-unused-ruby-versions() {
    local current_version
    current_version="$(rbenv global)" || return
    confirm "Remove every Ruby version except $current_version?" no || { info "Aborted"; return 0; }
    info "Cleaning up unused Ruby versions (keeping $current_version)..."

    local version failed=0
    for version in ${${(f)"$(rbenv versions --bare)"}:#$current_version}; do
      info "Removing Ruby $version..."
      rbenv uninstall --force "$version" || failed=1
    done
    return "$failed"
  }

  updates+=(update-ruby)

  alias uninstall-ruby="uninstall-rbenv"
  uninstall-rbenv() {
    info "Uninstalling rbenv..."
    command brew uninstall rbenv || return
    command rm -rf -- "$HOME/.rbenv"
    reload
  }
else
  alias install-ruby="install-rbenv"
  install-rbenv() {
    info "Installing rbenv..."
    command brew install --no-ask rbenv || return
    update-ruby || return
    reload
  }
fi
