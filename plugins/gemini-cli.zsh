# Gemini CLI: https://github.com/google/gemini-cli
_has_gemini() {
  (( $+commands[gemini] ))
}

if ! _has_npm; then
  return
fi

if _has_gemini; then
  update-gemini() {
    info "Updating gemini..."
    npm install -g @google/gemini-cli@latest  > /dev/null
  }

  uninstall-gemini() {
    info "Uninstalling gemini..."
    npm uninstall -g @google/gemini-cli  > /dev/null
    reload
  }

  updates+=(update-gemini)
else
  install-gemini() {
    info "Installing gemini..."
    npm install -g @google/gemini-cli@latest  > /dev/null
    reload
  }
fi
