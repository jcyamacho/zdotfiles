# ollama (Local tool for running LLMs): https://ollama.com/

if exists ollama; then
  update-ollama-models() {
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

  updates+=(update-ollama-models)

  uninstall-ollama() {
    info "Uninstalling ollama..."
    command pkill -x Ollama 2>/dev/null || true
    command rm -rf -- /Applications/Ollama.app
    command rm -f -- /usr/local/bin/ollama
    command rm -rf -- "$HOME/.ollama"
    reload
  }
else
  install-ollama() {
    info "Installing ollama..."
    _run_remote_installer "https://ollama.com/install.sh"
    reload
  }
fi
