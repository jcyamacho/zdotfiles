# git-worktree

Helpers for managing
[Git worktrees](https://git-scm.com/docs/git-worktree) -- separate
working directories for different branches.

## Functions / Aliases

| Command / Alias       | Description                          |
| --------------------- | ------------------------------------ |
| `gwt <branch> [ref]`  | Create a worktree and cd into it     |
| `gwts <worktree>`     | Switch to a worktree                 |
| `gwt-rm <worktree>`   | Remove a worktree                    |
| `gwt-ls`              | List active worktrees                |
| `gwt-prune`           | Prune stale worktree metadata        |

## Completion

Every command that takes an argument completes it, and each one omits
the candidates it would reject anyway.

`gwt` completes branch names, merging local branches with the ones on
`origin`:

- **First argument**: branches that do not have a worktree yet. Ones
  that already have one are skipped because `git worktree add` refuses
  them. Typing a brand new branch name still works; the menu is only a
  shortcut for branches that already exist.
- **Second argument**: every branch, since the base ref only applies
  when the branch does not exist yet.

`gwts` and `gwt-rm` complete worktrees by the name of their directory,
showing the branch each one holds as the description. A worktree in
detached HEAD has no branch, so the directory name is the only handle
that always exists.

- `gwts` omits the current worktree, since switching to it does
  nothing.
- `gwt-rm` omits the current and the main worktree, since both are
  refused.

With `fzf-tab` installed the completion menu is itself a fuzzy picker,
so this replaces the interactive selector these commands used to have
while also working without `fzf` at all.

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

# Switch to a worktree
gwts myrepo.feature-my-feature

# List all worktrees
gwt-ls

# Delete a worktree
gwt-rm myrepo.feature-my-feature

# Clean up stale worktree references
gwt-prune
```

If the selected worktree has local changes, `gwt-rm` warns first and
asks for confirmation before retrying with `git worktree remove --force`.

### Branch detection

`gwt` detects the branch type automatically:

1. **Local** -- branch exists locally, attaches a worktree to it
2. **Remote** -- branch exists on origin, creates a local tracking
   branch
3. **New** -- neither exists, creates a new branch from origin's
   default branch (or the provided base ref)

## Worktree Location

`gwt` places worktrees under `GIT_WORKTREE_BASE`:

- Default (unset): `..` (next to the repo directory)
- `export GIT_WORKTREE_BASE="$HOME/worktrees"`: centralized location
- `export GIT_WORKTREE_BASE=".worktrees"`: inside repo (relative paths
  work)

Worktrees are named `<repo>.<branch>` (slashes in branch names become dashes).

## Setup script

After `git worktree add` completes (and Git's own `post-checkout` hook
runs), `gwt` sources one setup script if it exists:

```text
$GIT_COMMON_DIR/setup-worktree.zsh
```

That path lives inside `.git`, so the script is local to the clone and
never committed. Run `gwt-setup` to create it from a template and open
it in `$EDITOR`.

It is sourced rather than executed, so it can change the state of the
shell you land in. `$ROOT_WORKTREE_PATH` points to the main worktree
while it runs, which is how a script reaches back for gitignored files
such as `.env`.

**Example** (`setup-worktree.zsh`):

```zsh
# Install dependencies
npm install

# Allow direnv
if command -v direnv &>/dev/null; then
  command direnv allow
fi
```

`gwt` propagates the script's final status. Use `if` blocks for optional
commands so a missing tool does not look like a setup failure.

## Requirements

- No hard requirements. [fzf](https://github.com/junegunn/fzf) with
  `fzf-tab` turns the completion menus into fuzzy pickers, but plain zsh
  completion works without it.
