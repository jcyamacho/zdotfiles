# Herdr (agent multiplexer that lives in your terminal): https://herdr.dev/

exists brew || return

if exists herdr; then
  alias hdr="herdr"

  herdr-config() {
    local config_dir="$HOME/.config/herdr"

    command mkdir -p -- "$config_dir"
    edit-open "$config_dir"
  }

  uninstall-herdr() {
    info "Uninstalling Herdr..."
    command brew uninstall herdr
    reload
  }
else
  install-herdr() {
    info "Installing Herdr..."
    command brew install herdr
    reload
  }
fi
