# python helpers (venv activation and cache cleanup): https://docs.python.org/3/library/venv.html

if exists python3; then
  alias py="python3"

  pyclean() {
    command find "${@:-.}" -type f -name "*.py[co]" -delete
    command find "${@:-.}" -depth -type d \( -name "__pycache__" -o -name ".mypy_cache" -o -name ".pytest_cache" \) -exec rm -rf -- "{}" +
  }

  venv() {
    (( $+functions[deactivate] )) && deactivate

    local venv_dir
    for venv_dir in .venv venv; do
      local activate_file="$PWD/${venv_dir}/bin/activate"
      if [[ -s "$activate_file" ]]; then
        builtin source "$activate_file"
        return 0
      fi
    done

    return 0
  }

  enable-venv-hook() {
    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd venv
    venv
  }
fi
