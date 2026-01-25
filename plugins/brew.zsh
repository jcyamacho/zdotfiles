# brew (package manager for macOS): https://brew.sh/
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_ANALYTICS=1

exists brew || {
  info "Installing brew..."
  _run_remote_installer "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh" "bash" --env "NONINTERACTIVE=1"
  reload
}

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
