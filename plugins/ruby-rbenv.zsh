# rbenv (Ruby version manager): https://github.com/rbenv/rbenv

update-ruby() {
  info "Activating latest Ruby..."

  local latest_version actual_version
  latest_version="$(rbenv install -l | command grep -v - | command tail -1)"
  if [[ -z "$latest_version" ]]; then
    error "Could not determine the latest Ruby version"
    return 1
  fi
  actual_version="$(rbenv global)" || return

  if [[ $actual_version == "$latest_version" ]]; then
    info "Ruby $latest_version is already active."
    return
  fi

  info "Installing Ruby $latest_version..."
  rbenv install -s "$latest_version" || return

  rbenv global "$latest_version" || return
  info "Current Ruby version: $latest_version"
}

if exists rbenv; then
  source-cached-init rbenv init - --no-rehash zsh

  uninstall-unused-ruby-versions() {
    local current_version
    current_version="$(rbenv global)" || return
    info "Cleaning up unused Ruby versions (keeping $current_version)..."

    rbenv versions --bare | command grep -v "^$current_version$" | command grep -v "^system$" | while IFS= read -r version; do
      info "Removing Ruby $version..."
      rbenv uninstall --force "$version"
    done
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
