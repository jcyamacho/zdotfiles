# git

Short aliases and helper functions for [Git](https://git-scm.com/): pull and
push the current branch on `origin`, pull many repositories at once, and edit
hooks. Worktree commands live in the separate
[git-worktree](../git-worktree/README.md) plugin.

## Commands

| Command | Description |
| --- | --- |
| `ggl [args]` | Run `git pull origin` for the current branch, or with `args` |
| `ggp [args]` | Run `git push origin` for the current branch, or with `args` |
| `git-pull-all [dir]` | Fast-forward pull the repository containing `dir`, or every repository directly under `dir` |
| `git-hook <hook-name>` | Create a hook in the current repository if missing, then open it in your editor |

## Aliases

| Alias | Expands to |
| --- | --- |
| `g` | `git` |
| `gaa` | `git add --all` |
| `gf` | `git fetch` |
| `gcb` | `git checkout -b` |
| `gcmsg` | `git commit --message` |
| `gc!` | `git commit --verbose --amend` |
| `gpa` | `git-pull-all` |
| `ghk-pre-commit` | `git-hook pre-commit` |
| `ghk-commit-msg` | `git-hook commit-msg` |
| `ghk-post-merge` | `git-hook post-merge` |
| `ghk-post-checkout` | `git-hook post-checkout` |
| `ghk-pre-push` | `git-hook pre-push` |

The `g`, `gaa`, `gf`, `gcb`, `gcmsg`, and `gc!` aliases call `command git`, so
they bypass any alias or function named `git`.

## Pulling and Pushing the Current Branch

Without arguments, `ggl` and `ggp` act on the current branch:

- `ggl` runs `git pull origin <branch>`.
- `ggp` runs `git push origin <branch>` and adds `--set-upstream` only when the
  branch has no upstream yet. A branch that already tracks another remote keeps
  its upstream.

On a detached HEAD there is no current branch, so both return status 1 without
pulling, pushing, or printing a message.

With arguments, both pass them unchanged after `origin`, as in
`git push origin <args>`. Refspecs and flags such as `--delete` work, and `ggp`
does not add `--set-upstream`.

Both complete branch names from local branches and from the remote-tracking
branches of `origin`, shown without the `origin/` prefix.

## Pulling Several Repositories

`git-pull-all [dir]` (alias `gpa`) works on `dir`, which defaults to the current
directory:

- If the directory is inside a Git repository, it pulls that repository and
  returns the pull's exit status.
- Otherwise, it pulls each repository directly under the directory, one level
  deep, and prints each repository's output indented under its name. It
  continues after a failed pull, then reports `Completed with errors.` and
  returns 1.

It also returns 1 when the directory does not exist.

```zsh
gpa ~/code/app   # Pull one repository
gpa ~/code       # Pull every repository directly under ~/code
```

Every pull runs `git pull --ff-only`, which updates the branch only when it can
fast-forward. When local commits have diverged from the upstream, that pull
fails and leaves the branch unchanged instead of merging or rebasing, so a batch
pull never creates merge commits. See
[`git pull`](https://git-scm.com/docs/git-pull) for details.

To run commands after each pull, such as installing dependencies, use Git's
[`post-merge` hook](https://git-scm.com/docs/githooks#_post_merge). Git runs it
when `git pull` merges, including a fast-forward. Run `ghk-post-merge` to create
or edit it.

## Editing Hooks

`git-hook <hook-name>` opens a hook of the current repository with `$EDITOR`, or
`vim` when `EDITOR` is unset. It finds the hooks directory with
`git rev-parse --git-path hooks`, so it follows `core.hooksPath` when set. In a
linked worktree, it uses the hooks directory shared with the main repository.

When the hook does not exist, `git-hook` creates it as an executable script,
creating the hooks directory if needed. The new hook starts from:

- `<hook-name>.sample` in the hooks directory, when Git provides one
- An empty `#!/bin/sh` script otherwise

A copied sample is active right away and runs Git's example checks until you
change it.
