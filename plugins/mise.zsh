# MISE (dev tools, env vars, task runner): https://mise.jdx.dev/
_has_mise() {
  (( $+commands[mise] ))
}

if _has_mise; then
  uninstall-mise() {
    info "Uninstalling mise..."
    mise implode --yes
    reload
  }

  update-mise() {
    info "Updating mise..."
    mise self-update --yes
  }

  updates+=(update-mise)
else
  install-mise() {
    info "Installing mise..."
    curl https://mise.run | MISE_INSTALL_PATH="$CUSTOM_TOOLS_DIR/mise" sh > /dev/null
    reload
  }
fi
