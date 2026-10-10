# git shorthands (aliases plus origin pull/push helpers): https://git-scm.com/

_git_current_branch() {
  command git symbolic-ref --quiet --short HEAD 2>/dev/null && return
  error "Not on a branch (detached HEAD or not a git repository)."
  return 1
}

ggl() {
  if (( $# )); then
    command git pull origin "$@"
    return
  fi

  local branch
  branch="$(_git_current_branch)" || return

  command git pull origin "$branch"
}

ggp() {
  # Explicit arguments pass through untouched so refspecs and flags such as
  # --delete keep working; --set-upstream only makes sense for the branch we
  # resolved ourselves.
  if (( $# )); then
    command git push origin "$@"
    return
  fi

  local branch
  branch="$(_git_current_branch)" || return

  # Only adopt origin as upstream when the branch has none, so a branch that
  # deliberately tracks another remote is never repointed.
  local -a upstream_flag=()
  command git rev-parse --verify --quiet "$branch@{upstream}" >/dev/null \
    || upstream_flag=(--set-upstream)

  command git push "${upstream_flag[@]}" origin "$branch"
}

# ggl and ggp already target origin, so their arguments are branch names. The
# _git-pull/_git-push services would offer repositories instead: remotes, local
# directories and ssh hosts, none of which are valid here. Local and origin
# branches are merged because ggl pulls one that exists on origin while ggp
# pushes a local one.
_ggl_ggp() {
  local refs
  refs="$(command git for-each-ref \
    --format='%(refname:short)' --exclude=refs/remotes/origin/HEAD \
    refs/heads refs/remotes/origin 2>/dev/null)"
  [[ -n "$refs" ]] || return 1

  local -aU branches=("${(@f)refs}")
  branches=("${(@)branches#origin/}")

  local expl
  _wanted branches expl branch compadd -a branches
}

compdef _ggl_ggp ggl ggp

alias g="command git"
alias gaa="command git add --all"
alias gf="command git fetch"
alias gcb="command git checkout -b"
alias gcmsg="command git commit --message"
alias 'gc!'="command git commit --verbose --amend"
