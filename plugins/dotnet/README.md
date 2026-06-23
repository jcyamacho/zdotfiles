# dotnet

.NET SDK lifecycle, completion, and global tool installers.

The SDK is managed as the `dotnet-sdk` Homebrew cask, so `update-brew`
keeps it current. Global tools are installed per tool and refreshed by
`update-dotnet`, which also upgrades the SDK cask.

## SDK (requires `brew` for lifecycle)

- `install-dotnet` - install the .NET SDK (`dotnet-sdk` cask)
- `uninstall-dotnet` - remove the .NET SDK

On load the plugin sets `DOTNET_CLI_TELEMETRY_OPTOUT=1` and
`DOTNET_NOLOGO=1`, prepends `~/.dotnet/tools` to `PATH` for global tools,
and registers completion for the `dotnet` command via the SDK's built-in
`dotnet complete` (computed on demand, no startup cost).

## Tool installers (require `dotnet` on PATH)

- `install-dotnet-ef` - [EF Core](https://learn.microsoft.com/ef/core/cli/dotnet) CLI
- `install-dotnet-outdated` - [dotnet-outdated](https://github.com/dotnet-outdated/dotnet-outdated) dependency checker

## Update

- `update-dotnet` - upgrade the SDK cask and update all installed global
  tools (`dotnet tool update --all -g`), then reload
- The global tools refresh also runs as part of `update-all` (the SDK cask
  is upgraded there by `update-brew`)

## Usage

```zsh
# Install the SDK
install-dotnet

# Install EF tooling
install-dotnet-ef

# Update the SDK and all global tools
update-dotnet
```
