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

    local cwd=$PWD
    local venv_dirs=(".venv" "venv")

    for venv_dir in "${venv_dirs[@]}"; do
      local activate_file="${cwd}/${venv_dir}/bin/activate"
      if [[ -s $activate_file ]]; then
        source "$activate_file"
        break
      fi
    done
  }
fi

if ! exists uv; then
  alias install-python="install-uv"
  install-uv() {
    info "Installing uv..."
    command curl -LsSf https://astral.sh/uv/install.sh | command sh

    # Install Python
    if ! exists python; then
      info "Installing python..."
      uv python install --default --preview
    fi

    # Install Ruff: https://docs.astral.sh/ruff/
    if ! exists ruff; then
      info "Installing ruff..."
      uv tool install ruff@latest
    fi

    # Install BasedPyright: https://docs.basedpyright.com/latest/
    if ! exists basedpyright; then
      info "Installing basedpyright..."
      uv tool install basedpyright@latest
    fi

    # Install ty: https://docs.astral.sh/ty/
    if ! exists ty; then
      info "Installing ty..."
      uv tool install ty@latest
    fi

    reload
  }

  return
fi

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
  command rm -rf -- "$(uv python dir)"
  command rm -rf -- "$(uv tool dir)"
  command rm -f -- "$HOME/.local/bin/uv"
  command rm -f -- "$HOME/.local/bin/uvx"
  reload
}

updates+=(update-uv)
