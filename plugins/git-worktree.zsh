# git-worktree (helpers for managing git worktrees): https://git-scm.com/docs/git-worktree

alias gwt-new="git-worktree-new"
alias gwt-delete="git-worktree-delete"
alias gwt-rm="git-worktree-delete"
alias gwt-ls="command git worktree list"
alias gwt-prune="command git worktree prune"

git-worktree-new() {
  local branch_name="${1:?Usage: gwt-new <branch-name>}"

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

  # Get default branch from origin (most reliable)
  local default_branch="$(command git remote show origin 2>/dev/null | command grep 'HEAD branch' | command awk '{print $NF}')"
  : "${default_branch:=main}"


  info "Fetching latest '$default_branch' from origin..."
  command git fetch origin "$default_branch:$default_branch" 2>/dev/null || command git fetch origin "$default_branch"

  local worktree_name="${branch_name//\//-}"
  local worktree_path="${GIT_WORKTREE_BASE:-${repo_root:h}}/${actual_repo_name}-${worktree_name}"

  info "Creating worktree at '$worktree_path' branched from 'origin/$default_branch'..."
  command git worktree add -b "$branch_name" "$worktree_path" "origin/$default_branch" || return 1

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

  local selected="$(command git worktree list | fzf --header "Select worktree to DELETE" --height 40%)"
  [[ -z "$selected" ]] && return

  local wt_path="$(builtin print -r -- "$selected" | command awk '{print $1}')"

  # Don't allow deleting the current or main worktree easily
  local main_path="$(command git rev-parse --show-toplevel 2>/dev/null)"
  if [[ "$wt_path" == "$main_path" ]]; then
    error "Cannot delete the main worktree."
    return 1
  fi

  if [[ "$wt_path" == "$PWD" ]]; then
    error "Cannot delete the current worktree. Move out first."
    return 1
  fi

  local branch="$(builtin print -r -- "$selected" | command grep -o '\[.*\]$' | command tr -d '[]')"

  info "Removing worktree at $wt_path"
  command git worktree remove "$wt_path" || return 1

  if [[ -n "$branch" ]]; then
    warn "Delete associated branch '$branch'? (Y/n)"
    local choice
    builtin read -k 1 "choice? "
    builtin print ""
    if [[ "$choice" != [nN] ]]; then
      command git branch -D "$branch"
    fi
  fi
}
