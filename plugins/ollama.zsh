# ollama (Local tool for running LLMs): https://ollama.com/

_has_ollama() {
  (( $+commands[ollama] ))
}

if _has_ollama; then
  update-ollama-models() {
    info "Updating ollama models..."
    ollama list | awk 'NR>1 {print $1}' | while read package; do
        echo "Updating $package..."
        ollama pull "$package"
    done
  }

  updates+=(update-ollama-models)
fi

if ! _has_brew; then
  return
fi

if _has_ollama; then
  uninstall-ollama() {
    info "Uninstalling ollama..."
    brew uninstall ollama
  }
else
  install-ollama() {
    info "Installing ollama..."
    brew install ollama
  }
fi
