# fzf (command-line fuzzy finder): https://junegunn.github.io/fzf/

exists brew || return

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
