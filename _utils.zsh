autoload -Uz colors 2>/dev/null && colors

typeset -r _reset_color=${reset_color:-$'\e[0m'}

info() {
  print -r "${fg_bold[cyan]}$*$_reset_color"
}

warn() {
  print -r "${fg_bold[yellow]}$*$_reset_color"
}

error() {
  print -r "${fg_bold[red]}$*$_reset_color"
}

mkcd() {
  local target=${1:?mkcd: missing directory name}
  command mkdir -p "$target"
  builtin cd "$target"
}

exists() {
  (( $+commands[$1] ))
}

reload() {
  source "$ZDOTFILES_DIR/zshrc.sh"
}

is-macos() {
  [[ $OSTYPE == darwin* ]]
}

alias cls="clear"
alias rmf="rm -rf"
alias cd..="cd .."

home() {
  builtin cd "$HOME"
}

typeset -r _zshrc_file="$HOME/.zshrc"

_lock_zshrc() {
  command chmod -w "$_zshrc_file"
}

_unlock_zshrc() {
  command chmod +w "$_zshrc_file"
}

edit() {
  local -a editor_cmd
  if [[ -n $EDITOR ]]; then
    editor_cmd=("${(z)EDITOR}")
  else
    editor_cmd=(vim)
  fi
  "${editor_cmd[@]}" "$@"
}

zsh-config() {
  _unlock_zshrc
  edit "$_zshrc_file"
  reload
}

zsh-startup-profile() {
  ZDOTFILES_PROFILE_STARTUP=1 command time zsh -lic exit
}
