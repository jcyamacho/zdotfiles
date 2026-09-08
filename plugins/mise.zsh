# mise (dev tools, env vars, task runner): https://mise.jdx.dev/

if exists mise; then
  # Activation includes the current PATH, so generate it for each session.
  builtin source <(command mise activate zsh)

  uninstall-mise() {
    info "Uninstalling mise..."
    command mise implode --yes || return
    reload
  }

  _update_mise() {
    info "Updating mise..."
    command mise self-update --yes
  }

  update-mise() {
    _update_mise || return
    reload
  }

  updates+=(_update_mise)
else
  install-mise() {
    info "Installing mise..."
    _run_remote_installer "https://mise.run" "sh" --env "MISE_INSTALL_PATH=$CUSTOM_TOOLS_DIR/mise" || return
    reload
  }

  # Stub functions to prevent errors when mise isn't installed but other plugins expect these hooks
  _mise_hook_precmd() {}
  _mise_hook_chpwd() {}
fi
