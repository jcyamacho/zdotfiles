# MISE (dev tools, env vars, task runner): https://mise.jdx.dev/

if exists mise; then
  source-cached-init mise activate zsh

  uninstall-mise() {
    info "Uninstalling mise..."
    command mise implode --yes
    clear-cached-init mise
    reload
  }

  update-mise() {
    info "Updating mise..."
    command mise self-update --yes
    clear-cached-init mise
  }

  updates+=(update-mise)
else
  install-mise() {
    info "Installing mise..."
    command curl https://mise.run | MISE_INSTALL_PATH="$CUSTOM_TOOLS_DIR/mise" command sh > /dev/null
    reload
  }

  _mise_hook_precmd() {}

  _mise_hook_chpwd() {}
fi
