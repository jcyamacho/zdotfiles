# git-worktree

Commands to create, switch between, and remove
[Git worktrees](https://git-scm.com/docs/git-worktree), which let one
repository have several branches checked out at once in separate directories.
Each new worktree can run a per-repository setup script.

## Commands

| Command | Description |
| --- | --- |
| `gwt <branch> [base-ref]` | Create a worktree for a branch, change into it, and run the setup script |
| `gwts <worktree>` | Change to another worktree of the current repository |
| `gwt-rm <worktree>` | Remove a worktree, then offer to delete its branch |
| `gwt-setup` | Create the repository's setup script from the template if missing, then open it in `$EDITOR` |

`<worktree>` is the name of the worktree's directory, such as
`myrepo.feature-login`. Unlike a branch name, it exists even for a worktree
with a detached HEAD.

## Aliases

| Alias | Expands to |
| --- | --- |
| `gwt-ls` | `git worktree list` |
| `gwt-prune` | `git worktree prune` |

## Environment Variables

| Variable | Default | Purpose |
| --- | --- | --- |
| `GIT_WORKTREE_BASE` | Parent directory of the current worktree | Directory where `gwt` creates worktrees |

## Usage

```zsh
# Check out a branch, or create it from origin's default branch
gwt feature/login

# Create a new branch from a specific ref
gwt hotfix/urgent v1.2.3

# Switch to another worktree, or back to the main one
gwts myrepo.feature-login
gwts myrepo

# Remove a worktree and optionally its branch
gwt-rm myrepo.feature-login
```

## Creating Worktrees

`gwt` looks for the branch in this order:

1. **Local branch:** creates a worktree for it.
2. **Branch on `origin`:** fetches it, and `git worktree add` creates a local
   branch that tracks `origin/<branch>`.
3. **Neither:** creates a new branch from `[base-ref]`. Without a base ref, it
   fetches origin's default branch and starts from that. The new branch has
   no upstream, even when it starts from `origin/<default>`.

In the first two cases `gwt` ignores `[base-ref]` and prints a warning. A base
ref you pass is used as is, without fetching.

To find origin's default branch, `gwt` asks the remote with
`git remote show origin`, then falls back to the local `origin/HEAD` ref and
finally to `main`. If fetching the default branch fails, for example in a
repository without an `origin` remote, `gwt` stops. Pass a base ref instead.

`gwt` creates the worktree at `$GIT_WORKTREE_BASE/<repo>.<branch>`, with
slashes in the branch name replaced by dashes. `<repo>` is the directory name
of the worktree you run `gwt` from. Run from `myrepo`, `gwt feature/login`
creates `myrepo.feature-login`. Run from that new worktree, `gwt feature/b`
creates `myrepo.feature-login.feature-b`.

A relative `GIT_WORKTREE_BASE` resolves against the current directory, so use
an absolute path:

```zsh
export GIT_WORKTREE_BASE="$HOME/worktrees"
```

## Removing Worktrees

`gwt-rm` refuses to remove the main worktree or the worktree you are in,
including when you are in one of its subdirectories.

If Git refuses to remove a worktree because it has modified or untracked files
or contains submodules, `gwt-rm` shows Git's message and asks whether to retry
with `git worktree remove --force`. Other Git errors end the command without a
retry.

After removing a worktree that had a branch checked out, `gwt-rm` asks whether
to delete the branch with `git branch -D`, which also deletes unmerged
branches. Both prompts default to no.

## Setup Script

After creating a worktree, `gwt` runs `setup-worktree.zsh` from the
repository's Git common directory, which is `.git` in the main worktree of a
regular clone. The script lives inside `.git`, so it is never committed and
all worktrees of the clone share it.

Run `gwt-setup` in any worktree of the repository to open the script, creating
it from [the template](templates/setup-worktree.zsh) first if needed. The
template symlinks the main worktree's `.claude/settings.local.json` into the
new worktree when that file exists. While the script is missing, `gwt` prints
the path where `gwt-setup` would create it.

`gwt` sources the script rather than executing it, so the script can use zsh
syntax and change the state of your shell. While it runs:

- The current directory is the new worktree.
- `ROOT_WORKTREE_PATH` holds the parent of the Git common directory, which is
  the main worktree in a regular clone. Use it to reach gitignored files such
  as `.env`.

`gwt` returns the status of the script's last command and leaves you in the
new worktree either way. Wrap optional steps in `if` blocks so a missing tool
does not end the script with a failure status:

```zsh
cp "$ROOT_WORKTREE_PATH/.env" .env
npm install

if exists direnv; then
  direnv allow
fi
```

## Completion

`gwt`, `gwts`, and `gwt-rm` complete their arguments and leave out candidates
that would fail or do nothing:

- `gwt` completes branch names from local branches and `origin`. For the first
  argument it omits branches that already have a worktree, because
  `git worktree add` refuses them. You can still type a new branch name. For
  the base ref it offers every branch.
- `gwts` and `gwt-rm` complete worktree directory names, described by the
  branch each worktree has checked out or `detached HEAD`. `gwts` omits the
  current worktree, and `gwt-rm` omits the current and main worktrees.

When `fzf` is installed, these dotfiles load
[fzf-tab](https://github.com/Aloxaf/fzf-tab), which turns these menus into
fuzzy pickers.
