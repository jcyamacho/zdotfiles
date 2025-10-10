# ZIG (programming language): https://ziglang.org/

_has_zig() {
  (( $+commands[zig] ))
}

if ! _has_brew; then
  return
fi

if _has_zig; then
  uninstall-zig() {
    info "Uninstalling zig..."
    brew uninstall zig
    reload
  }
else
  install-zig() {
    info "Installing zig..."
    brew install zig
    reload
  }
fi
