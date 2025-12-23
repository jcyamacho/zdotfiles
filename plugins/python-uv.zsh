# uv (An extremely fast Python package and project manager, written in Rust): https://docs.astral.sh/uv/

if exists python; then
  alias py="python3"

  pyclean() {
    command find "${@:-.}" -type f -name "*.py[co]" -delete
    command find "${@:-.}" -type d -name "__pycache__" -delete
    command find "${@:-.}" -depth -type d -name ".mypy_cache" -exec rm -rf -- "{}" +
    command find "${@:-.}" -depth -type d -name ".pytest_cache" -exec rm -rf -- "{}" +
  }

  venv() {
    (( $+functions[deactivate] )) && deactivate

    local venv_dirs=(".venv" "venv")

    for venv_dir in "${venv_dirs[@]}"; do
      local activate_file="$PWD/${venv_dir}/bin/activate"
      if [[ -s $activate_file ]]; then
        builtin source "$activate_file"
        break
      fi
    done
  }

  pytest() {
    venv
    info "Running pytest..."
    command pytest "$@"
  }
fi

enable-venv-hook() {
  _hook_venv() {
    venv 2>/dev/null
  }

  add-zsh-hook chpwd _hook_venv
}

exists uv || {
  alias install-python="install-uv"
  install-uv() {
    info "Installing uv..."
    _run_remote_installer "https://astral.sh/uv/install.sh"

    info "Installing python..."
    uv python install --default --preview

    # Install Ruff: https://docs.astral.sh/ruff/
    info "Installing ruff..."
    uv tool install ruff@latest

    # Install BasedPyright: https://docs.basedpyright.com/latest/
    info "Installing basedpyright..."
    uv tool install basedpyright@latest

    # Install ty: https://docs.astral.sh/ty/
    info "Installing ty..."
    uv tool install ty@latest

    reload
  }

  return
}

_get_latest_python_version() {
  # Extract and return the latest stable cpython version from uv python list output
  uv python list "$@" \
    | command awk '{print $1}' \
    | command grep -E '^cpython-[0-9]+\.[0-9]+\.[0-9]+-' \
    | command sort -V \
    | command tail -n1
}

_update_python() {
  # update installed python versions
  uv python upgrade --preview

  # get latest downloadable stable version (exclude prereleases)
  local latest="$(_get_latest_python_version --only-downloads)"

  if [[ -z $latest ]]; then
    warn "No downloadable python version found."
    return
  fi

  # get latest installed version
  local installed="$(_get_latest_python_version --only-installed)"

  if [[ $latest != "$installed" ]]; then
    info "Installing new version: $latest..."
    uv python install "$latest" --default --preview
  fi
}

alias update-python="update-uv"
update-uv() {
  info "Updating uv..."
  uv self update
  info "Updating python..."
  _update_python
  info "Updating ruff..."
  uv tool update ruff
  info "Updating basedpyright..."
  uv tool update basedpyright
  info "Updating ty..."
  uv tool update ty
}

alias uninstall-python="uninstall-uv"
uninstall-uv() {
  info "Uninstalling uv..."
  uv cache clean

  local uv_python_dir="$(uv python dir)"
  if [[ -n $uv_python_dir && $uv_python_dir == "$HOME"/* ]]; then
    command rm -rf -- "$uv_python_dir"
  fi

  local uv_tool_dir="$(uv tool dir)"
  if [[ -n $uv_tool_dir && $uv_tool_dir == "$HOME"/* ]]; then
    command rm -rf -- "$uv_tool_dir"
  fi

  command rm -f -- "$HOME/.local/bin/uv"
  command rm -f -- "$HOME/.local/bin/uvx"
  reload
}

updates+=(update-uv)
