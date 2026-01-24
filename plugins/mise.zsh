# mise (dev tools, env vars, task runner): https://mise.jdx.dev/

if exists mise; then
  source-cached-init mise activate zsh

  uninstall-mise() {
    info "Uninstalling mise..."
    command mise implode --yes
    clear-cached-init mise
    reload
  }

  _update_mise() {
    info "Updating mise..."
    command mise self-update --yes
    clear-cached-init mise
  }

  update-mise() {
    _update_mise
    reload
  }

  updates+=(_update_mise)
else
  install-mise() {
    info "Installing mise..."
    _run_remote_installer "https://mise.run" "sh" --env "MISE_INSTALL_PATH=$CUSTOM_TOOLS_DIR/mise"
    reload
  }

  # Stub functions to prevent errors when mise isn't installed but other plugins expect these hooks
  _mise_hook_precmd() {}
  _mise_hook_chpwd() {}
fi
