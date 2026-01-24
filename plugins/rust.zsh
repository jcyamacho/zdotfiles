# rust (programming language): https://www.rust-lang.org/
(( $+_cargo_dir )) || typeset -gr _cargo_dir="$HOME/.cargo"

if [[ -f "$_cargo_dir/env" ]]; then
  builtin source "$_cargo_dir/env"

  uninstall-rust() {
    info "Uninstalling rust..."
    command rustup self uninstall -y
    info "Removing $_cargo_dir..."
    command rm -rf -- "$_cargo_dir"
    reload
  }

  _update_rust() {
    info "Updating rust..."
    command rustup update
  }

  update-rust() {
    _update_rust
    reload
  }

  updates+=(_update_rust)
else
  install-rust() {
    info "Installing rust..."
    _run_remote_installer "https://sh.rustup.rs" "sh" -- -y
    reload
  }
fi
