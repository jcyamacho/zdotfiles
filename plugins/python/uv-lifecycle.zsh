# python uv lifecycle (install/update/uninstall): https://docs.astral.sh/uv/

exists brew || return

if exists uv; then
  # uvx ships with uv and takes its own completion flag spelling.
  cache-completion uv generate-shell-completion zsh
  cache-completion uvx --generate-shell-completion zsh

  _get_latest_python_version() {
    command uv python list "$@" \
      | command awk '{print $1}' \
      | command grep -E '^cpython-[0-9]+\.[0-9]+\.[0-9]+-' \
      | command sort -V \
      | command tail -n1
  }

  _update_uv_python() {
    command uv python upgrade --preview || return

    local latest="$(_get_latest_python_version --only-downloads)"
    if [[ -z "$latest" ]]; then
      warn "No downloadable python version found."
      return 0
    fi

    local installed="$(_get_latest_python_version --only-installed)"
    if [[ "$latest" != "$installed" ]]; then
      info "Installing new version: $latest..."
      command uv python install "$latest" --default --preview
    fi
  }

  _update_uv_resources() {
    info "Updating python..."
    _update_uv_python || return
    info "Updating tools..."
    command uv tool upgrade --all
  }

  update-uv() {
    info "Updating uv..."
    command brew upgrade --no-ask uv || return
    _update_uv_resources || return
    reload
  }

  alias update-python="update-uv"

  uninstall-uv() {
    info "Uninstalling uv..."
    command uv cache clean

    local uv_python_dir="$(command uv python dir)"
    local uv_tool_dir="$(command uv tool dir)"

    command brew uninstall uv || return

    if [[ -n "$uv_python_dir" && "$uv_python_dir" == "$HOME"/* ]]; then
      command rm -rf -- "$uv_python_dir"
    fi

    if [[ -n "$uv_tool_dir" && "$uv_tool_dir" == "$HOME"/* ]]; then
      command rm -rf -- "$uv_tool_dir"
    fi

    reload
  }

  alias uninstall-python="uninstall-uv"

  function venv-sync {
    local python_flag=()
    if [[ -n "${PYTHON_VERSION:-}" ]]; then
      python_flag=(--python "$PYTHON_VERSION")
    fi
    local venv_dir=${VENV_DIR:-".venv"}

    # skip non-python projects
    if [[ ! -f pyproject.toml ]]; then
      warn "No Python project found."
      return
    fi

    (( $+functions[deactivate] )) && deactivate

    # uv project
    if [[ -f uv.lock ]]; then
      UV_PROJECT_ENVIRONMENT="$venv_dir" command uv sync "${python_flag[@]}" || return
      builtin source "${venv_dir}/bin/activate" || return
      return
    fi

    # legacy repos
    if [[ ! -d "$venv_dir" ]]; then
      command uv venv "$venv_dir" "${python_flag[@]}" --seed || return
    fi

    builtin source "${venv_dir}/bin/activate" || return

    if [[ -f requirements-dev.txt ]]; then
      command uv pip install -r requirements-dev.txt
    elif [[ -f requirements.txt ]]; then
      command uv pip install -r requirements.txt
    fi
  }

  updates+=(_update_uv_resources)
else
  alias install-python="install-uv"

  install-uv() {
    info "Installing uv..."
    command brew install --no-ask uv || return
    builtin rehash

    info "Installing python..."
    command uv python install --default --preview || return

    reload
  }
fi
