# go (Go programming language): https://golang.org/
# golangci-lint (Go linter): https://golangci-lint.run/

if exists go; then
  # change the default GOPATH from $HOME/go to $HOME/.go
  export GOPATH="$HOME/.go"

  command go telemetry off 2>/dev/null

  alias gmt="go mod tidy"

  gmi() {
    local namespace
    if [[ $PWD == *github.com/* ]]; then
      namespace="github.com/${PWD##*github.com/}"
    else
      namespace=${PWD:t}
    fi

    command go mod init "$namespace"

    if [[ ! -f main.go ]]; then
      command cp "$ZDOTFILES_DIR/plugins/golang/main.go" .
    fi
  }
fi

if ! exists brew; then
  return
fi

if exists go; then
  uninstall-go() {
    info "Uninstalling golangci-lint..."
    command brew uninstall golangci-lint

    info "Uninstalling go..."
    command brew uninstall go

    info "Removing $GOPATH..."
    command rm -rf -- "$GOPATH"

    reload
  }
else
  install-go() {
    info "Installing go..."
    command brew install go

    info "Installing golangci-lint..."
    command brew install golangci-lint

    reload
  }
fi
