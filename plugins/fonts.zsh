# fonts
if ! exists brew; then
  return
fi

install-fonts() {
  info "Installing fonts..."
  command brew install --cask font-monaspace
  command brew install --cask font-hack-nerd-font
  command brew install --cask font-jetbrains-mono
  command brew install --cask font-jetbrains-mono-nerd-font
  command brew install --cask font-fira-code
  command brew install --cask font-fira-code-nerd-font
}
