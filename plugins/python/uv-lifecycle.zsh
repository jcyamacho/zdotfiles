# python uv lifecycle (install/update/uninstall): https://docs.astral.sh/uv/

if exists uv; then
  _get_latest_python_version() {
    command uv python list "$@" \
      | command awk '{print $1}' \
      | command grep -E '^cpython-[0-9]+\.[0-9]+\.[0-9]+-' \
      | command sort -V \
      | command tail -n1
  }

  _update_uv_python() {
    command uv python upgrade --preview

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

  _update_uv() {
    info "Updating uv..."
    command uv self update
    info "Updating python..."
    _update_uv_python
    info "Updating tools..."
    command uv tool upgrade --all
  }

  update-uv() {
    _update_uv
    reload
  }

  alias update-python="update-uv"

  uninstall-uv() {
    info "Uninstalling uv..."
    command uv cache clean

    local uv_python_dir="$(command uv python dir)"
    if [[ -n "$uv_python_dir" && "$uv_python_dir" == "$HOME"/* ]]; then
      command rm -rf -- "$uv_python_dir"
    fi

    local uv_tool_dir="$(command uv tool dir)"
    if [[ -n "$uv_tool_dir" && "$uv_tool_dir" == "$HOME"/* ]]; then
      command rm -rf -- "$uv_tool_dir"
    fi

    [[ -n ${commands[uv]-} ]] && command rm -f -- "${commands[uv]}"
    [[ -n ${commands[uvx]-} ]] && command rm -f -- "${commands[uvx]}"

    reload
  }

  alias uninstall-python="uninstall-uv"

  function venv-sync {
    local python_flag=()
    if [[ -n "${PYTHON_VERSION:-}" ]]; then
      python_flag=(--python "$PYTHON_VERSION")
    fi
    local venv_dir=${VENV_DIR:-".venv"}

    (( $+functions[deactivate] )) && deactivate

    # skip non-python projects
    if [[ ! -f pyproject.toml ]]; then
      warn "No Python project found."
      return
    fi

    # uv project
    if [[ -f uv.lock ]]; then
      UV_PROJECT_ENVIRONMENT="$venv_dir" command uv sync "${python_flag[@]}"
      builtin source "${venv_dir}/bin/activate"
      return
    fi

    # legacy repos
    if [[ ! -d "$venv_dir" ]]; then
      command uv venv "$venv_dir" "${python_flag[@]}" --seed
    fi

    builtin source "${venv_dir}/bin/activate"

    if [[ -f requirements-dev.txt ]]; then
      command uv pip install -r requirements-dev.txt
    elif [[ -f requirements.txt ]]; then
      command uv pip install -r requirements.txt
    fi
  }

  updates+=(_update_uv)
else
  alias install-python="install-uv"

  install-uv() {
    info "Installing uv..."
    _run_remote_installer "https://astral.sh/uv/install.sh"

    local uv_cmd="${commands[uv]-}"
    if [[ -z "$uv_cmd" ]]; then
      builtin rehash
      uv_cmd="${commands[uv]-}"
    fi

    if [[ -n "$uv_cmd" ]]; then
      info "Installing python..."
      command "$uv_cmd" python install --default --preview
    else
      warn "uv installed but not found in current shell; run reload, then 'uv python install --default --preview'"
    fi

    reload
  }
fi
