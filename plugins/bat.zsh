# BAT (A cat(1) clone with wings): https://github.com/sharkdp/bat

exists brew || return

if exists bat; then
  # suffix aliases for popular file extensions
  typeset -a _bat_exts=(
    # text/docs
    txt md markdown rst

    # config
    json jsonc yaml yml toml ini cfg conf xml

    # shell
    sh bash zsh fish

    # web
    html htm css scss sass less
    js mjs cjs jsx ts mts cts tsx vue svelte

    # systems
    c h cpp hpp cc cxx rs go zig

    # scripting
    py pyw rb pl pm lua

    # jvm
    java kt kts scala groovy gradle

    # data
    csv sql graphql

    # devops
    dockerfile tf hcl

    # misc
    diff patch log env
  )
  for _ext in "${_bat_exts[@]}"; do
    alias -s "$_ext"="bat"
  done
  unset _ext _bat_exts

  uninstall-bat() {
    info "Uninstalling bat..."
    command brew uninstall bat
    reload
  }
else
  install-bat() {
    info "Installing bat..."
    command brew install bat
    reload
  }
fi
