# openspec

Installs the [OpenSpec](https://openspec.dev/) CLI
([source](https://github.com/Fission-AI/OpenSpec)) with npm and adds aliases
and `openspec init` shortcuts for common AI coding tools.

## Commands

| Command | Description |
| --- | --- |
| `install-openspec` | Install `@fission-ai/openspec@latest` globally with npm |
| `update-openspec` | Update the global package to `@fission-ai/openspec@latest` with npm |
| `uninstall-openspec` | Remove the global `@fission-ai/openspec` package with npm |
| `openspec-init-claude [args...]` | Run `openspec init --tools claude [args...]` |
| `openspec-init-codex [args...]` | Run `openspec init --tools codex [args...]` |
| `openspec-init-copilot [args...]` | Run `openspec init --tools github-copilot [args...]` |
| `openspec-init-cursor [args...]` | Run `openspec init --tools cursor [args...]` |
| `openspec-init-gemini [args...]` | Run `openspec init --tools gemini [args...]` |
| `openspec-init-opencode [args...]` | Run `openspec init --tools opencode [args...]` |

The `openspec-init-*` commands pass extra arguments to `openspec init`, such as
a target directory. The
[OpenSpec CLI reference](https://github.com/Fission-AI/OpenSpec/blob/main/docs/cli.md)
lists the arguments and tool IDs that `openspec init` accepts.

While `openspec` is installed, the plugin exports `OPENSPEC_TELEMETRY=0` to
turn off OpenSpec telemetry.

## Aliases

| Alias | Expands to |
| --- | --- |
| `osp` | `openspec` |
| `ospl` | `openspec list` |
| `osps` | `openspec list --specs` |
| `ospv` | `openspec validate --all --strict` |

## Notes

- The aliases and `openspec-init-*` commands exist only when `openspec` is on
  `PATH`. In that case, the plugin also caches the zsh completion that
  `openspec completion generate zsh` prints.
- The install, update, and uninstall commands exist only when `npm` is on
  `PATH`: `install-openspec` while `openspec` is missing, and `update-openspec`
  and `uninstall-openspec` once it is installed. Each runs `reload` after it
  succeeds.
- When `update-openspec` is available, `update-all` runs the same update.
- After an upgrade, run `openspec update` in each initialized project to
  refresh its OpenSpec instruction files
  ([upstream docs](https://github.com/Fission-AI/OpenSpec/blob/main/docs/cli.md)).
