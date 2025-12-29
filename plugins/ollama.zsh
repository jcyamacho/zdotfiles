# ollama (Local tool for running LLMs): https://ollama.com/

if exists ollama; then
  update-ollama-models() {
    info "Updating ollama models..."
    command ollama list | command awk 'NR>1 {print $1}' | while IFS= read -r package; do
      [[ -n $package ]] || continue
      info "Updating $package..."
      command ollama pull "$package"
    done
  }

  updates+=(update-ollama-models)

  if exists brew; then
    uninstall-ollama() {
      info "Uninstalling ollama..."
      command brew uninstall ollama
      reload
    }
  fi
elif exists brew; then
  install-ollama() {
    info "Installing ollama..."
    command brew install ollama
    builtin rehash
    reload
  }
fi
