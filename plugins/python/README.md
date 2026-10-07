# python

Shell helpers for Python virtual environments and cache cleanup, plus commands
that manage [uv](https://docs.astral.sh/uv/), its Python versions, and Python
developer tools.

## Python Helpers

These commands exist when `python3` is on `PATH`.

| Command | Description |
| --- | --- |
| `py` | Alias for `python3` |
| `pyclean [dir...]` | Delete `*.pyc` and `*.pyo` files and `__pycache__`, `.mypy_cache`, and `.pytest_cache` directories under each `dir` (default: current directory) |
| `venv` | Deactivate any active virtual environment, then activate `.venv` or `venv` from the current directory, preferring `.venv` |
| `enable-venv-hook` | Run `venv` now and after every directory change |

`venv` looks only in the current directory. With the hook enabled, entering a
directory without `.venv` or `venv`, including a project subdirectory,
deactivates the environment.

To enable the hook in every shell, call it after the `source` line in
`~/.zshrc`:

```zsh
source "${ZDOTFILES_DIR:-$HOME/.zdotfiles}/zshrc.sh"
enable-venv-hook
```

## uv Lifecycle

Homebrew owns the uv binary, and uv manages Python versions and tools.
`install-uv` and `install-python` exist while uv is missing. The other commands
exist once uv is installed.

| Command | Description |
| --- | --- |
| `install-uv` | Install uv with Homebrew and the latest Python with uv, then reload |
| `update-uv` | Upgrade uv, Python, and uv tools, then reload |
| `uninstall-uv` | Uninstall uv and delete its cache, Python versions, and tools, then reload |
| `install-python` | Alias for `install-uv` |
| `update-python` | Alias for `update-uv` |
| `uninstall-python` | Alias for `uninstall-uv` |

`install-uv` runs `uv python install --default`, which also installs `python`
and `python3` executables.

`update-uv` upgrades uv with Homebrew and upgrades installed Python versions to
their latest patch releases. When a newer stable CPython release is available,
it installs that version as the default. It then upgrades all uv tools.
`update-all` runs the same Python and tool updates, and its Homebrew step
upgrades uv.

`uninstall-uv` deletes the Python and tool directories reported by
`uv python dir` and `uv tool dir` only when they are inside `$HOME`.

When uv is installed, the plugin caches zsh completions for `uv` and `uvx`.

## Tool Installers

Each installer exists when uv is installed and its tool is not on `PATH`. It
installs the latest release with `uv tool install`, and `update-uv` and
`update-all` upgrade it along with the other uv tools.

| Command | Description |
| --- | --- |
| `install-python-ruff` | Install [Ruff](https://docs.astral.sh/ruff/), a linter and formatter |
| `install-python-basedpyright` | Install [basedpyright](https://docs.basedpyright.com/), a type checker forked from Pyright |
| `install-python-ty` | Install [ty](https://docs.astral.sh/ty/), a type checker and language server |
| `install-python-pyrefly` | Install [Pyrefly](https://pyrefly.org/), a type checker and language server |

To remove a tool, run `uv tool uninstall <tool>`.

## Project Sync

`venv-sync` exists when uv is installed.

| Command | Description |
| --- | --- |
| `venv-sync` | Create or sync the current project's virtual environment with uv, then activate it |

When the current directory has no `pyproject.toml`, `venv-sync` warns and does
nothing. Otherwise, it deactivates any active virtual environment and then:

- With `uv.lock`: runs `uv sync` into `VENV_DIR` and activates it
- Without `uv.lock`: creates `VENV_DIR` with `uv venv --seed` if it is missing,
  activates it, and runs `uv pip install -r` on `requirements-dev.txt`, or on
  `requirements.txt` when there is no `requirements-dev.txt`

## Environment Variables

`venv-sync` reads these variables. Set them in `~/.zshrc`, or for a single run,
as in `PYTHON_VERSION=3.12 venv-sync`.

| Variable | Default | Purpose |
| --- | --- | --- |
| `VENV_DIR` | `.venv` | Virtual environment directory for `venv-sync` |
| `PYTHON_VERSION` | Unset | Python version passed to uv as `--python` |

`venv` and the hook look only for `.venv` and `venv`, so they do not activate a
custom `VENV_DIR`.
