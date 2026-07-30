# deno (JavaScript runtime): https://deno.land/
typeset -g _deno_dir="$HOME/.deno"

if [[ -d "$_deno_dir/bin" ]]; then
  path=("$_deno_dir/bin" "${path[@]}")

  exists deno || return

  cache-completion deno completions zsh

  uninstall-deno() {
    info "Uninstalling deno..."
    command rm -rf -- "$_deno_dir" || return
    reload
  }

  _update_deno() {
    info "Updating deno..."
    command deno upgrade
  }

  update-deno() {
    _update_deno || return
    reload
  }

  updates+=(_update_deno)
else
  install-deno() {
    info "Installing deno..."
    _run_remote_installer "https://deno.land/install.sh" "sh" --env "DENO_INSTALL=$_deno_dir" -- --no-modify-path -y || return
    reload
  }
fi
