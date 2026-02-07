# python uv tools installers: https://docs.astral.sh/uv/concepts/tools/

exists ruff || install-python-ruff() {
  info "Installing ruff..."
  command uv tool install --force ruff@latest
}

exists basedpyright || install-python-basedpyright() {
  info "Installing basedpyright..."
  command uv tool install --force basedpyright@latest
}

exists ty || install-python-ty() {
  info "Installing ty..."
  command uv tool install --force ty@latest
}

exists pyrefly || install-python-pyrefly() {
  info "Installing pyrefly..."
  command uv tool install --force pyrefly@latest
}
