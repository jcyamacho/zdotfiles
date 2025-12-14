# HOMEBREW (package manager for OSX): https://brew.sh/
export HOMEBREW_NO_ENV_HINTS=1

if ! exists brew; then
  info "Installing brew..."
  /bin/bash -c "$(command curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

_update_brew() {
  info "Updating brew..."
  command brew update
  info "Upgrading brew packages..."
  command brew upgrade --greedy
  info "Cleaning up brew..."
  command brew cleanup --prune=all
}

update-brew() {
  _update_brew
  reload
}

updates+=(_update_brew)
