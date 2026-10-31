# python uv tools installers: https://docs.astral.sh/uv/concepts/tools/

_install_uv_tool() {
  info "Installing $1..."
  command uv tool install --force "$1@latest"
}

typeset _uv_tool_dir="${UV_TOOL_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/uv/tools}"

[[ -d "$_uv_tool_dir/ruff" ]] || install-python-ruff() { _install_uv_tool ruff; }
[[ -d "$_uv_tool_dir/basedpyright" ]] || install-python-basedpyright() { _install_uv_tool basedpyright; }
[[ -d "$_uv_tool_dir/ty" ]] || install-python-ty() { _install_uv_tool ty; }
[[ -d "$_uv_tool_dir/pyrefly" ]] || install-python-pyrefly() { _install_uv_tool pyrefly; }

unset _uv_tool_dir
