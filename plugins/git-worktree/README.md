# git-worktree

Helpers for managing [Git worktrees](https://git-scm.com/docs/git-worktree) — separate working directories for different branches.

## Functions / Aliases

| Function              | Alias       | Description                                        |
| --------------------- | ----------- | -------------------------------------------------- |
| `git-worktree-new`    | `gwt-new`   | Create a new worktree and branch, then cd into it  |
| `git-worktree-delete` | `gwt-rm`    | Select and remove a worktree (via fzf)             |
|                       | `gwt-ls`    | List active worktrees                              |
|                       | `gwt-prune` | Prune stale worktree metadata                      |

## Usage

```zsh
# Create a new worktree for feature branch (from origin's default branch)
gwt-new feature/my-feature

# Create a worktree from a specific ref
gwt-new hotfix/urgent-fix v1.2.3

# List all worktrees
gwt-ls

# Delete a worktree (interactive fzf selection)
gwt-rm

# Clean up stale worktree references
gwt-prune
```

## Worktree Location

`gwt-new` places new worktrees under `GIT_WORKTREE_BASE`:

| Setting                                      | Result                              |
| -------------------------------------------- | ----------------------------------- |
| Default (unset)                              | `..` (next to the repo directory)   |
| `export GIT_WORKTREE_BASE="$HOME/worktrees"` | Centralized location                |
| `export GIT_WORKTREE_BASE=".worktrees"`      | Inside repo (relative paths work)   |

Worktrees are named `<repo>-<branch>` (slashes in branch names become dashes).

## Setup Hook

After creating a worktree, `gwt-new` looks for a setup script to bootstrap the environment (install dependencies, run migrations, etc.):

| Priority | Location                           | Scope              |
| -------- | ---------------------------------- | ------------------ |
| 1        | `$GIT_COMMON_DIR/setup-worktree.sh` | Local only         |
| 2        | `<repo>/.git-setup-worktree.sh`     | Shared (committed) |

The environment variable `$ROOT_WORKTREE_PATH` points to the main worktree while the script runs.

**Example** (`.git-setup-worktree.sh`):

```sh
# Copy environment from main worktree
cp "$ROOT_WORKTREE_PATH/.env" .env

# Install dependencies
npm install

# Allow direnv
command -v direnv &>/dev/null && direnv allow
```

## Requirements

- `gwt-rm` requires [fzf](https://github.com/junegunn/fzf) for interactive selection
