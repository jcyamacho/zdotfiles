# fonts (brew casks): https://brew.sh/
exists brew || return

install-fonts() {
  info "Installing fonts..."
  command brew install --no-ask --cask font-monaspace
  command brew install --no-ask --cask font-hack-nerd-font
  command brew install --no-ask --cask font-jetbrains-mono
  command brew install --no-ask --cask font-jetbrains-mono-nerd-font
  command brew install --no-ask --cask font-fira-code
  command brew install --no-ask --cask font-fira-code-nerd-font
}
