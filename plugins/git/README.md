# git

Everyday git shorthands and helper functions. Worktree management lives
in its own [git-worktree](../git-worktree/README.md) plugin.

## Shorthands

| Shorthand | Expands to                          |
| --------- | ----------------------------------- |
| `g`       | `git`                               |
| `gaa`     | `git add --all`                     |
| `gf`      | `git fetch`                         |
| `gcb`     | `git checkout -b`                   |
| `gcmsg`   | `git commit --message`              |
| `gc!`     | `git commit --verbose --amend`      |
| `ggl`     | `git pull origin <current branch>`  |
| `ggp`     | `git push origin <current branch>`  |

`ggl` and `ggp` resolve the current branch themselves, so they are
normally called with no arguments. Given arguments, both pass them
through to git untouched, which keeps refspecs and flags like
`--delete` working.

Called with no arguments, `ggp` adds `--set-upstream` only when the
branch has no upstream yet. A branch that deliberately tracks another
remote is never repointed at `origin`.

Both complete branch names, merging local branches with the ones on
`origin`.

## Functions

| Function       | Alias               | Description                          |
| -------------- | ------------------- | ------------------------------------ |
| `git-pull-all` | `gpa`               | Pull current repo or all repos       |
| `git-hook`     | `ghk-pre-commit`    | Create or edit a git hook by name    |
|                | `ghk-commit-msg`    |                                      |
|                | `ghk-post-merge`    |                                      |
|                | `ghk-post-checkout` |                                      |
|                | `ghk-pre-push`      |                                      |

## Usage

```zsh
# Pull current repo
gpa

# Pull a specific repo
gpa ~/code/my-project

# Pull all repos in current directory
gpa ~/code
```

## Why `--ff-only`?

`gpa` uses `git pull --ff-only` for safety:

- **Success** = clean fast-forward, no surprises
- **Failure** = local commits diverge from remote, needs manual attention

This prevents accidental merge commits when batch-pulling multiple
repos.

For post-pull automation (installing deps, running migrations, etc.),
use Git's native
[`post-merge`](https://git-scm.com/docs/githooks#_post_merge)
hook. It fires automatically after any successful `git pull`.
Use `git-hook post-merge` to create or edit it.
