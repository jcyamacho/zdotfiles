# dotnet

.NET SDK lifecycle, completion, and global tool installers.

The SDK is managed as the `dotnet-sdk` Homebrew cask, so `update-brew`
keeps it current. Global tools are installed per tool and refreshed by
`update-dotnet-tools`.

## SDK (requires `brew` for lifecycle)

- `install-dotnet` - install the .NET SDK (`dotnet-sdk` cask)
- `uninstall-dotnet` - remove the .NET SDK
- `update-dotnet` - upgrade the .NET SDK and reload the shell configuration

On load the plugin sets `DOTNET_CLI_TELEMETRY_OPTOUT=1` and
`DOTNET_NOLOGO=1`, prepends `~/.dotnet/tools` to `PATH` for global tools,
and registers completion for the `dotnet` command via the SDK's built-in
`dotnet complete` (computed on demand, no startup cost).

## Tool installers (require `dotnet` on PATH)

- `install-dotnet-ef` -
  [EF Core](https://learn.microsoft.com/ef/core/cli/dotnet) CLI
- `install-dotnet-outdated` -
  [dotnet-outdated](https://github.com/dotnet-outdated/dotnet-outdated)
  dependency checker

## Update

- `update-dotnet-tools` - update all installed global tools
  (`dotnet tool update --all -g`)
- `update-all` upgrades the SDK through `update-brew` and then runs
  `update-dotnet-tools`

## Usage

```zsh
# Install the SDK
install-dotnet

# Install EF tooling
install-dotnet-ef

# Update the SDK
update-dotnet

# Update all global tools
update-dotnet-tools
```
