# fzf (command-line fuzzy finder): https://junegunn.github.io/fzf/

if ! exists brew; then
  return
fi

if exists fzf; then
  uninstall-fzf() {
    info "Uninstalling fzf..."
    command brew uninstall fzf
    reload
  }
else
  install-fzf() {
    info "Installing fzf..."
    command brew install fzf
    reload
  }
fi
