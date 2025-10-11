# ollama (Local tool for running LLMs): https://ollama.com/

if exists ollama; then
  update-ollama-models() {
    info "Updating ollama models..."
    ollama list | awk 'NR>1 {print $1}' | while read package; do
        info "Updating $package..."
        ollama pull "$package"
    done
  }

  updates+=(update-ollama-models)
fi

if ! exists brew; then
  return
fi

if exists ollama; then
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
