# Vite+

This plugin installs [Vite+](https://viteplus.dev/) and uses it to manage
Node.js, npm, and pnpm. Vite+ manages both global and per-project pnpm
versions. Bun is managed independently.

## Commands

- `install-viteplus` installs Vite+ and sets up Node.js, npm, and pnpm.
  `install-node` installs Vite+ if needed and runs `update-node` if Vite+ is
  already installed.
- `vpnvm` runs `vp env use` with the Node.js version in the current directory's
  `.nvmrc` to activate it for this shell. If the file is missing, it prints a
  warning.
- `update-node` installs the latest Node.js long-term support release, makes
  it the global default for projects without a version pin, and updates npm
  and pnpm.
- `uninstall-unused-node-versions` removes Vite+ Node.js installations after
  confirmation and keeps the current and default versions.
- `update-viteplus` upgrades Vite+.
- `uninstall-viteplus` removes Vite+ and its data under `~/.vite-plus`.

`update-all` runs both the Vite+ and Node.js updates.

## Switching from fnm

Open a new terminal and run `update-node` once to enable Vite+ management.
You can keep your existing fnm installations.
