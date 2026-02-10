# git-utils

Git helper functions with hook support.

## Functions

| Function       | Alias | Description                                              |
| -------------- | ----- | -------------------------------------------------------- |
| `git-pull`     |       | Pull a single repo (fast-forward only) with hook support |
| `git-pull-all` | `gpa` | Pull current repo or all repos in subdirectories         |

## Usage

```zsh
# Pull current repo
git-pull

# Pull a specific repo
git-pull ~/code/my-project

# Pull all repos in current directory
git-pull-all

# Pull all repos in a specific directory
git-pull-all ~/code
```

## Why `--ff-only`?

Both functions use `git pull --ff-only` for safety:

- **Success** = clean fast-forward, no surprises
- **Failure** = local commits diverge from remote, needs manual attention

This prevents accidental merge commits when batch-pulling multiple repos.

## Hook

Place a script at `.git/post-pull.sh` in any repo to run it only when a pull brings new commits.

**Example** (`.git/post-pull.sh`):

```sh
# Install dependencies if lockfile changed
if git diff --name-only HEAD@{1} HEAD | grep -q 'package-lock.json'; then
  npm install
fi

# Run migrations
npm run db:migrate
```

The hook:

- Runs in a subshell (won't affect your current shell)
- Only runs when a successful pull advances `HEAD`
- Stays local (inside `.git/`, not committed)
