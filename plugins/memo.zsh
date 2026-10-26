# memo (durable memory CLI): https://github.com/jcyamacho/memo

if exists memo; then
  cache-completion memo completion zsh

  memo-config() {
    edit "$(command memo path)"
  }

  uninstall-memo() {
    local store_dir
    store_dir="$(command memo path)" || return

    info "Uninstalling memo..."
    command brew uninstall jcyamacho/tap/memo || return

    if confirm "Delete memo memories in $store_dir?" no; then
      command rm -rf -- "$store_dir"
    fi

    reload
  }
else
  install-memo() {
    info "Installing memo..."
    command brew install --no-ask jcyamacho/tap/memo || return

    exists claude && command memo hook claude
    exists codex && command memo hook codex

    reload
  }
fi
