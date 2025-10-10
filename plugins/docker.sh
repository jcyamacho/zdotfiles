_has_docker() {
  (( $+commands[docker] ))
}

if _has_docker; then
  return
fi

docker-run-it() {
  docker run -it "$(docker build -q .)"
}
