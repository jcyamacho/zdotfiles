# git-worktree (helpers for managing git worktrees): https://git-scm.com/docs/git-worktree

alias gwt-ls="command git worktree list"
alias gwt-prune="command git worktree prune"

# Worktrees are identified by the basename of their directory, which is what the
# completions offer and what gwts/gwt-rm resolve back to a path. A worktree in
# detached HEAD has no branch, so the directory name is the only always-present
# handle.
_gwt_worktree_paths() {
  GIT_OPTIONAL_LOCKS=0 command git worktree list --porcelain 2>/dev/null \
    | command awk '$1 == "worktree" { print substr($0, 10) }'
}

_gwt_path_for() {
  local name="${1:?_gwt_path_for: missing worktree name}"

  local worktree
  for worktree in "${(@f)$(_gwt_worktree_paths)}"; do
    if [[ "${worktree:t}" == "$name" ]]; then
      builtin print -r -- "$worktree"
      return 0
    fi
  done

  return 1
}

# gwt takes a branch name, plus an optional base ref that only applies when the
# branch does not exist yet. Branches that already have a worktree are dropped
# from the first argument because `git worktree add` refuses them.
_gwt() {
  local refs
  refs="$(GIT_OPTIONAL_LOCKS=0 command git for-each-ref \
    --format='%(refname:short)' --exclude=refs/remotes/origin/HEAD \
    refs/heads refs/remotes/origin 2>/dev/null)"
  [[ -n "$refs" ]] || return 1

  local -aU branches=("${(@f)refs}")
  branches=("${(@)branches#origin/}")

  local expl
  if (( CURRENT > 2 )); then
    _wanted refs expl 'base ref' compadd -a branches
    return
  fi

  local -a attached
  attached=("${(@f)$(GIT_OPTIONAL_LOCKS=0 command git worktree list --porcelain 2>/dev/null \
    | command awk '$1 == "branch" { sub(/^refs\/heads\//, "", $2); print $2 }')}")
  branches=("${(@)branches:|attached}")

  _wanted branches expl branch compadd -a branches
}

compdef _gwt gwt

# Offer "<directory name>:<branch>" so the menu shows which branch each worktree
# holds while completing the directory name.
_gwt_worktree_descriptions() {
  GIT_OPTIONAL_LOCKS=0 command git worktree list --porcelain 2>/dev/null \
    | command awk '
        $1 == "worktree" { n = split(substr($0, 10), parts, "/"); name = parts[n] }
        $1 == "branch"   { sub(/^refs\/heads\//, "", $2); print name ":" $2 }
        $1 == "detached" { print name ":detached HEAD" }
      '
}

# Both completions drop what the command would reject anyway: switching to the
# current worktree is a no-op, and removing the current or main one errors out.
_gwt_complete_worktrees() {
  local -a worktrees=("${(@f)$(_gwt_worktree_descriptions)}")
  local name
  for name in "$@"; do
    worktrees=("${(@)worktrees:#${name}:*}")
  done
  (( $#worktrees )) || return 1

  _describe -t worktrees worktree worktrees
}

_gwts() {
  local current
  current="$(GIT_OPTIONAL_LOCKS=0 command git rev-parse --show-toplevel 2>/dev/null)" || return 1

  _gwt_complete_worktrees "${current:t}"
}

_gwt-rm() {
  local current main
  current="$(GIT_OPTIONAL_LOCKS=0 command git rev-parse --show-toplevel 2>/dev/null)" || return 1
  main="$(_gwt_worktree_paths | command head -1)"

  _gwt_complete_worktrees "${current:t}" "${main:t}"
}

compdef _gwts gwts
compdef _gwt-rm gwt-rm

# Detect the default branch name from origin.
# IMPORTANT: Do NOT change the primary detection strategy (see below).
_gwt_default_branch() {
  # Strategy 1: query the remote directly (most reliable).
  # This returns the actual HEAD branch configured on the remote, regardless
  # of local state. Requires network access.
  local default_branch
  default_branch="$(command git remote show origin 2>/dev/null \
    | command grep 'HEAD branch' | command awk '{print $NF}')"

  # Strategy 2: read the local cached ref (offline-safe).
  # Set by `git clone` or `git remote set-head`. Can be stale or missing
  # if the remote HEAD changed since the last clone/fetch.
  if [[ -z "$default_branch" ]]; then
    default_branch="$(command git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null)"
    default_branch="${default_branch#origin/}"
  fi

  # Strategy 3: hardcoded fallback.
  builtin print -r -- "${default_branch:-main}"
}

_gwt_run_setup_hooks() {
  local common_git_dir
  common_git_dir="$(command git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)" || return 0
  local setup_script="$common_git_dir/setup-worktree.zsh"

  if [[ ! -f "$setup_script" ]]; then
    builtin print ""
    info "No setup script found. Run gwt-setup to create one at:"
    info "  $setup_script"
    return 0
  fi

  info "Running setup script: $setup_script"

  # Sourced rather than executed so the script can affect the new shell state,
  # and $ROOT_WORKTREE_PATH lets it reach back into the main worktree.
  export ROOT_WORKTREE_PATH="${common_git_dir:h}"
  source "$setup_script"
  unset ROOT_WORKTREE_PATH
}

gwt() {
  local branch_name="${1:?Usage: gwt <branch-name>}"
  local base_ref="${2:-}"

  local repo_root
  repo_root="$(command git rev-parse --show-toplevel 2>/dev/null)" || {
    error "Not a git repository (or any of the parent directories)."
    return 1
  }

  local worktree_name="${branch_name//\//-}"
  local worktree_path="${GIT_WORKTREE_BASE:-${repo_root:h}}/${repo_root:t}.${worktree_name}"

  if command git show-ref --verify --quiet "refs/heads/$branch_name"; then
    # Local branch exists -- attach a worktree to it
    [[ -n "$base_ref" ]] && warn "Ignoring base ref '$base_ref': local branch '$branch_name' already exists."
    info "Creating worktree at '$worktree_path' for local branch '$branch_name'..."
    command git worktree add "$worktree_path" "$branch_name" || return 1

  elif command git fetch origin "$branch_name" 2>/dev/null \
    && command git show-ref --verify --quiet "refs/remotes/origin/$branch_name"; then
    # Remote branch exists -- worktree will create a local tracking branch
    [[ -n "$base_ref" ]] && warn "Ignoring base ref '$base_ref': remote branch '$branch_name' already exists."
    info "Creating worktree at '$worktree_path' for remote branch '$branch_name'..."
    command git worktree add "$worktree_path" "$branch_name" || return 1

  else
    # New branch -- resolve base_ref from origin's default branch
    if [[ -z "$base_ref" ]]; then
      local default_branch="$(_gwt_default_branch)"

      info "Fetching latest '$default_branch' from origin..."
      command git fetch origin "$default_branch"

      base_ref="origin/$default_branch"
    fi

    info "Creating worktree at '$worktree_path' with new branch from '$base_ref'..."
    command git worktree add -b "$branch_name" "$worktree_path" "$base_ref" || return 1
    command git -C "$worktree_path" branch --unset-upstream 2>/dev/null || :
  fi

  builtin cd "$worktree_path" || return 1

  _gwt_run_setup_hooks

  builtin print ""
  info "Now in worktree '${PWD:t}'."
}

_gwt_force_remove_error() {
  local output="${1:-}"

  [[ "$output" == *"contains modified or untracked files"* \
    || "$output" == *"cannot be moved or removed"* \
    || "$output" == *"use --force"* ]]
}

gwt-rm() {
  local name="${1:?Usage: gwt-rm <worktree>}"

  local selected_worktree_path
  selected_worktree_path="$(_gwt_path_for "$name")" || {
    error "No worktree named '$name'."
    return 1
  }

  # `git worktree list` always reports the main worktree first. --show-toplevel
  # cannot be used here: it reports whichever worktree we are standing in, so it
  # left the real main worktree unprotected from any other worktree.
  local main_worktree
  main_worktree="$(_gwt_worktree_paths | command head -1)"
  if [[ "$selected_worktree_path" == "$main_worktree" ]]; then
    error "Cannot delete the main worktree."
    return 1
  fi

  # Compared against the worktree root rather than $PWD so that standing in a
  # subdirectory of the target still counts as being inside it.
  local current_worktree
  current_worktree="$(GIT_OPTIONAL_LOCKS=0 command git rev-parse --show-toplevel 2>/dev/null)"
  if [[ "$selected_worktree_path" == "$current_worktree" ]]; then
    error "Cannot delete the current worktree. Move out first."
    return 1
  fi

  local branch_name="$(command git -C "$selected_worktree_path" symbolic-ref --quiet --short HEAD 2>/dev/null || :)"

  info "Removing worktree at $selected_worktree_path"
  local remove_output
  remove_output="$(command git worktree remove "$selected_worktree_path" 2>&1)"
  local remove_status=$?
  if (( remove_status != 0 )); then
    if _gwt_force_remove_error "$remove_output"; then
      [[ -n "$remove_output" ]] && warn "$remove_output"
      confirm "Force remove dirty worktree '$selected_worktree_path'?" no || {
        info "Skipped worktree removal."
        return 1
      }
      command git worktree remove --force "$selected_worktree_path" || return 1
    else
      [[ -n "$remove_output" ]] && builtin print -u2 -r -- "$remove_output"
      return "$remove_status"
    fi
  fi

  if [[ -n "$branch_name" ]]; then
    if confirm "Delete associated branch '$branch_name'?" no; then
      command git branch -D "$branch_name"
    fi
  fi
}

gwts() {
  local name="${1:?Usage: gwts <worktree>}"

  local target
  target="$(_gwt_path_for "$name")" || {
    error "No worktree named '$name'."
    return 1
  }

  if [[ "$target" == "$PWD" ]]; then
    info "Already in worktree '$name'."
    return
  fi

  builtin cd "$target" || return 1

  builtin print ""
  info "Switched to worktree '${PWD:t}'."
}

gwt-setup() {
  command git rev-parse --git-dir &>/dev/null || {
    error "Not a git repository."
    return 1
  }

  local common_git_dir
  common_git_dir="$(command git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)"
  local setup_file="$common_git_dir/setup-worktree.zsh"

  if [[ ! -f "$setup_file" ]]; then
    local template="$ZDOTFILES_DIR/plugins/git-worktree/templates/setup-worktree.zsh"
    command cp -- "$template" "$setup_file"
    info "Created $setup_file (from template)"
  fi

  edit-open "$setup_file"
}
