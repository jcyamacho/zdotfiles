# python (uv-based Python tooling): https://docs.astral.sh/uv/

(( $+_python_plugin_dir )) || typeset -gr _python_plugin_dir="$ZDOTFILES_DIR/plugins/python"

builtin source "$_python_plugin_dir/python-helpers.zsh"
builtin source "$_python_plugin_dir/uv-lifecycle.zsh"

exists uv && builtin source "$_python_plugin_dir/uv-tools.zsh"
