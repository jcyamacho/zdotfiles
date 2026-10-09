# bash (GNU Bourne-Again SHell, current release from Homebrew): https://www.gnu.org/software/bash/

# macOS ships bash 3.2 in /bin, so `exists bash` is always true there.
# Guard on the Homebrew binary instead.
if [[ -x "$HOMEBREW_PREFIX/bin/bash" ]]; then
  # Homebrew's bin comes after /bin on $path, so put only the bash keg first.
  path=("$HOMEBREW_PREFIX/opt/bash/bin" "${path[@]}")

  uninstall-bash() {
    info "Uninstalling bash..."
    command brew uninstall bash || return
    reload
  }
else
  install-bash() {
    info "Installing bash..."
    command brew install --no-ask bash || return
    reload
  }
fi
