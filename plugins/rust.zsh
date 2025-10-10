# RUST (programming language): https://www.rust-lang.org/
_has_rust() {
  (( $+commands[rustup] && $+commands[cargo] ))
}

export CARGO_DIR="$HOME/.cargo"

if [ -s "$CARGO_DIR/env" ]; then
  source "$CARGO_DIR/env"

  uninstall-rust() {
    info "Uninstalling rust..."
    rustup self uninstall -y
    info "Removing $CARGO_DIR..."
    command rm -rf "$CARGO_DIR"
    reload
  }

  update-rust() {
    info "Updating rust..."
    rustup update
  }

  updates+=(update-rust)
else
  install-rust() {
    info "Installing rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    reload
  }
fi
