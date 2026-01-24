# ollama (Local tool for running LLMs): https://ollama.com/

if exists ollama; then
  _update_ollama_models() {
    info "Updating ollama models..."
    local -a lines=("${(@f)$(command ollama list)}")
    local line package
    for line in "${lines[@]:1}"; do
      package="${line%% *}"
      [[ -n $package ]] || continue
      info "Updating $package..."
      command ollama pull "$package"
    done
  }

  update-ollama-models() {
    _update_ollama_models
  }

  updates+=(_update_ollama_models)

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
