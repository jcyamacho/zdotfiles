_has_docker() {
  (( $+commands[docker] ))
}

if _has_docker; then
  docker-run-it() {
    docker run -it "$(docker build -q .)"
  }
fi
