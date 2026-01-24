# git-utils (git helper functions for pulling repos)

# Pull a single repo with optional post-pull hook
git-pull() {
  local dir="${1:-$PWD}"

  if [[ ! -d "$dir/.git" ]]; then
    error "Not a git repository: $dir"
    return 1
  fi

  local before_head after_head
  before_head="$(command git -C "$dir" rev-parse HEAD 2>/dev/null || :)"

  command git -C "$dir" pull --ff-only || return 1

  after_head="$(command git -C "$dir" rev-parse HEAD 2>/dev/null || :)"

  # Hook: run post-pull script only when new commits land
  if [[ -n "$after_head" && "$before_head" != "$after_head" ]]; then
    local hook_script="$dir/.git/post-pull.sh"
    if [[ -f "$hook_script" ]]; then
      info "Running post-pull hook..."
      ( builtin cd "$dir" && source "$hook_script" ) || return 1
    fi
  fi

  return 0
}

# Pull all repos in a directory (or current repo if in one)
git-pull-all() {
  local base_dir="${1:-$PWD}"

  # If current dir is a git repo, just pull it
  if [[ -d "$base_dir/.git" ]]; then
    git-pull "$base_dir"
    return
  fi

  if [[ ! -d "$base_dir" ]]; then
    error "Directory not found: $base_dir"
    return 1
  fi

  info "Pulling all repos in: $base_dir"
  builtin print ""

  local pulled=0
  local failed=0
  local dir

  for dir in "$base_dir"/*(N/); do
    [[ -d "$dir/.git" ]] || continue

    builtin print -P "%F{cyan}->%f ${dir:t}"

    if git-pull "$dir" 2>&1 | command sed 's/^/  /'; then
      ((pulled++))
    else
      ((failed++))
    fi

    builtin print ""
  done

  info "Done: $pulled pulled, $failed failed"
}

alias gpa="git-pull-all"
