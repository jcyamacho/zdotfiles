# OpenSpec Plugin

OpenSpec CLI installer, updater, and workflow helpers.

- <https://openspec.dev/>

## Commands

| Command | Description |
| ------- | ----------- |
| `install-openspec` | Install `@fission-ai/openspec@latest` globally with npm |
| `update-openspec` | Update the global OpenSpec npm package |
| `uninstall-openspec` | Uninstall the global OpenSpec npm package |
| `openspec [args...]` | Run the installed OpenSpec CLI |
| `osp` | Short alias for `openspec` |
| `ospl` | Alias for `openspec list` |
| `osps` | Alias for `openspec list --specs` |
| `ospv` | Alias for `openspec validate --all --strict` |

## Init Helpers

| Function | Tool ID |
| -------- | ------- |
| `openspec-init-opencode` | `opencode` |
| `openspec-init-codex` | `codex` |
| `openspec-init-claude` | `claude` |
| `openspec-init-cursor` | `cursor` |
| `openspec-init-gemini` | `gemini` |
| `openspec-init-copilot` | `github-copilot` |

Each helper runs `openspec init --tools <tool> [path]`.

## Notes

- Aliases and init helpers are defined whenever `openspec` is installed
- `npm` is only required for `install-openspec`, `update-openspec`, and
  `uninstall-openspec`
- Upgrades the global package with `npm install -g @fission-ai/openspec@latest`
- After upgrading, run `openspec update` inside initialized projects to
  refresh project-local OpenSpec files
