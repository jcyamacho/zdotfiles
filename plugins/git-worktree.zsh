# git-worktree (helpers for managing git worktrees): https://git-scm.com/docs/git-worktree

alias gwt-new="git-worktree-new"
alias gwt-delete="git-worktree-delete"
alias gwt-rm="git-worktree-delete"
alias gwt-ls="command git worktree list"
alias gwt-prune="command git worktree prune"

git-worktree-new() {
  local branch_name="${1:?Usage: gwt-new <branch-name>}"
  local base_ref="${2:-}"

  # Check if branch already exists
  if command git show-ref --verify --quiet "refs/heads/$branch_name"; then
    error "Branch '$branch_name' already exists. Use a different name or delete it first."
    return 1
  fi

  local repo_root
  repo_root="$(command git rev-parse --show-toplevel 2>/dev/null)" || {
    error "Not a git repository (or any of the parent directories)."
    return 1
  }

  local actual_repo_name="${repo_root:t}"

  if [[ -z "$base_ref" ]]; then
    # Get default branch from origin (most reliable)
    local default_branch="$(command git remote show origin 2>/dev/null | command grep 'HEAD branch' | command awk '{print $NF}')"
    : "${default_branch:=main}"

    info "Fetching latest '$default_branch' from origin..."
    command git fetch origin "$default_branch:$default_branch" 2>/dev/null || command git fetch origin "$default_branch"

    base_ref="origin/$default_branch"
  fi

  local worktree_name="${branch_name//\//-}"
  local worktree_path="${GIT_WORKTREE_BASE:-${repo_root:h}}/${actual_repo_name}-${worktree_name}"

  info "Creating worktree at '$worktree_path' branched from '$base_ref'..."
  command git worktree add -b "$branch_name" "$worktree_path" "$base_ref" || return 1

  # Change to the new worktree directory in the current shell
  builtin cd "$worktree_path" || return 1

  # Hook system: run setup script if it exists
  local common_git_dir="$(command git rev-parse --git-common-dir 2>/dev/null)"
  local local_setup="$common_git_dir/setup-worktree.sh"
  local repo_setup="$repo_root/.git-setup-worktree.sh"

  export ROOT_WORKTREE_PATH="$repo_root"
  if [[ -f "$local_setup" ]]; then
    info "Running local setup script: $local_setup"
    source "$local_setup"
  elif [[ -f "$repo_setup" ]]; then
    info "Running repo setup script: $repo_setup"
    source "$repo_setup"
  else
    builtin print ""
    info "Hook system: No setup script found. You can place a setup script at:"
    info "  - $local_setup (local only)"
    info "  - $repo_setup (shared in repo)"
    info "The environment variable \$ROOT_WORKTREE_PATH will be available."
  fi
  unset ROOT_WORKTREE_PATH

  builtin print ""
  info "Now in worktree '${PWD:t}'."
}

git-worktree-delete() {
  exists fzf || { error "fzf is required for git-worktree-delete"; return 1; }

  local selected_worktree_path
  selected_worktree_path="$(
    command git worktree list --porcelain \
      | command awk '$1 == "worktree" { print substr($0, 10) }' \
      | fzf --header "Select worktree to DELETE" --height 40%
  )"
  [[ -z "$selected_worktree_path" ]] && return

  # Don't allow deleting the current or main worktree easily
  local main_path="$(command git rev-parse --show-toplevel 2>/dev/null)"
  if [[ "$selected_worktree_path" == "$main_path" ]]; then
    error "Cannot delete the main worktree."
    return 1
  fi

  if [[ "$selected_worktree_path" == "$PWD" ]]; then
    error "Cannot delete the current worktree. Move out first."
    return 1
  fi

  local branch_name
  branch_name="$(command git -C "$selected_worktree_path" symbolic-ref --quiet --short HEAD 2>/dev/null || :)"

  info "Removing worktree at $selected_worktree_path"
  command git worktree remove "$selected_worktree_path" || return 1

  if [[ -n "$branch_name" ]]; then
    warn "Delete associated branch '$branch_name'? (Y/n)"
    local choice
    builtin read -k 1 "choice? "
    builtin print ""
    if [[ "$choice" != [nN] ]]; then
      command git branch -D "$branch_name"
    fi
  fi
}
