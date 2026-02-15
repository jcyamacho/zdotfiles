# github-cli

GitHub on the command line with gist sync utilities.

- <https://github.com/cli/cli>

## Functions

| Function           | Description                                |
| ------------------ | ------------------------------------------ |
| `install-gh`       | Install GitHub CLI via Homebrew            |
| `uninstall-gh`     | Remove GitHub CLI                          |

## Gist Sync Functions

Sync files to/from private GitHub Gists.
Requires `gh` to be authenticated (`gh auth login`).

| Function              | Usage                                           |
| --------------------- | ----------------------------------------------- |
| `save-file-to-gist`   | `save-file-to-gist <file_path> <description>`   |
| `load-file-from-gist` | `load-file-from-gist <file_path> <description>` |

### How It Works

- Gists are matched by their **description** (not filename)
- If a gist with the given description exists, it's updated
- Otherwise, a new **private** gist is created

### Examples

```zsh
# Save a config file
save-file-to-gist ~/.config/starship.toml "starship-config"

# Load it on another machine
load-file-from-gist ~/.config/starship.toml "starship-config"
```

### Built-in Sync Helpers

Several plugins provide convenience wrappers:

- opencode: `opencode-config-save-to-gist` /
  `opencode-config-load-from-gist`
- zed: `zed-settings-save-to-gist` /
  `zed-settings-load-from-gist`

## Notes

- Only syncs to **private** gists (public gists are ignored when searching)
