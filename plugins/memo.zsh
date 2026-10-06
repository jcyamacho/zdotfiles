# memo (durable memory CLI): https://github.com/jcyamacho/memo

if exists memo; then
  cache-completion memo completion zsh

  if exists brew; then
    uninstall-memo() {
      info "Uninstalling memo..."
      command brew uninstall jcyamacho/tap/memo || return
      reload
    }
  fi
elif exists brew; then
  install-memo() {
    info "Installing memo..."
    command brew install --no-ask jcyamacho/tap/memo || return
    reload
  }
fi
