# python

Python helpers powered by uv, virtualenv convenience, and tool installers.

## Helpers (require `python` on PATH)

| Function           | Alias | Description                                   |
| ------------------ | ----- | --------------------------------------------- |
| `py`               |       | Alias for `python3`                           |
| `pyclean`          |       | Remove common Python cache directories/files |
| `venv`             |       | Activate `.venv` or `venv` in the cwd         |
| `pytest`           |       | Activate venv (if present) then run pytest    |
| `enable-venv-hook` |       | Auto-activate venv on directory change        |

To enable the directory-change hook, add `enable-venv-hook` to your `~/.zshrc` (opt-in).

## Install/update helpers (require `uv` on PATH)

| Function         | Alias              | Description                                          |
| ---------------- | ------------------ | ---------------------------------------------------- |
| `install-uv`     | `install-python`   | Install uv, then install latest Python               |
| `update-uv`      | `update-python`    | Update uv, Python versions, and uv-managed tools     |
| `uninstall-uv`   | `uninstall-python` | Remove uv binaries and uv-managed Python/tool trees  |

## Tool installers (require `uv` on PATH)

| Function                    | Description                      |
| --------------------------- | -------------------------------- |
| `install-python-ruff`       | Install Ruff via `uv tool`       |
| `install-python-basedpyright` | Install Based Pyright via `uv tool` |
| `install-python-ty`         | Install Ty via `uv tool`         |
| `install-python-pyrefly`    | Install Pyrefly via `uv tool`    |

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
