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
    command brew uninstall --cask ollama-app || return
    command rm -rf -- "$HOME/Library/Caches/ollama" \
      "$HOME/Library/Caches/com.electron.ollama" \
      "$HOME/Library/Caches/com.electron.ollama.ShipIt"

    local data_dir="$HOME/.ollama"
    if confirm "Delete Ollama models and keys in $data_dir?" no; then
      command rm -rf -- "$data_dir"
    fi

    reload
  }
else
  install-ollama() {
    info "Installing ollama..."
    command brew install --no-ask --cask ollama-app || return
    reload
  }
fi
