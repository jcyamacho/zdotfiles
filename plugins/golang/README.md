# golang

Go programming language plugin with golangci-lint.

- <https://golang.org/>
- <https://golangci-lint.run/>

## Environment Variables

| Variable | Value       |
| -------- | ----------- |
| `GOPATH` | `~/.go`     |

## Functions

| Function       | Description                                         |
| -------------- | --------------------------------------------------- |
| `install-go`   | Install Go and golangci-lint via Homebrew           |
| `uninstall-go` | Uninstall Go, golangci-lint, and remove `$GOPATH`   |
| `gmi`          | Initialize a Go module with namespace auto-detection |

## Aliases

| Alias | Command      |
| ----- | ------------ |
| `gmt` | `go mod tidy` |

## Notes

- `gmi` auto-detects namespace from path (e.g., `github.com/user/repo`)
- Copies a starter `main.go` template if not present
- Telemetry is disabled on install
