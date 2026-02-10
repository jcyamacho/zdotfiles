# git-worktree

Helpers for managing [Git worktrees](https://git-scm.com/docs/git-worktree) — separate working directories for different branches.

## Functions / Aliases

| Function              | Alias       | Description                              |
| --------------------- | ----------- | ---------------------------------------- |
| `git-worktree-new`    | `gwt`       | Create a worktree and cd into it         |
|                       | `gwt-new`   |                                          |
| `git-worktree-delete` | `gwt-rm`    | Select and remove a worktree (via fzf)   |
|                       | `gwt-ls`    | List active worktrees                    |
|                       | `gwt-prune` | Prune stale worktree metadata            |

## Usage

```zsh
# New branch (from origin's default branch)
gwt feature/my-feature

# New branch from a specific ref
gwt hotfix/urgent-fix v1.2.3

# Remote branch (fetches and tracks origin/<branch>)
gwt feature/someone-elses-pr

# Existing local branch
gwt feature/my-wip-branch

# List all worktrees
gwt-ls

# Delete a worktree (interactive fzf selection)
gwt-rm

# Clean up stale worktree references
gwt-prune
```

### Branch detection

`gwt` detects the branch type automatically:

1. **Local** -- branch exists locally, attaches a worktree to it
2. **Remote** -- branch exists on origin, creates a local tracking
   branch
3. **New** -- neither exists, creates a new branch from origin's
   default branch (or the provided base ref)

## Worktree Location

`gwt` places worktrees under `GIT_WORKTREE_BASE`:

| Setting                                      | Result                              |
| -------------------------------------------- | ----------------------------------- |
| Default (unset)                              | `..` (next to the repo directory)   |
| `export GIT_WORKTREE_BASE="$HOME/worktrees"` | Centralized location                |
| `export GIT_WORKTREE_BASE=".worktrees"`      | Inside repo (relative paths work)   |

Worktrees are named `<repo>-<branch>` (slashes in branch names become dashes).

## Post-Create Sequence

After `git worktree add` completes (and Git's own `post-checkout`
hook runs), `gwt` performs these steps in order:

| Step | What                          | Source                              |
| ---- | ----------------------------- | ----------------------------------- |
| 1    | Copy `.worktreeinclude` files | `<repo>/.worktreeinclude`           |
| 2    | Run setup script              | `$GIT_COMMON_DIR/setup-worktree.sh` |
| 3    | Run setup script (fallback)   | `<repo>/.codex/setup.sh`            |

Steps 2 and 3 are mutually exclusive -- the first script found wins.
Step 1 always runs (no-op if the file doesn't exist).

### .worktreeinclude

A `.worktreeinclude` file in the project root lists files and
directories that should be copied from the main worktree into new
ones. This is useful for gitignored files that aren't checked out
automatically (`.env`, local configs, etc.).

Existing files in the new worktree are never overwritten -- tracked
files checked out by Git are always preserved.

**Format:** one pattern per line, zsh glob syntax, `#` for comments.

```gitignore
# Environment
.env
.env.local

# Local editor config
.claude/settings.local.json
CLAUDE.local.md

# Dependencies (can be slow for large directories)
node_modules
```

> Compatible with [Claude Code Desktop](https://code.claude.com/docs/en/desktop)'s
> `.worktreeinclude` convention. Negation patterns (`!pattern`) are not
> supported and will produce a warning.

### Setup scripts

Setup scripts run after `.worktreeinclude` files are copied, so
they can use those files (e.g., read `.env`).

| Priority | Location                            | Scope              |
| -------- | ----------------------------------- | ------------------ |
| 1        | `$GIT_COMMON_DIR/setup-worktree.sh` | Local only         |
| 2        | `<repo>/.codex/setup.sh`            | Shared (committed) |

The environment variable `$ROOT_WORKTREE_PATH` points to the main
worktree while the script runs.

**Example** (`setup-worktree.sh`):

```sh
# Install dependencies
npm install

# Allow direnv
command -v direnv &>/dev/null && direnv allow
```

## Requirements

- `gwt-rm` requires [fzf](https://github.com/junegunn/fzf) for interactive selection
