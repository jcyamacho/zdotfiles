# agent-browser (browser automation for AI agents): https://agent-browser.dev/

if exists agent-browser; then
  _update_agent_browser() {
    info "Updating agent-browser..."
    command agent-browser upgrade
  }

  update-agent-browser() {
    _update_agent_browser
    reload
  }

  updates+=(_update_agent_browser)

  if exists npm; then
    uninstall-agent-browser() {
      info "Uninstalling agent-browser..."

      command npm uninstall -g agent-browser > /dev/null
      command rm -rf -- "$HOME/.agent-browser"
      reload
    }
  fi
elif exists npm; then
  install-agent-browser() {
    info "Installing agent-browser..."

    command npm install -g agent-browser > /dev/null
    command agent-browser install
    reload
  }
fi
