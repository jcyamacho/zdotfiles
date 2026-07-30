# OrbStack (Docker Desktop alternative): https://orbstack.dev/
if exists orb; then
  if [[ -d "/Applications/OrbStack.app/Contents/MacOS/xbin" ]]; then
    path=("/Applications/OrbStack.app/Contents/MacOS/xbin" "${path[@]}")
  fi

  if exists brew; then
    uninstall-orbstack() {
      warn "This will remove OrbStack and prune all unused Docker data, including volumes."
      confirm "Continue?" no || { info "Aborted"; return 0; }

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
      command brew uninstall --zap --cask orbstack || return
      reload
    }
  fi
elif exists brew; then
  install-orbstack() {
    info "Installing orbstack..."
    command brew install --no-ask --cask orbstack || return
    reload
  }
fi
