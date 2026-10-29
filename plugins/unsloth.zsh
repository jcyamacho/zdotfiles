# Unsloth (desktop app to run and fine-tune local LLMs): https://unsloth.ai/docs
if [[ -d "/Applications/Unsloth.app" ]]; then
  uninstall-unsloth() {
    local unsloth_dir="$HOME/.unsloth"
    local studio_dir="$unsloth_dir/studio"

    # --zap must be chosen before the single brew call that removes the app.
    local -a zap=()
    if confirm "Delete Unsloth chats, checkpoints, exports, and app data in $studio_dir and ~/Library?" no; then
      zap=(--zap)
    fi

    info "Uninstalling unsloth..."
    command brew uninstall "${zap[@]}" --cask unsloth || return

    # A plain uninstall leaves the backend the app downloaded, and neither path
    # removes the runtimes or the CLI link the backend installer adds.
    command rm -rf -- "$studio_dir/unsloth_studio" "$studio_dir/cache" \
      "$unsloth_dir"/{llama.cpp,node,whisper.cpp,audio.cpp,stable-diffusion.cpp,.cache,.staging} \
      "$unsloth_dir"/.*.install.lock(N) \
      "$HOME/Library/Caches/ai.unsloth.studio"
    [[ -L "$HOME/.local/bin/unsloth" ]] && command rm -f -- "$HOME/.local/bin/unsloth"
    # Fails, and keeps the directory, while it holds Studio data the user kept.
    command rmdir -- "$unsloth_dir" 2>/dev/null

    reload
  }
elif exists uv; then
  # Without uv on $path, the app's backend installer puts its own uv in
  # ~/.local/bin, where the python plugin would take it for its Homebrew uv.
  install-unsloth() {
    info "Installing unsloth..."
    command brew install --no-ask --cask --adopt unsloth || return
    reload
  }
fi
