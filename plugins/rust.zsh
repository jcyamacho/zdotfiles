# RUST (programming language): https://www.rust-lang.org/

export CARGO_DIR="$HOME/.cargo"

if [[ -f $CARGO_DIR/env ]]; then
  source "$CARGO_DIR/env"

  uninstall-rust() {
    info "Uninstalling rust..."
    command rustup self uninstall -y

    info "Removing $CARGO_DIR..."
    command rm -rf -- "$CARGO_DIR"
    reload
  }

  update-rust() {
    info "Updating rust..."
    command rustup update
  }

  updates+=(update-rust)
else
  install-rust() {
    info "Installing rust..."
    command curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | command sh -s -- -y
    reload
  }
fi
