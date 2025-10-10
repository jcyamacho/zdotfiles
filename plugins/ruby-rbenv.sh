# rbenv (Ruby version manager): https://github.com/rbenv/rbenv
_has_rbenv() {
  (( $+commands[rbenv] ))
}

_has_ruby() {
  (( $+commands[ruby] ))
}

if (( ! $+commands[brew] )); then
  return
fi

_update_ruby() {
  info "Activating latest Ruby..."
  local latest_version=$(rbenv install -l | grep -v - | tail -1)
  local actual_version=$(rbenv global)

  if [ "$actual_version" = "$latest_version" ]; then
    info "Ruby $latest_version is already active."
    return
  fi

  info "Installing Ruby $latest_version..."
  rbenv install -s "$latest_version"

  rbenv global "$latest_version"
  info "Current Ruby version: $latest_version"
}

if _has_rbenv; then
  eval "$(rbenv init - --no-rehash zsh)"

  alias uninstall-ruby="uninstall-rbenv"
  uninstall-rbenv() {
    info "Uninstalling rbenv..."
    brew uninstall rbenv
    rm -rf $HOME/.rbenv
    reload
  }

  uninstall-unused-ruby-versions() {
    local current_version=$(rbenv global)
    info "Cleaning up unused Ruby versions (keeping $current_version)..."

    rbenv versions --bare | grep -v "^$current_version$" | grep -v "^system$" | while read -r version; do
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
    brew install rbenv
    _update_ruby
    reload
  }
fi
