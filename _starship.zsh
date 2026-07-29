# starship: https://starship.rs

unset ZSH_THEME

export STARSHIP_CONFIG="${STARSHIP_CONFIG:-$HOME/.config/starship.toml}"

update-starship() {
  _update_starship
  reload
}

_update_starship() {
  info "Updating starship..."
  _run_remote_installer "https://starship.rs/install.sh" "sh" -- --yes --bin-dir "$CUSTOM_TOOLS_DIR" > /dev/null
}

updates+=(_update_starship)

exists starship || {
  _update_starship
  reload
}

if [[ $TERM != dumb ]]; then
  source-cached-init starship init zsh
fi

alias starship-preset-nerd-fonts='starship preset nerd-font-symbols > "$STARSHIP_CONFIG"'
alias starship-preset-no-nerd-font='starship preset no-nerd-font > "$STARSHIP_CONFIG"'
alias starship-preset-plain-text='starship preset plain-text-symbols > "$STARSHIP_CONFIG"'

starship-preset-custom() {
  command cp -- "$ZDOTFILES_DIR/starship.toml" "$STARSHIP_CONFIG"
}

starship-config() {
  edit "$STARSHIP_CONFIG"
  reload
}
