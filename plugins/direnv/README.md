# direnv

Hooks [direnv](https://direnv.net/) into zsh so it loads and unloads
environment variables from `.envrc` files as you change directories. The plugin
also adds commands to install, configure, and uninstall direnv.

## Commands

| Command | Description |
| --- | --- |
| `install-direnv` | Install direnv with Homebrew and copy the bundled `direnv.toml` if no configuration file exists |
| `uninstall-direnv` | Uninstall direnv with Homebrew, then ask whether to delete `~/.config/direnv` (default no) |
| `direnv-config` | Open `~/.config/direnv/direnv.toml` in `$EDITOR` |

`install-direnv` exists only while direnv is missing. The other commands exist
only while it is installed.

## Configuration Paths

| Purpose | Path |
| --- | --- |
| Configuration directory | `~/.config/direnv` |
| Configuration file | `~/.config/direnv/direnv.toml` |

## Default Configuration

`install-direnv` copies [`direnv.toml`](direnv.toml) only when no configuration
file exists, so it never overwrites yours. The bundled file sets
`load_dotenv = true`, which makes direnv also load `.env` files. When a
directory has both files, direnv uses `.envrc`
([direnv.toml reference](https://direnv.net/man/direnv.toml.1.html)).

## Notes

- `update-brew`, also run by `update-all`, updates direnv
- The output of `direnv hook zsh` is cached in
  `$ZDOTFILES_CACHE_DIR/direnv.zsh` and regenerated when the direnv binary
  or the plugin file is newer than the cache
- If you confirm, `uninstall-direnv` deletes the whole `~/.config/direnv`
  directory, including any files you added there
