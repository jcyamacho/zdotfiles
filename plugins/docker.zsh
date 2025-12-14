# docker (containerization platform): https://www.docker.com/

if exists docker; then
  docker-run-it() {
    command docker run -it "$(command docker build -q .)"
  }
fi

if ! exists brew; then
  return
fi

if exists docker; then
  uninstall-docker() {
    info "Uninstalling docker..."
    command brew uninstall docker
    reload
  }
else
  install-docker() {
    info "Installing docker..."
    command brew install docker
    reload
  }
fi
