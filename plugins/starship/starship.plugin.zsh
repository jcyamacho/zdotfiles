unset ZSH_THEME

export STARSHIP_CONFIG_FILE="$HOME/.config/starship.toml"

update-starship() {
  _update_starship
  reload
}

_update_starship() {
  info "Updating starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$CUSTOM_TOOLS_DIR" > /dev/null
}

updates+=(_update_starship)

if ! exists starship; then
  _update_starship
  reload
fi

eval "$(starship init zsh)"

alias starship-preset-nerd-fonts='starship preset nerd-font-symbols > "$STARSHIP_CONFIG_FILE"'
alias starship-preset-no-nerd-font='starship preset no-nerd-font > "$STARSHIP_CONFIG_FILE"'
alias starship-preset-plain-text='starship preset plain-text-symbols > "$STARSHIP_CONFIG_FILE"'

starship-preset-custom() {
  command cp "$ZDOTFILES_DIR/plugins/starship/starship.toml" "$STARSHIP_CONFIG_FILE"
}

starshipconfig() {
  $EDITOR --wait "$STARSHIP_CONFIG_FILE"
  reload
}
