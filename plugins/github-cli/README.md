# github-cli

Sets up [GitHub CLI](https://github.com/cli/cli) (`gh`) with zsh completion and
adds commands that sync single files with your secret GitHub gists.

## Commands

| Command | Description |
| --- | --- |
| `install-gh` | Install GitHub CLI with Homebrew |
| `uninstall-gh` | Uninstall GitHub CLI with Homebrew |
| `save-file-to-gist <file_path> <description>` | Save a file to the secret gist with this description, creating the gist if none matches |
| `load-file-from-gist <file_path> <description>` | Replace a file with its copy from the secret gist with this description |

`install-gh` exists only while `gh` is missing, and `uninstall-gh` only while it
is installed. Without `gh`, the gist commands print an error that tells you to
run `install-gh`. While `gh` is installed, the plugin exports
`GH_TELEMETRY=false` to turn off GitHub CLI telemetry.

## Gist Sync

The gist commands call the GitHub API through `gh`, so sign in first with
`gh auth login`.

Secret gists are unlisted, not private. According to
[GitHub's gist documentation](https://docs.github.com/en/get-started/writing-on-github/editing-and-sharing-content-with-gists/creating-gists#about-gists),
anyone with a gist's URL can view it, so avoid syncing files that contain
credentials.

Both commands find the gist by its description:

- They consider only your secret gists whose description matches exactly.
  Public gists are ignored.
- If several gists match, they use the first one GitHub returns.

`save-file-to-gist` replaces the file in the matching gist that is named after
the base name of `<file_path>`, the same file `load-file-from-gist` reads. When
no gist matches, it creates one, which `gh` makes secret by default.

`load-file-from-gist` fails when no gist matches or when `<file_path>` is a
broken symlink. Otherwise:

- It reads the gist file named after the base name of `<file_path>`. For
  `~/.config/zed/settings.json`, that is `settings.json`.
- It downloads to a temporary file next to the target and moves it into place
  only after the download succeeds. A failed load leaves the existing file
  unchanged.
- An existing file keeps its permissions. A new file gets the default
  permissions from your umask, and missing parent directories are created.
- A read-only existing file is refused with an error, and nothing is
  downloaded.
- If `<file_path>` is a symlink, the file it points to is updated and the link
  stays in place.

```zsh
# Save the Starship config to the "starship-config" gist
save-file-to-gist ~/.config/starship.toml starship-config

# Restore it on another machine
load-file-from-gist ~/.config/starship.toml starship-config
```

## Built-in Sync Helpers

Other plugins wrap the gist commands for their config files:

| Command | Description |
| --- | --- |
| `opencode-config-save-to-gist` | Save `~/.config/opencode/opencode.json` to the `opencode-settings` gist |
| `opencode-config-load-from-gist` | Load `~/.config/opencode/opencode.json` from the `opencode-settings` gist |
| `zed-settings-save-to-gist` | Save `~/.config/zed/settings.json` to the `zed-settings` gist |
| `zed-settings-load-from-gist` | Load `~/.config/zed/settings.json` from the `zed-settings` gist |

[`opencode.zsh`](../opencode.zsh) defines the OpenCode helpers when OpenCode is
installed. [`zed.zsh`](../zed.zsh) defines the Zed helpers when Zed is
installed.
