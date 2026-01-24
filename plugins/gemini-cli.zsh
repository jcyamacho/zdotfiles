# Gemini CLI: https://github.com/google/gemini-cli

exists npm || return

if exists gemini; then
  _update_gemini() {
    info "Updating gemini..."
    command npm install -g @google/gemini-cli@latest > /dev/null
  }

  update-gemini() {
    _update_gemini
    reload
  }

  uninstall-gemini() {
    info "Uninstalling gemini..."
    command npm uninstall -g @google/gemini-cli > /dev/null
    reload
  }

  updates+=(_update_gemini)
else
  install-gemini() {
    info "Installing gemini..."
    command npm install -g @google/gemini-cli@latest > /dev/null
    reload
  }
fi
