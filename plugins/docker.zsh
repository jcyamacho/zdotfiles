# docker (containerization platform): https://www.docker.com/

if exists docker; then
  cache-completion docker completion zsh

  docker-run-it() {
    local image
    image="$(command docker build -q .)" || return
    command docker run --rm -it "$image"
  }

  uninstall-docker() {
    # The prune runs before brew removes the CLI, so a docker that brew does
    # not own must stop here instead of pruning and then failing.
    command brew list --formula docker &>/dev/null || {
      error "docker is not installed with Homebrew. Uninstall it with the tool that installed it."
      return 1
    }

    local docker_context
    docker_context="$(command docker context show 2>/dev/null)"
    if confirm "Prune Docker data (stopped containers, unused images and networks, build cache, and anonymous volumes) in context '${docker_context:-unknown}'?" no; then
      info "Pruning docker data..."
      command docker system prune --all --volumes --force || warn "Could not prune docker data"
    fi

    info "Uninstalling docker..."
    # Without --formula, Homebrew resolves `docker` to the docker-desktop cask.
    command brew uninstall --formula docker || return
    reload
  }
else
  install-docker() {
    info "Installing docker..."
    command brew install --no-ask docker || return
    reload
  }
fi
