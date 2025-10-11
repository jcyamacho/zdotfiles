# docker (containerization platform): https://www.docker.com/

if exists docker; then
  docker-run-it() {
    docker run -it "$(docker build -q .)"
  }
fi

if ! exists brew; then
  return
fi

if exists docker; then
  uninstall-docker() {
    brew uninstall docker
  }
else
  install-docker() {
    brew install docker
  }
fi
