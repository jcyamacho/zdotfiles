# docker (containerization platform): https://www.docker.com/

if exists docker; then
  docker-run-it() {
    command docker run -it "$(command docker build -q .)"
  }

  if exists brew; then
    uninstall-docker() {
      info "Uninstalling docker..."
      command brew uninstall docker
      reload
    }
  fi
elif exists brew; then
  install-docker() {
    info "Installing docker..."
    command brew install docker
    reload
  }
fi
