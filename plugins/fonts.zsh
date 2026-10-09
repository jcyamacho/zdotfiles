# fonts (brew casks): https://brew.sh/

install-fonts() {
  info "Installing fonts..."
  command brew install --no-ask --cask \
    font-monaspace \
    font-hack-nerd-font \
    font-jetbrains-mono \
    font-jetbrains-mono-nerd-font \
    font-fira-code \
    font-fira-code-nerd-font
}
