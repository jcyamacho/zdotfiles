# starship

Cross-shell prompt customization.

- <https://starship.rs>

## Environment Variables

| Variable              | Value                       |
| --------------------- | --------------------------- |
| `STARSHIP_CONFIG_FILE` | `~/.config/starship.toml`   |

## Functions

| Function                     | Description                                  |
| ---------------------------- | -------------------------------------------- |
| `update-starship`            | Update Starship to the latest version        |
| `starship-config`            | Edit the Starship config file and reload     |
| `starship-preset-custom`     | Apply the custom preset from this repo       |
| `starship-preset-nerd-fonts` | Apply the nerd-font-symbols preset           |
| `starship-preset-no-nerd-font` | Apply the no-nerd-font preset              |
| `starship-preset-plain-text` | Apply the plain-text-symbols preset          |

## Notes

- Auto-installs on first load if not present
- Uses cached init for faster startup
- Skips init in dumb terminals
