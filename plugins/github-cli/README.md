# github-cli

GitHub on the command line with gist sync utilities.

- <https://github.com/cli/cli>

## Functions

| Function           | Description                                |
| ------------------ | ------------------------------------------ |
| `install-gh`       | Install GitHub CLI via Homebrew            |
| `uninstall-gh`     | Remove GitHub CLI                          |

## Gist Sync Functions

Sync files and directories to/from private GitHub Gists. Requires `gh` to be authenticated (`gh auth login`).

| Function              | Usage                                           |
| --------------------- | ----------------------------------------------- |
| `save-file-to-gist`   | `save-file-to-gist <file_path> <description>`   |
| `load-file-from-gist` | `load-file-from-gist <file_path> <description>` |
| `save-dir-to-gist`    | `save-dir-to-gist <dir_path> <description>`     |
| `load-dir-from-gist`  | `load-dir-from-gist <dir_path> <description>`   |

### How It Works

- Gists are matched by their **description** (not filename)
- If a gist with the given description exists, it's updated
- Otherwise, a new **private** gist is created
- Directory sync saves all non-empty files in the directory

### Examples

```zsh
# Save a config file
save-file-to-gist ~/.config/starship.toml "starship-config"

# Load it on another machine
load-file-from-gist ~/.config/starship.toml "starship-config"

# Sync an entire directory
save-dir-to-gist ~/.config/opencode/agent "opencode-agents"
load-dir-from-gist ~/.config/opencode/agent "opencode-agents"
```

### Built-in Sync Helpers

Several plugins provide convenience wrappers:

| Plugin    | Save                            | Load                              |
| --------- | ------------------------------- | --------------------------------- |
| opencode  | `opencode-settings-save-to-gist`  | `opencode-settings-load-from-gist`  |
| zed       | `zed-settings-save-to-gist`       | `zed-settings-load-from-gist`       |

## Notes

- Only syncs to **private** gists (public gists are ignored when searching)
- `save-dir-to-gist` skips empty files
- `load-dir-from-gist` creates the target directory if it doesn't exist
