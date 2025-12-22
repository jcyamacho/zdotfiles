# rbenv (Ruby version manager): https://github.com/rbenv/rbenv

exists brew || return

_update_ruby() {
  info "Activating latest Ruby..."
  local latest_version="$(rbenv install -l | command grep -v - | command tail -1)"
  local actual_version="$(rbenv global)"

  if [[ $actual_version == "$latest_version" ]]; then
    info "Ruby $latest_version is already active."
    return
  fi

  info "Installing Ruby $latest_version..."
  rbenv install -s "$latest_version"

  rbenv global "$latest_version"
  info "Current Ruby version: $latest_version"
}

if exists rbenv; then
  source-cached-init rbenv init - --no-rehash zsh

  alias uninstall-ruby="uninstall-rbenv"
  uninstall-rbenv() {
    info "Uninstalling rbenv..."
    command brew uninstall rbenv
    command rm -rf -- "$HOME/.rbenv"
    clear-cached-init rbenv
    reload
  }

  uninstall-unused-ruby-versions() {
    local current_version="$(rbenv global)"
    info "Cleaning up unused Ruby versions (keeping $current_version)..."

    rbenv versions --bare | command grep -v "^$current_version$" | command grep -v "^system$" | while IFS= read -r version; do
      info "Removing Ruby $version..."
      rbenv uninstall --force "$version"
    done
  }

  alias update-ruby="_update_ruby"

  updates+=(_update_ruby)
else
  alias install-ruby="install-rbenv"
  install-rbenv() {
    info "Installing rbenv..."
    command brew install rbenv
    clear-cached-init rbenv
    _update_ruby
    reload
  }
fi
