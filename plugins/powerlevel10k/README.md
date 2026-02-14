# powerlevel10k

Fast zsh prompt theme with instant prompt and async git status.

- <https://github.com/romkatv/powerlevel10k>

## How it works

Antidote clones and sources Powerlevel10k automatically. On first load, if
`~/.p10k.zsh` does not exist, the plugin copies the default lean config from
this directory.

Instant prompt is sourced early in `zshrc.sh` (before plugins load) so the
first prompt appears immediately.

## Functions

| Function              | Description                                  |
| --------------------- | -------------------------------------------- |
| `p10k configure`      | Launch the interactive configuration wizard  |
| `p10k-config`         | Edit `~/.p10k.zsh` and reload                |
| `p10k-preset-default` | Reset `~/.p10k.zsh` to the repo default      |

## Files

| File       | Description                              |
| ---------- | ---------------------------------------- |
| `p10k.zsh` | Default lean config shipped with the repo|

## Notes

- Cloud-provider segments (gcloud, aws, azure) are disabled by default.
- Run `p10k configure` to fully customize the prompt interactively.
- The config file lives at `~/.p10k.zsh` and is not tracked by git.
