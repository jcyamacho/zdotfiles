# starship: https://starship.rs

unset ZSH_THEME

export STARSHIP_CONFIG="${STARSHIP_CONFIG:-$HOME/.config/starship.toml}"
export STARSHIP_LOG="${STARSHIP_LOG:-error}"

update-starship() {
  _update_starship || return
  reload
}

_update_starship() {
  # A starship installed another way, such as with Homebrew, is updated by its
  # owner; a second copy here would shadow it.
  if exists starship && [[ ! -x "$CUSTOM_TOOLS_DIR/starship" ]]; then
    info "Skipping starship: it is not installed in $CUSTOM_TOOLS_DIR"
    return 0
  fi

  info "Updating starship..."
  _run_remote_installer "https://starship.rs/install.sh" "sh" -- --yes --bin-dir "$CUSTOM_TOOLS_DIR" > /dev/null
}

updates+=(_update_starship)

exists starship || _update_starship || return

if [[ $TERM != dumb ]]; then
  source-cached-init starship init zsh
fi

_starship_write_preset() {
  command mkdir -p -- "${STARSHIP_CONFIG:h}" || return
  command starship preset "${1:?_starship_write_preset: missing preset}" >| "$STARSHIP_CONFIG"
}

alias starship-preset-nerd-fonts='_starship_write_preset nerd-font-symbols'
alias starship-preset-no-nerd-font='_starship_write_preset no-nerd-font'
alias starship-preset-plain-text='_starship_write_preset plain-text-symbols'

starship-preset-custom() {
  command mkdir -p -- "${STARSHIP_CONFIG:h}" || return
  command cp -- "$ZDOTFILES_DIR/starship.toml" "$STARSHIP_CONFIG"
}

starship-config() {
  edit "$STARSHIP_CONFIG" || return
  reload
}
