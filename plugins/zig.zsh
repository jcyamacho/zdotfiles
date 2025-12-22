# ZIG (programming language): https://ziglang.org/

exists brew || return

if exists zig; then
  uninstall-zig() {
    info "Uninstalling zig..."
    command brew uninstall zig
    reload
  }
else
  install-zig() {
    info "Installing zig..."
    command brew install zig
    reload
  }
fi
