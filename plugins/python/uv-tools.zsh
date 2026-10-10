# python uv tools installers: https://docs.astral.sh/uv/concepts/tools/

_install_uv_tool() {
  info "Installing $1..."
  command uv tool install --force "$1@latest"
}

exists ruff || install-python-ruff() { _install_uv_tool ruff; }
exists basedpyright || install-python-basedpyright() { _install_uv_tool basedpyright; }
exists ty || install-python-ty() { _install_uv_tool ty; }
exists pyrefly || install-python-pyrefly() { _install_uv_tool pyrefly; }
