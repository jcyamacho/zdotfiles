# fonts
if ! _has_brew; then
  return
fi

install-fonts() {
  info "Installing fonts..."
  brew install --cask font-monaspace
  brew install --cask font-hack-nerd-font
  brew install --cask font-jetbrains-mono
  brew install --cask font-jetbrains-mono-nerd-font
}
