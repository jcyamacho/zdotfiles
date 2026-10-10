# Vite+ (web toolchain and Node.js version manager): https://viteplus.dev/
typeset -g _viteplus_dir="$HOME/.vite-plus"

update-node() {
  info "Installing latest LTS Node.js..."
  run-quiet vp env install node@lts || return

  local current_version
  current_version="$(command vp env exec --node lts node --version)" || return
  run-quiet vp env default "$current_version" || return
  run-quiet vp env on node || return

  info "Updating npm..."
  run-quiet vp env install npm@latest || return
  run-quiet vp env default npm@latest || return
  run-quiet vp env on npm || return

  info "Updating pnpm..."
  run-quiet vp env install pnpm@latest || return
  run-quiet vp env default pnpm@latest || return
  run-quiet vp env on pnpm || return

  # Keep the bun that install-bun manages ahead of the Vite+ bun shim.
  run-quiet vp env off bun
}

if [[ -f "$_viteplus_dir/env" ]]; then
  builtin source "$_viteplus_dir/env"
  exists vp || return

  alias install-node="update-node"

  uninstall-unused-node-versions() {
    confirm "Remove unused Vite+ Node.js versions?" no || { info "Aborted"; return 0; }
    command vp env clean node
  }

  uninstall-viteplus() {
    info "Uninstalling Vite+..."
    command env VP_HOME="$_viteplus_dir" vp implode --yes || return
    command rm -rf -- "$_viteplus_dir"
    reload
  }

  _update_viteplus() {
    info "Updating Vite+..."
    _run_with_zshrc_locked env VP_HOME="$_viteplus_dir" vp upgrade
  }

  update-viteplus() {
    _update_viteplus || return
    reload
  }

  updates+=(_update_viteplus update-node)
else
  alias install-node="install-viteplus"

  install-viteplus() {
    info "Installing Vite+..."
    _run_remote_installer "https://vite.plus" \
      --env "VP_HOME=$_viteplus_dir" --env "VP_NODE_MANAGER=yes" \
      --env "VP_PM_MANAGER=no" --env "VP_NPM_MANAGER=yes" \
      --env "VP_PNPM_MANAGER=yes" || return
    builtin source "$_viteplus_dir/env" || return
    update-node || return
    reload
  }
fi
