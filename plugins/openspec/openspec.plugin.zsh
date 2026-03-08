# openspec (OpenSpec CLI): https://openspec.dev/
(( $+_openspec_package )) || typeset -gr _openspec_package="@fission-ai/openspec"

if exists openspec; then
  cache-completion openspec completion generate zsh

  alias osp="openspec"
  alias ospl="openspec list"
  alias osps="openspec list --specs"
  alias ospv="openspec validate --all --strict"

  _openspec_init() {
    local tool="${1:?_openspec_init: missing tool}"
    shift
    command openspec init --tools "$tool" "$@"
  }

  openspec-init-opencode() { _openspec_init opencode "$@" }
  openspec-init-codex() { _openspec_init codex "$@" }
  openspec-init-claude() { _openspec_init claude "$@" }
  openspec-init-cursor() { _openspec_init cursor "$@" }
  openspec-init-gemini() { _openspec_init gemini "$@" }
  openspec-init-copilot() { _openspec_init github-copilot "$@" }

  if exists npm; then
    _update_openspec() {
      info "Updating openspec..."
      command npm install -g "$_openspec_package@latest" > /dev/null
    }

    update-openspec() {
      _update_openspec
      reload
    }

    uninstall-openspec() {
      info "Uninstalling openspec..."
      command npm uninstall -g "$_openspec_package" > /dev/null
      reload
    }

    updates+=(_update_openspec)
  fi
elif exists npm; then
  install-openspec() {
    info "Installing openspec..."
    command npm install -g "$_openspec_package@latest" > /dev/null
    reload
  }
fi
