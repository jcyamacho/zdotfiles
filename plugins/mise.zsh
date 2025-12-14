# MISE (dev tools, env vars, task runner): https://mise.jdx.dev/

if exists mise; then
  uninstall-mise() {
    info "Uninstalling mise..."
    command mise implode --yes
    reload
  }

  update-mise() {
    info "Updating mise..."
    command mise self-update --yes
  }

  updates+=(update-mise)
else
  install-mise() {
    info "Installing mise..."
    command curl https://mise.run | MISE_INSTALL_PATH="$CUSTOM_TOOLS_DIR/mise" command sh > /dev/null
    reload
  }

  _mise_hook_precmd() {}
fi
