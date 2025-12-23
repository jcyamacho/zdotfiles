# RUST (programming language): https://www.rust-lang.org/

export CARGO_DIR="$HOME/.cargo"

if [[ -f $CARGO_DIR/env ]]; then
  builtin source "$CARGO_DIR/env"

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
    _run_remote_installer "https://sh.rustup.rs" "sh" -- -y
    reload
  }
fi
