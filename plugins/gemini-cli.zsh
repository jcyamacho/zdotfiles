# Gemini CLI: https://github.com/google/gemini-cli
if ! exists npm; then
  return
fi

if exists gemini; then
  update-gemini() {
    info "Updating gemini..."
    command npm install -g @google/gemini-cli@latest > /dev/null
  }

  uninstall-gemini() {
    info "Uninstalling gemini..."
    command npm uninstall -g @google/gemini-cli > /dev/null
    reload
  }

  updates+=(update-gemini)
else
  install-gemini() {
    info "Installing gemini..."
    command npm install -g @google/gemini-cli@latest > /dev/null
    reload
  }
fi
