# Setup script for new git worktrees. After `gwt <branch>` creates one, it
# sources this script in a subshell whose current directory is the new
# worktree, then changes into it. Zsh syntax and your shell's functions are
# available, but changes to shell state do not persist.
#
# Available environment variables:
#   $ROOT_WORKTREE_PATH: absolute path to the parent of the Git common
#     directory, which is the main worktree in a regular clone

# Link gitignored files that exist in the root worktree. Edits apply to every
# worktree.
# for shared_file in \
#   ".claude/settings.local.json" ".env" ".envrc" "config/master.key"; do
#   if [[ -f "${ROOT_WORKTREE_PATH}/${shared_file}" ]]; then
#     mkdir -p "${shared_file:h}"
#     ln -sf "${ROOT_WORKTREE_PATH}/${shared_file}" "${shared_file}"
#   fi
# done

# Allow the linked .envrc. direnv authorizes each path, so a link in a new
# worktree is blocked until allowed.
# if [[ -f ".envrc" ]]; then
#   direnv allow
# fi

# Copy local config files that exist in the root worktree.
# for local_config in ".env.local" ".env.development.local"; do
#   if [[ -f "${ROOT_WORKTREE_PATH}/${local_config}" ]]; then
#     cp "${ROOT_WORKTREE_PATH}/${local_config}" "${local_config}"
#   fi
# done

# Link gitignored folders that exist in the root worktree.
# for shared_dir in "data" "models"; do
#   if [[ -d "${ROOT_WORKTREE_PATH}/${shared_dir}" ]]; then
#     ln -sfn "${ROOT_WORKTREE_PATH}/${shared_dir}" "${shared_dir}"
#   fi
# done

# Install dependencies.
# npm ci
# pnpm install --frozen-lockfile
# bun install --frozen-lockfile
# uv sync --locked
# go mod download
# cargo fetch --locked
# dotnet restore
