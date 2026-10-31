# dotnet

Manages the [.NET SDK](https://dotnet.microsoft.com/) for your user through
[dotnetup](https://learn.microsoft.com/dotnet/core/tools/dotnetup/), which is
in public preview, and sets up its shell environment and `dotnet` completion.
It also provides installers for two .NET
[global tools](https://learn.microsoft.com/dotnet/core/tools/global-tools):
the [EF Core CLI](https://learn.microsoft.com/ef/core/cli/dotnet) and the
[dotnet-outdated](https://github.com/dotnet-outdated/dotnet-outdated)
dependency checker.

## Commands

| Command | Description |
| --- | --- |
| `install-dotnet` | Install `dotnetup` in `$CUSTOM_TOOLS_DIR`, install the `lts` SDK channel (latest LTS release), and reload the shell |
| `uninstall-dotnet` | Clear the NuGet caches, delete the global tools, the dotnetup-managed SDKs and state, and `dotnetup`, and reload the shell |
| `update-dotnet` | Update `dotnetup` and every tracked SDK and runtime channel, and reload the shell |
| `install-dotnet-ef` | Install the EF Core CLI (package `dotnet-ef`) as a global tool |
| `install-dotnet-outdated` | Install dotnet-outdated (package `dotnet-outdated-tool`) as a global tool |
| `update-dotnet-tools` | Update every installed global tool with `dotnet tool update --all -g` |

`install-dotnet` exists only while `dotnetup` is missing from
`$CUSTOM_TOOLS_DIR`, and `uninstall-dotnet` and `update-dotnet` only when it is
there. The tool commands exist only when `dotnet` is on `PATH`, and a tool
installer is also not defined when its command, `dotnet-ef` or
`dotnet-outdated`, is already in `~/.dotnet/tools`.

`update-all` runs `update-dotnet` without the reload, then
`update-dotnet-tools`. The tool installers reload the shell after a successful
install.

Use `dotnetup` directly for anything else, such as installing more SDK
channels or runtimes, or the SDK that a repository's `global.json` requires
(`dotnetup sdk install` from the repository). The plugin never runs
`dotnetup init` or `dotnetup env set`, so dotnetup does not edit your shell
profile.

## Environment Variables

Exported only when `dotnetup` is on `PATH`:

| Variable | Value |
| --- | --- |
| `DOTNET_CLI_TELEMETRY_OPTOUT` | `1` |
| `DOTNET_NOLOGO` | `1` |
| `DOTNET_ROOT` | `~/Library/Application Support/dotnetup/dotnet`, the dotnetup-managed installation root |

`DOTNET_ROOT` lets framework-dependent apps, including global tools, find the
runtime outside the machine-wide location. Apps that do not inherit your shell
environment do not see the dotnetup-managed SDK.

dotnetup does not read `DOTNET_ROOT`, so you cannot use it to change where
dotnetup installs. dotnetup uses its default root unless a command passes
`--install-path` or a `global.json` sets `sdk.paths`. Pointing `DOTNET_ROOT`
anywhere else only hides the SDKs that dotnetup installs.

## PATH and Completion

When `dotnetup` is on `PATH`, the plugin also:

- Prepends `DOTNET_ROOT`, which contains `dotnet`, and `~/.dotnet/tools`, where
  `dotnet tool install -g` puts global tools, to `PATH`
- Registers completion for `dotnet` that asks `dotnet complete` for candidates
  each time you complete, so it does not run `dotnet` at startup
