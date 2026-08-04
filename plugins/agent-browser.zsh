# agent-browser (browser automation for AI agents): https://agent-browser.dev/

if exists agent-browser; then
  _update_agent_browser() {
    info "Updating agent-browser..."
    command agent-browser upgrade
  }

  update-agent-browser() {
    _update_agent_browser || return
    reload
  }

  updates+=(_update_agent_browser)

  if exists npm; then
    uninstall-agent-browser() {
      info "Uninstalling agent-browser..."

      command npm uninstall -g agent-browser > /dev/null || return
      command rm -rf -- "$HOME/.agent-browser"
      reload
    }
  fi
elif exists npm; then
  install-agent-browser() {
    info "Installing agent-browser..."

    command npm install -g --ignore-scripts agent-browser > /dev/null || return
    command agent-browser install ||
      warn "Chrome download failed; agent-browser will use an installed browser"
    reload
  }
fi
