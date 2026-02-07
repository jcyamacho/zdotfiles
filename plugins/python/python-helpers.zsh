# python helpers (venv + pytest ergonomics): https://docs.astral.sh/uv/

if exists python3; then
  alias py="python3"

  pyclean() {
    command find "${@:-.}" -type f -name "*.py[co]" -delete
    command find "${@:-.}" -type d -name "__pycache__" -delete
    command find "${@:-.}" -depth -type d -name ".mypy_cache" -exec rm -rf -- "{}" +
    command find "${@:-.}" -depth -type d -name ".pytest_cache" -exec rm -rf -- "{}" +
  }

  venv() {
    (( $+functions[deactivate] )) && deactivate

    local venv_dir
    for venv_dir in .venv venv; do
      local activate_file="$PWD/${venv_dir}/bin/activate"
      if [[ -s "$activate_file" ]]; then
        builtin source "$activate_file"
        return 0
      fi
    done

    return 0
  }

  pytest() {
    venv
    info "Running pytest..."
    command pytest "$@"
  }
fi

enable-venv-hook() {
  _python_hook_venv() {
    (( $+functions[venv] )) || return 0
    venv 2>/dev/null
  }

  add-zsh-hook chpwd _python_hook_venv
}
