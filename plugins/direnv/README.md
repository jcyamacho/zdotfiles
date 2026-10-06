# direnv

Per-directory environment variables via `.envrc` files.

- <https://direnv.net/>

## Configuration Paths

| Purpose | Path |
| --- | --- |
| Configuration directory | `~/.config/direnv` |
| Configuration file | `~/.config/direnv/direnv.toml` |

## Functions

| Function           | Description                              |
| ------------------ | ---------------------------------------- |
| `install-direnv`   | Install direnv and copy default config   |
| `uninstall-direnv` | Remove direnv and its configuration      |
| `direnv-config`    | Edit the direnv configuration file       |

## Notes

- Installs with Homebrew; `update-brew` keeps it current
- Uses cached init for faster startup
- Default config is copied from `plugins/direnv/direnv.toml`
