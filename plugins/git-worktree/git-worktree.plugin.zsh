# git-worktree (helpers for managing git worktrees): https://git-scm.com/docs/git-worktree

alias gwt="git-worktree-new"
alias gwt-new="git-worktree-new"
alias gwt-delete="git-worktree-delete"
alias gwt-rm="git-worktree-delete"
alias gwt-ls="command git worktree list"
alias gwt-prune="command git worktree prune"

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

# Copy gitignored files listed in .worktreeinclude from the main worktree.
# Git's post-checkout hook handles actions (npm install, etc.) but has no
# declarative way to copy files. .worktreeinclude fills that gap.
# Compatible with Claude Code Desktop's convention.
_gwt_copy_worktreeinclude() {
  local repo_root="${1:?}"
  local include_file="$repo_root/.worktreeinclude"
  [[ -f "$include_file" ]] || return 0

  local -a patterns=()
  while IFS= read -r line; do
    line="${line## }"
    line="${line%% }"
    [[ -z "$line" || "$line" == \#* ]] && continue
    if [[ "$line" == \!* ]]; then
      warn "worktreeinclude: negation patterns not supported, skipping: $line"
      continue
    fi
    patterns+=("$line")
  done < "$include_file"

  (( ${#patterns} )) || return 0

  local pattern
  for pattern in "${patterns[@]}"; do
    local -a matches=("$repo_root"/${~pattern}(N))
    local match
    for match in "${matches[@]}"; do
      local rel="${match#$repo_root/}"
      local dest="$PWD/$rel"
      if [[ -d "$match" ]]; then
        command mkdir -p -- "$dest"
        command cp -Rn -- "$match/." "$dest/" 2>/dev/null
        info "worktreeinclude: copied $rel/"
      elif [[ -f "$match" && ! -e "$dest" ]]; then
        command mkdir -p -- "${dest:h}"
        command cp -n -- "$match" "$dest" 2>/dev/null
        info "worktreeinclude: copied $rel"
      fi
    done
  done
}

_gwt_run_setup_hooks() {
  local common_git_dir
  common_git_dir="$(command git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)" || return 0
  local repo_root="${common_git_dir:h}"
  local local_setup="$common_git_dir/setup-worktree.sh"
  local codex_setup="$repo_root/.codex/setup.sh"

  _gwt_copy_worktreeinclude "$repo_root"

  export ROOT_WORKTREE_PATH="$repo_root"
  if [[ -f "$local_setup" ]]; then
    info "Running local setup script: $local_setup"
    source "$local_setup"
  elif [[ -f "$codex_setup" ]]; then
    info "Running Codex setup script: $codex_setup"
    source "$codex_setup"
  else
    builtin print ""
    info "No setup script found. You can:"
    info "  - Place a setup script at: $local_setup"
    info "  - Create a .worktreeinclude file to copy gitignored files."
    info "The environment variable \$ROOT_WORKTREE_PATH will be available in setup scripts."
  fi
  unset ROOT_WORKTREE_PATH
}

git-worktree-new() {
  local branch_name="${1:?Usage: gwt-new <branch-name>}"
  local base_ref="${2:-}"

  local repo_root
  repo_root="$(command git rev-parse --show-toplevel 2>/dev/null)" || {
    error "Not a git repository (or any of the parent directories)."
    return 1
  }

  local worktree_name="${branch_name//\//-}"
  local worktree_path="${GIT_WORKTREE_BASE:-${repo_root:h}}/${repo_root:t}-${worktree_name}"

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

  local branch_name="$(command git -C "$selected_worktree_path" symbolic-ref --quiet --short HEAD 2>/dev/null || :)"

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
