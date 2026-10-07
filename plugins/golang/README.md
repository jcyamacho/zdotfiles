# golang

Sets up [Go](https://golang.org/) with `GOPATH` in `~/.go`, short `go`
aliases, and a module starter. `install-go` also installs
[golangci-lint](https://golangci-lint.run/).

Everything except `install-go` is defined only when `go` is on `PATH`.

## Commands

| Command | Description |
| --- | --- |
| `gmi` | Run `go mod init` with a module path based on the current directory and add a starter `main.go` |
| `install-go` | Install Go and golangci-lint with Homebrew and turn off Go telemetry |
| `uninstall-go` | Uninstall golangci-lint and Go with Homebrew, then ask whether to delete `$GOPATH`, including its read-only module cache (default no) |

`update-brew` upgrades Go and golangci-lint along with other Homebrew packages.

## Aliases

| Alias | Expands to |
| --- | --- |
| `gob` | `go build` |
| `gog` | `go get` |
| `gom` | `go mod` |
| `gor` | `go run` |
| `gow` | `go work` |
| `gmt` | `go mod tidy` |

The aliases call `command go`, so they bypass any alias or function named
`go`.

## Environment Variables

| Variable | Value |
| --- | --- |
| `GOPATH` | `~/.go` |

The plugin sets `GOPATH` in place of Go's default, `~/go`, and replaces any
value set before it loads. It also prepends `$GOPATH/bin` to `PATH`, where
[`go install`](https://go.dev/ref/mod#go-install) puts executables when
`GOBIN` is not set.

## Module Starter

`gmi` takes no arguments. It derives the module path from the current
directory:

- If the path contains `github.com/`, the module path starts there. For
  example, `~/src/github.com/user/repo` becomes `github.com/user/repo`.
- Otherwise, the module path is the directory name.

If `go mod init` succeeds and the directory has no `main.go`, `gmi` copies the
bundled [`main.go`](main.go), which logs `Hello, World!` with `log/slog`.
