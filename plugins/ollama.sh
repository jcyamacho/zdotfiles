if (( ! $+commands[ollama] )); then
  return
fi

update-ollama-models() {
  info "Updating ollama models..."
  ollama list | awk 'NR>1 {print $1}' | while read package; do
      echo "Updating $package..."
      ollama pull "$package"
  done
}

updates+=(update-ollama-models)
