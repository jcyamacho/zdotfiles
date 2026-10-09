# brew (package manager for macOS): https://brew.sh/
export HOMEBREW_NO_ENV_HINTS=1
export HOMEBREW_NO_ANALYTICS=1

# Only login shells get Homebrew's bin from /etc/zprofile's path_helper, and
# its installer never touches $path, so probe the documented prefixes.
# Without this a non-login shell would fall through and reinstall Homebrew.
#
# Appended, not prepended: path_helper also puts Homebrew after the system and
# $CUSTOM_TOOLS_DIR entries, so a tool present in both resolves the same way
# whether or not the shell is a login shell.
_brew_add_to_path() {
  local prefix
  for prefix in /opt/homebrew /usr/local; do
    [[ -x "$prefix/bin/brew" ]] || continue
    path=("${path[@]}" "$prefix/bin")
    return 0
  done
  return 1
}

if ! exists brew && ! _brew_add_to_path; then
  info "Installing brew..."
  _run_remote_installer "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh" "bash" || return
  _brew_add_to_path || return
fi

# Unquoted on purpose: equals expansion does not happen inside double quotes.
export HOMEBREW_PREFIX=${${:-=brew}:h:h}

# Homebrew's completions must be on $fpath before compinit runs, which is why
# this file is sourced from zshrc.sh instead of loaded as a plugin.
fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" "${fpath[@]}")

# Homebrew's shellenv only adds bin, but some formulae install into sbin and
# `brew doctor` warns when it is missing.
path=("${path[@]}" "$HOMEBREW_PREFIX/sbin")

_update_brew() {
  info "Updating brew..."
  command brew update || return
  info "Upgrading brew packages..."
  command brew upgrade --no-ask --greedy || return
  info "Cleaning up brew..."
  command brew cleanup --prune=all
}

update-brew() {
  _update_brew || return
  reload
}

updates+=(_update_brew)
