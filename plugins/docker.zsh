# docker (containerization platform): https://www.docker.com/

if exists docker; then
  cache-completion docker completion zsh

  docker-run-it() {
    command docker run -it "$(command docker build -q .)"
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
