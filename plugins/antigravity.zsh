# Antigravity (AI Editor): https://antigravity.google/
(( $+_antigravity_bin )) || typeset -gr _antigravity_bin="$HOME/.antigravity/antigravity/bin/antigravity"

if [[ -f "$_antigravity_bin" ]]; then
  ag() {
    local dir="${1:-$PWD}"
    "$_antigravity_bin" -- "$dir"
  }

  if exists brew; then
    uninstall-antigravity() {
      info "Uninstalling antigravity..."
      command brew uninstall antigravity
      reload
    }
  fi
elif exists brew; then
  install-antigravity() {
    info "Installing antigravity..."
    command brew install --cask antigravity
    reload
  }
fi
