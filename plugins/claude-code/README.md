# claude-code

Manages Claude Code through its native installer and Claude Desktop through
its Homebrew cask.

## Claude Code

- `install-claude-code` installs Claude Code in `~/.local/bin`.
- `cc [args...]` runs `claude` with `CLAUDE_CODE_NO_FLICKER=1`.
- `claude-code-config` opens `~/.claude` in `$EDITOR`. `cc-config` is an alias.
- `claude-code-settings-save-to-gist` and `claude-code-settings-load-from-gist`
  sync `~/.claude/settings.json` with the `claude-code-settings` gist. See
  [GitHub CLI gist sync](../github-cli/README.md#gist-sync).
- `update-claude-code` updates the CLI and reloads the shell.
- `update-claude-code-marketplaces` refreshes all configured marketplaces.
- `uninstall-claude-code` removes the CLI and asks whether to delete its data.
  Claude Desktop also uses that data.

`update-all` updates both the CLI and its marketplaces.

## Claude Desktop

- `install-claude-desktop` installs or adopts the Claude Homebrew cask.
- `claude-desktop-config` opens `claude_desktop_config.json` in `$EDITOR`.
- `claude-desktop-open [dir]` opens a new Claude Desktop session in `dir`, or
  in the current directory. `cc-desktop` is an alias.
- `uninstall-claude-desktop` asks whether to delete app data, then removes the
  cask, downloaded builds, and caches.
