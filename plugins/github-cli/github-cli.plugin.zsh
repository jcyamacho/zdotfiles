# github-cli (GitHub on the command line): https://github.com/cli/cli
if exists gh; then
  cache-completion gh completion --shell zsh

  _find_gist_id() {
    local gist_description="${1:?_find_gist_id: missing gist description}"
    local jq_description="${gist_description//\\/\\\\}"
    jq_description=${jq_description//\"/\\\"}

    local output
    output="$(command gh api /gists --paginate --jq ".[] | select((.description==\"${jq_description}\") and (.public==false)) | .id")" || return

    local -a ids=("${(@f)output}")
    builtin print -r -- "${ids[1]}"
  }

  save-file-to-gist() {
    local file_path="$1"
    local file_description="$2"

    if [[ -z $file_path || -z $file_description ]]; then
      error "Usage: save-file-to-gist <file_path> <file_description>"
      return 1
    fi

    local gist_id
    gist_id="$(_find_gist_id "$file_description")" || return
    if [[ -n $gist_id ]]; then
      info "Updating gist: ${gist_id} (${file_description})"
      command gh gist edit "${gist_id}" "${file_path}" --desc "${file_description}"
    else
      info "Creating new gist: ${file_description}"
      command gh gist create "${file_path}" --desc "${file_description}"
    fi
  }

  load-file-from-gist() {
    local file_path="$1"
    local file_description="$2"

    if [[ -z $file_path || -z $file_description ]]; then
      error "Usage: load-file-from-gist <file_path> <file_description>"
      return 1
    fi

    local gist_id
    gist_id="$(_find_gist_id "$file_description")" || return
    if [[ -z $gist_id ]]; then
      error "Gist \"${file_description}\" not found"
      return 1
    fi

    if [[ -L "$file_path" && ! -e "$file_path" ]]; then
      error "Cannot load gist into dangling symlink: $file_path"
      return 1
    fi

    local gist_filename="${file_path:t}"
    local target_path="${file_path:A}"
    local target_dir="${target_path:h}"
    command mkdir -p -- "$target_dir" || return

    local tmp
    tmp="$(command mktemp "${target_path}.XXXXXX")" || return

    {
      if [[ -e "$target_path" ]]; then
        command cp -p -- "$target_path" "$tmp" || return
      else
        command chmod '=rw' "$tmp" || return
      fi

      info "Loading \"${file_description}\" from gist: ${gist_id}"
      command gh gist view "$gist_id" --filename "$gist_filename" --raw >| "$tmp" || return

      command mv -f -- "$tmp" "$target_path"
    } always {
      command rm -f -- "$tmp"
    }
  }

else
  _require-gh() {
    error "GitHub CLI is required. Run install-gh."
    return 1
  }

  save-file-to-gist() { _require-gh; }
  load-file-from-gist() { _require-gh; }
fi

exists brew || return

if exists gh; then
  uninstall-gh() {
    info "Uninstalling gh-cli..."
    command brew uninstall gh || return
    reload
  }
else
  install-gh() {
    info "Installing gh-cli..."
    command brew install --no-ask gh || return
    reload
  }
fi
