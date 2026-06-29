# OrbStack (Docker Desktop alternative): https://orbstack.dev/
(( $+_orbstack_xbin_dir )) || typeset -gr _orbstack_xbin_dir="/Applications/OrbStack.app/Contents/MacOS/xbin"

if exists orb; then
  if [[ -d "$_orbstack_xbin_dir" ]]; then
    path=("$_orbstack_xbin_dir" "${path[@]}")
  fi

  if exists brew; then
    uninstall-orbstack() {
      if exists docker; then
        local docker_context
        docker_context="$(command docker context show 2>/dev/null)"

        if [[ "$docker_context" == orbstack ]]; then
          info "Pruning orbstack docker data..."
          command docker system prune --all --volumes --force
        else
          warn "Skipping docker system prune because current Docker context is '${docker_context:-unknown}', not 'orbstack'"
        fi
      else
        warn "Skipping docker system prune because docker is not available"
      fi

      info "Uninstalling orbstack..."
      command brew uninstall --zap --cask orbstack
      reload
    }
  fi
elif exists brew; then
  install-orbstack() {
    info "Installing orbstack..."
    command brew install --cask orbstack
    reload
  }
fi
