# deno (JavaScript runtime): https://deno.land/
(( $+_deno_dir )) || typeset -gr _deno_dir="$HOME/.deno"
(( $+_deno_bin_dir )) || typeset -gr _deno_bin_dir="$_deno_dir/bin"

if [[ -d "$_deno_bin_dir" ]]; then
  path=("$_deno_bin_dir" "${path[@]}")

  exists deno || return

  uninstall-deno() {
    info "Uninstalling deno..."
    command rm -rf -- "$_deno_dir"
    reload
  }

  _update_deno() {
    info "Updating deno..."
    command deno upgrade
  }

  update-deno() {
    _update_deno
    reload
  }

  updates+=(_update_deno)
else
  install-deno() {
    info "Installing deno..."
    _run_remote_installer "https://deno.land/install.sh" "sh" --env "DENO_INSTALL=$_deno_dir" -- --no-modify-path -y
    reload
  }
fi
