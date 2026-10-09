# rust (programming language): https://www.rust-lang.org/
typeset -g _cargo_dir="$HOME/.cargo"

if [[ -f "$_cargo_dir/env" ]]; then
  builtin source "$_cargo_dir/env"

  exists rustup || return

  cache-completion rustup completions zsh
  # rustup prints the cargo completion stub, so the cache file is named _cargo
  # explicitly. The stub loads the active toolchain's _cargo.
  _cache_command_output "$_zdotfiles_completions_dir/_cargo" "${(%):-%x}" -- rustup completions zsh cargo

  uninstall-rust() {
    # rustup self uninstall deletes $_cargo_dir except the cargo-installed
    # binaries that newer releases keep, which the rm below removes. User files
    # cannot be kept, so the prompt guards the whole command.
    warn "This deletes $_cargo_dir, including crates.io credentials and cargo-installed binaries."
    confirm "Continue?" no || { info "Aborted"; return 0; }

    info "Uninstalling rust..."
    command rustup self uninstall -y || return
    info "Removing $_cargo_dir..."
    command rm -rf -- "$_cargo_dir"
    reload
  }

  _update_rust() {
    info "Updating rust..."
    command rustup update
  }

  update-rust() {
    _update_rust || return
    reload
  }

  updates+=(_update_rust)
else
  install-rust() {
    info "Installing rust..."
    _run_remote_installer "https://sh.rustup.rs" "sh" -- -y --no-modify-path || return
    reload
  }
fi
