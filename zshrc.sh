export ZDOTFILES_DIR="${ZDOTFILES_DIR:-$HOME/.zdotfiles}"
export EDITOR="${EDITOR:-zed}"

typeset -gU path
typeset -gU fpath

# CUSTOM_TOOLS_DIR
export CUSTOM_TOOLS_DIR="${CUSTOM_TOOLS_DIR:-$HOME/.local/bin}"
[[ -d $CUSTOM_TOOLS_DIR ]] || command mkdir -p -- "$CUSTOM_TOOLS_DIR"
path=("$CUSTOM_TOOLS_DIR" $path)
# CUSTOM_TOOLS_DIR end

# UTILS
source "$ZDOTFILES_DIR/_utils.zsh"
# UTILS end

# UPDATES
typeset -gUa updates

_update_zdotfiles() {
  info "Updating zdotfiles..."
  command git -C "$ZDOTFILES_DIR" pull --ff-only
}

update-zdotfiles() {
  _update_zdotfiles
  reload
}

updates+=(_update_zdotfiles)

update-all() {
  for update in "${updates[@]}"; do
    $update
    print
  done

  reload
}
# UPDATES end

# ANTIDOTE
export ANTIDOTE_DIR="${ANTIDOTE_DIR:-$HOME/.antidote}"
export ANTIDOTE_HOME="${ANTIDOTE_HOME:-$HOME/.cache/antidote}"
[[ -d $ANTIDOTE_DIR ]] || command git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"

# Lazy-load antidote from its functions directory.
fpath=("$ANTIDOTE_DIR/functions" $fpath)
autoload -Uz antidote

# Set the root name of the plugins files (.txt and .zsh) antidote will use.
local zsh_plugins="${ZDOTFILES_DIR}/.zsh_plugins"

# Generate a new static file whenever .zsh_plugins.txt is updated.
if [[ ! "${zsh_plugins}.zsh" -nt "${zsh_plugins}.txt" ]]; then
  info "Generating static plugins file..."
  antidote bundle < "${zsh_plugins}.txt" >| "${zsh_plugins}.zsh"
fi

# Source your static plugins file.
source "${zsh_plugins}.zsh"
unset zsh_plugins

_antidote_update() {
  info "Updating antidote..."
  antidote update
}

update-antidote() {
  _antidote_update
  reload
}

updates+=(_antidote_update)
# ANTIDOTE end
