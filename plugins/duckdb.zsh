# duckdb (embedded analytical SQL database): https://duckdb.org/

if exists duckdb; then
  alias ddb="duckdb"

  uninstall-duckdb() {
    info "Uninstalling duckdb..."
    command brew uninstall duckdb || return

    command rm -rf -- "$HOME/.duckdb/extensions"
    if confirm "Delete DuckDB history, startup file, and stored secrets in ~/.duckdb_history, ~/.duckdbrc, and ~/.duckdb?" no; then
      command rm -rf -- "$HOME/.duckdb_history" "$HOME/.duckdbrc" "$HOME/.duckdb"
    fi

    reload
  }
else
  install-duckdb() {
    info "Installing duckdb..."
    command brew install --no-ask duckdb || return
    reload
  }
fi
