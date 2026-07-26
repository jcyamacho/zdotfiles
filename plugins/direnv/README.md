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
| `update-direnv`    | Update direnv to the latest version      |
| `direnv-config`    | Edit the direnv configuration file       |

## Notes

- Installs to `$CUSTOM_TOOLS_DIR` (typically `~/.local/bin`)
- Uses cached init for faster startup
- Default config is copied from `plugins/direnv/direnv.toml`
