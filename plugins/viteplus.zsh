# Vite+ (unified web toolchain): https://viteplus.dev/
(( $+_viteplus_dir )) || typeset -gr _viteplus_dir="$HOME/.vite-plus"
(( $+_viteplus_env_file )) || typeset -gr _viteplus_env_file="$_viteplus_dir/env"

if [[ -f "$_viteplus_env_file" ]]; then
  builtin source "$_viteplus_env_file"
  exists vp || return

  uninstall-viteplus() {
    info "Uninstalling Vite+..."
    command env VP_HOME="$_viteplus_dir" vp implode --yes
    command rm -rf -- "$_viteplus_dir"
    reload
  }

  _update_viteplus() {
    info "Updating Vite+..."
    _lock_zshrc
    command env VP_HOME="$_viteplus_dir" VP_NODE_MANAGER=no vp upgrade
    _unlock_zshrc
  }

  update-viteplus() {
    _update_viteplus
    reload
  }

  updates+=(_update_viteplus)
else
  install-viteplus() {
    info "Installing Vite+..."
    _run_remote_installer "https://vite.plus" "bash" --env "VP_HOME=$_viteplus_dir" --env "VP_NODE_MANAGER=no"
    reload
  }
fi
