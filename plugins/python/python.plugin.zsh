# python (uv-based Python tooling): https://docs.astral.sh/uv/

builtin source "$ZDOTFILES_DIR/plugins/python/python-helpers.zsh"
builtin source "$ZDOTFILES_DIR/plugins/python/uv-lifecycle.zsh"

exists uv && builtin source "$ZDOTFILES_DIR/plugins/python/uv-tools.zsh"
