# ZIG (programming language): https://ziglang.org/

if ! exists brew; then
  return
fi

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
