# dotnet

Manages the [.NET SDK](https://dotnet.microsoft.com/) as the `dotnet-sdk`
Homebrew cask and sets up its shell environment and `dotnet` completion. It
also provides installers for two .NET
[global tools](https://learn.microsoft.com/dotnet/core/tools/global-tools):
the [EF Core CLI](https://learn.microsoft.com/ef/core/cli/dotnet) and the
[dotnet-outdated](https://github.com/dotnet-outdated/dotnet-outdated)
dependency checker.

## Commands

| Command | Description |
| --- | --- |
| `install-dotnet` | Install the `dotnet-sdk` cask and reload the shell |
| `uninstall-dotnet` | Clear the NuGet caches, uninstall the `dotnet-sdk` cask, and reload the shell |
| `install-dotnet-ef` | Install the EF Core CLI (package `dotnet-ef`) as a global tool |
| `install-dotnet-outdated` | Install dotnet-outdated (package `dotnet-outdated-tool`) as a global tool |
| `update-dotnet-tools` | Update every installed global tool with `dotnet tool update --all -g` |

`install-dotnet` exists only when `dotnet` is not on `PATH`, and the other
commands only when it is. A tool installer is also not defined when its
command, `dotnet-ef` or `dotnet-outdated`, is already on `PATH`.

`update-brew` upgrades the SDK together with the other Homebrew packages.
`update-all` runs that, then `update-dotnet-tools`. The tool installers reload
the shell after a successful install.

## Environment Variables

Exported only when `dotnet` is on `PATH`:

| Variable | Value |
| --- | --- |
| `DOTNET_CLI_TELEMETRY_OPTOUT` | `1` |
| `DOTNET_NOLOGO` | `1` |

## PATH and Completion

When `dotnet` is on `PATH`, the plugin also:

- Prepends `~/.dotnet/tools`, where `dotnet tool install -g` puts global
  tools, to `PATH`
- Registers completion for `dotnet` that asks `dotnet complete` for candidates
  each time you complete, so it does not run `dotnet` at startup
