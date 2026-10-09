# docker (containerization platform): https://www.docker.com/

if exists docker; then
  cache-completion docker completion zsh

  docker-run-it() {
    local image
    image="$(command docker build -q .)" || return
    command docker run -it "$image"
  }

  uninstall-docker() {
    info "Uninstalling docker..."
    command brew uninstall docker || return
    reload
  }
else
  install-docker() {
    info "Installing docker..."
    command brew install --no-ask docker || return
    reload
  }
fi
