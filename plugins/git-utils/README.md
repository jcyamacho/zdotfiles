# git-utils

Git helper functions.

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
