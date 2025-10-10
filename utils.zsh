autoload -Uz colors 2>/dev/null && colors

typeset -g _reset_color=${reset_color:-$'\e[0m'}

mkcd() {
  local target=${1:?mkcd: missing directory name}
  command mkdir -p -- "$target" || return
  builtin cd -- "$target"
}

reload() {
  source "$ZDOTFILES_DIR/zshrc.sh"
}

info() {
  print -r -- "${fg_bold[cyan]}$*${_reset_color}"
}

warn() {
  print -r -- "${fg_bold[yellow]}$*${_reset_color}"
}

error() {
  print -r -- "${fg_bold[red]}$*${_reset_color}"
}

is-macos() {
  [[ $OSTYPE == darwin* ]]
}

alias cls="clear"
alias rmf="rm -rf"
alias cd..="cd .."

home() {
  builtin cd -- "$HOME"
}

zshconfig() {
  $EDITOR --wait "$HOME/.zshrc"
  reload
}
