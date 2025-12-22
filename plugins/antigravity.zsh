# Antigravity (AI Editor): https://antigravity.google/
export ANTIGRAVITY_DIR="$HOME/.antigravity"
export ANTIGRAVITY_BIN="$ANTIGRAVITY_DIR/antigravity/bin/antigravity"

if [[ -f "$ANTIGRAVITY_BIN" ]]; then
  ag() {
    local dir="${1:-$PWD}"
    "$ANTIGRAVITY_BIN" -- "$dir"
  }
fi

exists brew || return

if [[ -f "$ANTIGRAVITY_BIN" ]]; then
  uninstall-antigravity() {
    info "Uninstalling antigravity..."
    command brew uninstall antigravity
    reload
  }
else
  install-antigravity() {
    info "Installing antigravity..."
    command brew install --cask antigravity
    reload
  }
fi
