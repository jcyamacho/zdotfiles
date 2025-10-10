# ZIG (programming language): https://ziglang.org/
if (( ! $+commands[brew] )); then
  return
fi

if (( $+commands[zig] )); then
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
