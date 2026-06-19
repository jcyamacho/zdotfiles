# Pi (minimal terminal coding harness): https://pi.dev/
(( $+_pi_package )) || typeset -gr _pi_package="@earendil-works/pi-coding-agent"

export PI_TELEMETRY=0

if exists pi; then
  pi-config() {
    edit-open "${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}"
  }

  _update_pi() {
    info "Updating pi..."
    command pi update --all
  }

  update-pi() {
    _update_pi
    reload
  }

  updates+=(_update_pi)

  if exists npm; then
    uninstall-pi() {
      info "Uninstalling pi..."
      command npm uninstall -g "$_pi_package" > /dev/null
      reload
    }
  fi
elif exists npm; then
  install-pi() {
    info "Installing pi..."
    command npm install -g --ignore-scripts "$_pi_package" > /dev/null
    reload
  }
fi
