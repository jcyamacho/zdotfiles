# zig (programming language): https://ziglang.org/

if exists zig; then
  uninstall-zig() {
    info "Uninstalling zig..."
    command brew uninstall zig || return
    command rm -rf -- "${ZIG_GLOBAL_CACHE_DIR:-${XDG_CACHE_HOME:-$HOME/.cache}/zig}"
    reload
  }
else
  install-zig() {
    info "Installing zig..."
    command brew install --no-ask zig || return
    reload
  }
fi
