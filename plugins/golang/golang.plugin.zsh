# go (Go programming language): https://golang.org/
# golangci-lint (Go linter): https://golangci-lint.run/

_has_golang() {
  (( $+commands[go] ))
}

if _has_golang; then
  # change the default GOPATH from $HOME/go to $HOME/.go
  export GOPATH="$HOME/.go"

  go telemetry off

  alias gmt="go mod tidy"

  gmi() {
    local namespace=$(pwd | grep -o 'github.com.*')
    if [[ -z $namespace ]]; then
        namespace=$(basename "$(pwd)")
    fi

    go mod init $namespace

    if [ ! -f main.go ]; then
      command cp "$ZDOTFILES_DIR/plugins/golang/main.go" .
    fi
  }
fi

if ! _has_brew; then
  return
fi

if _has_golang; then
  uninstall-go() {
    info "Uninstalling golangci-lint..."
    brew uninstall golangci-lint
    info "Uninstalling go..."
    brew uninstall go
    info "Removing $GOPATH..."
    sudo rm -rf $GOPATH
    reload
  }
else
  install-go() {
    info "Installing go..."
    brew install go
    info "Installing golangci-lint..."
    brew install golangci-lint
    reload
  }
fi
