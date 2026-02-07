# python

Python helpers powered by uv, virtualenv convenience, and tool installers.

## Helpers (require `python3` on PATH)

| Function           | Alias | Description                                  |
| ------------------ | ----- | -------------------------------------------- |
| `py`               |       | Alias for `python3`                          |
| `pyclean`          |       | Remove common Python cache dirs and files    |
| `venv`             |       | Activate `.venv` or `venv` in the cwd        |
| `pytest`           |       | Activate venv (if present), then run pytest  |
| `enable-venv-hook` |       | Auto-activate venv on directory change       |

To enable the directory-change hook, add `enable-venv-hook` to your
`~/.zshrc` (opt-in).

## Install/update helpers (require `uv` on PATH)

- `install-uv` (alias: `install-python`) - install uv and Python
- `update-uv` (alias: `update-python`) - update uv, Python, and uv tools
- `uninstall-uv` (alias: `uninstall-python`) - remove uv binaries and uv dirs

## Tool installers (require `uv` on PATH)

- `install-python-ruff`
- `install-python-basedpyright`
- `install-python-ty`
- `install-python-pyrefly`

## Usage

```zsh
# Install uv + Python
install-uv

# Activate .venv/venv in the current directory
venv

# Auto-activate on directory change
enable-venv-hook

# Run pytest inside the venv (if present)
pytest

# Clean caches from current directory
pyclean

# Update uv + Python + tools
update-uv

# Install additional Python tooling
install-python-ruff
```
