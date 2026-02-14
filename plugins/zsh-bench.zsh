# zsh-bench (benchmark for interactive zsh): https://github.com/romkatv/zsh-bench

(( $+_zsh_bench_dir )) || typeset -gr _zsh_bench_dir="$ZDOTFILES_CACHE_DIR/zsh-bench"

if exists zsh-bench; then
  uninstall-zsh-bench() {
    info "Uninstalling zsh-bench..."
    command rm -f -- "$CUSTOM_TOOLS_DIR/zsh-bench"
    command rm -rf -- "$_zsh_bench_dir"
    reload
  }

  _update_zsh_bench() {
    info "Updating zsh-bench..."
    command git -C "$_zsh_bench_dir" pull --quiet
  }

  update-zsh-bench() {
    _update_zsh_bench
    reload
  }

  updates+=(_update_zsh_bench)
else
  install-zsh-bench() {
    info "Installing zsh-bench..."
    command git clone --quiet --depth=1 https://github.com/romkatv/zsh-bench.git "$_zsh_bench_dir" \
      && command ln -sf -- "$_zsh_bench_dir/zsh-bench" "$CUSTOM_TOOLS_DIR/zsh-bench"
    reload
  }
fi
