# ollama (Local tool for running LLMs): https://ollama.com/

if exists ollama; then
  update-ollama-models() {
    info "Updating ollama models..."
    local output
    output="$(command ollama list)" || return

    local -a lines=("${(@f)output}")
    local line package result=0
    for line in "${lines[@]:1}"; do
      package="${line%% *}"
      [[ -n $package ]] || continue
      info "Updating $package..."
      command ollama pull "$package" || result=1
    done
    return $result
  }

  updates+=(update-ollama-models)

  uninstall-ollama() {
    info "Uninstalling ollama..."
    command pkill -x Ollama 2>/dev/null || :
    command rm -rf -- /Applications/Ollama.app || return
    command rm -f -- /usr/local/bin/ollama 2>/dev/null || warn "Could not remove /usr/local/bin/ollama"

    local data_dir="$HOME/.ollama"
    if confirm "Delete Ollama models and keys in $data_dir?" no; then
      command rm -rf -- "$data_dir"
    fi

    reload
  }
else
  install-ollama() {
    info "Installing ollama..."
    _run_remote_installer "https://ollama.com/install.sh" || return
    reload
  }
fi
