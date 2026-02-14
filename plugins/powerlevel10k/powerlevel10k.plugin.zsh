# powerlevel10k (fast zsh prompt theme): https://github.com/romkatv/powerlevel10k

(( $+_p10k_config_file )) || typeset -gr _p10k_config_file="$HOME/.p10k.zsh"

# Apply the default config if none exists.
if [[ ! -f "$_p10k_config_file" ]]; then
  command cp -- "$ZDOTFILES_DIR/plugins/powerlevel10k/p10k.zsh" "$_p10k_config_file"
fi

# Source the user config (p10k expects this).
[[ -f "$_p10k_config_file" ]] && builtin source "$_p10k_config_file"

# Disable cloud-provider segments
typeset -g POWERLEVEL9K_GCLOUD_CONTENT_EXPANSION=
typeset -g POWERLEVEL9K_GCLOUD_VISUAL_IDENTIFIER_EXPANSION=
typeset -g POWERLEVEL9K_AWS_CONTENT_EXPANSION=
typeset -g POWERLEVEL9K_AWS_VISUAL_IDENTIFIER_EXPANSION=
typeset -g POWERLEVEL9K_AZURE_CONTENT_EXPANSION=
typeset -g POWERLEVEL9K_AZURE_VISUAL_IDENTIFIER_EXPANSION=

# Helpers -----------------------------------------------------------

p10k-preset-default() {
  command cp -- "$ZDOTFILES_DIR/plugins/powerlevel10k/p10k.zsh" "$_p10k_config_file"
  builtin source "$_p10k_config_file"
  p10k reload
}

p10k-config() {
  edit "$_p10k_config_file"
  builtin source "$_p10k_config_file"
  p10k reload
}

# Completions -------------------------------------------------------

_p10k() {
  local -a subcmds=(
    'configure:run interactive configuration wizard'
    'reload:reload configuration'
    'segment:print a user-defined prompt segment'
    'display:show, hide or toggle prompt parts'
    'finalize:finalize deferred initialization'
    'help:print help message'
  )
  _describe 'command' subcmds
}
compdef _p10k p10k
