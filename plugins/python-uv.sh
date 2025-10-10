# uv (An extremely fast Python package and project manager, written in Rust): https://docs.astral.sh/uv/
_has_uv() {
  (( $+commands[uv] ))
}

if _has_uv; then
  # Install Python
  if (( ! $+commands[python] )); then
    info "Installing python..."
    uv python install --default --preview
    uv python upgrade --preview
  fi

  # Install Ruff: https://docs.astral.sh/ruff/
  if (( ! $+commands[ruff] )); then
    info "Installing ruff..."
    uv tool install ruff@latest
  fi

  # Install BasedPyright: https://docs.basedpyright.com/latest/
  if (( ! $+commands[basedpyright] )); then
    info "Installing basedpyright..."
    uv tool install basedpyright@latest
  fi

  # Install ty: https://docs.astral.sh/ty/
  if (( ! $+commands[ty] )); then
    info "Installing ty..."
    uv tool install ty@latest
  fi

  alias py="python"

  act() {
    activate=(
      "$(pwd)/.venv/bin/activate"
      "$(pwd)/venv/bin/activate"
    )
    for venv in "${activate[@]}"; do
      if [ -s "$venv" ]; then
        source "$venv"
        return
      fi
    done
  }

  alias update-python="update-uv"
  update-uv() {
    info "Updating uv..."
    uv self update
    info "Updating python..."
    uv python upgrade --preview
    info "  - Updating ruff..."
    uv tool update ruff
    info "  - Updating basedpyright..."
    uv tool update basedpyright
    info "  - Updating ty..."
    uv tool update ty
  }

  alias uninstall-python="uninstall-uv"
  uninstall-uv() {
    info "Uninstalling uv..."
    uv cache clean
    command rm -rf "$(uv python dir)"
    command rm -rf "$(uv tool dir)"
    command rm "$HOME/.local/bin/uv"
    command rm "$HOME/.local/bin/uvx"
    reload
  }

  updates+=(update-uv)
else
  alias install-python="install-uv"
  install-uv() {
    info "Installing uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    reload
  }
fi
