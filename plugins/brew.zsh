# HOMEBREW (package manager for OSX): https://brew.sh/
export HOMEBREW_NO_ENV_HINTS=1

if ! exists brew; then
  info "Installing brew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

_update_brew() {
  info "Updating brew..."
  brew update
  info "Upgrading brew packages..."
  brew upgrade
  info "Cleaning up brew..."
  brew cleanup --prune=all
}

update-brew() {
  _update_brew
  reload
}

updates+=(_update_brew)
