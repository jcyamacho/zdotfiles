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

| Function                  | Description                                      |
| ------------------------- | ------------------------------------------------ |
| `p10k configure`          | Launch the interactive configuration wizard      |
| `p10k-config`             | Edit `~/.p10k.zsh` and reload                    |
| `p10k-preset-default`     | Reset `~/.p10k.zsh` to the repo default          |
| `p10k-zle-reset-prompt`   | Force a full prompt redraw from a ZLE widget     |

## Files

| File       | Description                              |
| ---------- | ---------------------------------------- |
| `p10k.zsh` | Default lean config shipped with the repo|

### p10k-zle-reset-prompt

Plain `zle reset-prompt` does not update p10k segments because they are
cached. `p10k-zle-reset-prompt` re-runs `chpwd` and `precmd` hooks first
so p10k rebuilds its content, then calls `zle .reset-prompt` and `zle -R`.

Call it from any ZLE widget that changes directory or other prompt-relevant
state. It is a no-op when called outside ZLE context.

## Notes

- Cloud-provider segments (gcloud, aws, azure) are disabled by default.
- Run `p10k configure` to fully customize the prompt interactively.
- The config file lives at `~/.p10k.zsh` and is not tracked by git.
