# openspec (OpenSpec CLI): https://openspec.dev/
typeset -g _openspec_package="@fission-ai/openspec"

if exists openspec; then
  export OPENSPEC_TELEMETRY=0

  # Sourced, not autoloaded from $fpath: the script only defines _openspec and
  # calls compdef, so autoloading it would waste the first Tab.
  source-cached-output openspec completion generate zsh

  alias osp="openspec"
  alias ospl="openspec list"
  alias osps="openspec list --specs"
  alias ospv="openspec validate --all --strict"

  openspec-init-opencode() { command openspec init --tools opencode "$@" }
  openspec-init-codex() { command openspec init --tools codex "$@" }
  openspec-init-claude() { command openspec init --tools claude "$@" }
  openspec-init-cursor() { command openspec init --tools cursor "$@" }
  openspec-init-gemini() { command openspec init --tools gemini "$@" }
  openspec-init-copilot() { command openspec init --tools github-copilot "$@" }

  if exists npm; then
    _update_openspec() {
      info "Updating openspec..."
      command npm install -g "$_openspec_package@latest" > /dev/null
    }

    update-openspec() {
      _update_openspec || return
      reload
    }

    uninstall-openspec() {
      info "Uninstalling openspec..."
      command npm uninstall -g "$_openspec_package" > /dev/null || return
      reload
    }

    updates+=(_update_openspec)
  fi
elif exists npm; then
  install-openspec() {
    info "Installing openspec..."
    command npm install -g "$_openspec_package@latest" > /dev/null || return
    reload
  }
fi
