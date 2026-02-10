# git-utils (git helper functions for pulling repos): https://git-scm.com/docs

git-pull-all() {
  local base_dir="${1:-$PWD}"

  # If current dir is a git repo, just pull it
  if command git -C "$base_dir" rev-parse --git-dir &>/dev/null; then
    command git -C "$base_dir" pull --ff-only
    return
  fi

  if [[ ! -d "$base_dir" ]]; then
    error "Directory not found: $base_dir"
    return 1
  fi

  info "Pulling all repos in: $base_dir"
  builtin print ""

  local dir

  for dir in "$base_dir"/*(N/); do
    command git -C "$dir" rev-parse --git-dir &>/dev/null || continue

    builtin print -P "%F{cyan}->%f ${dir:t}"

    command git -C "$dir" pull --ff-only 2>&1 | command sed 's/^/  /'

    builtin print ""
  done

  info "Done."
}

git-hook() {
  local hook_name="${1:?Usage: git-hook <hook-name>}"

  command git rev-parse --git-dir &>/dev/null || {
    error "Not a git repository."
    return 1
  }

  # Respect core.hooksPath (set by husky, lefthook, etc.)
  local hooks_dir="$(command git config core.hooksPath 2>/dev/null)"
  if [[ -z "$hooks_dir" ]]; then
    local common_git_dir="$(command git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)"
    hooks_dir="$common_git_dir/hooks"
  fi
  local hook_file="$hooks_dir/$hook_name"

  if [[ ! -f "$hook_file" ]]; then
    command mkdir -p -- "$hooks_dir"
    builtin print -r -- '#!/bin/sh' > "$hook_file"
    command chmod +x -- "$hook_file"
    info "Created $hook_file"
  fi

  edit "$hook_file"
}

alias gpa="git-pull-all"
alias ghk-pre-commit="git-hook pre-commit"
alias ghk-commit-msg="git-hook commit-msg"
alias ghk-post-merge="git-hook post-merge"
alias ghk-post-checkout="git-hook post-checkout"
alias ghk-pre-push="git-hook pre-push"
