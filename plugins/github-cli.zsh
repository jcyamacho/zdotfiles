# GITHUB_CLI (GitHub on the command line): https://github.com/cli/cli
if exists gh; then
  _find_gist_id() {
    local gist_description=${1:?_find_gist_id: missing gist description}
    local jq_description=${gist_description//\\/\\\\}
    jq_description=${jq_description//"/\\"}

    command gh api /gists --jq ".[] | select((.description==\"${jq_description}\") and (.public==false)) | .id" | command head -n1
  }

  save-file-to-gist() {
    local file_path="$1"
    local file_description="$2"

    if [[ -z $file_path || -z $file_description ]]; then
      error "Usage: save-file-to-gist <file_path> <file_description>"
      return 1
    fi

    local gist_id=$(_find_gist_id "${file_description}")
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

    local gist_filename="${file_path:t}"
    local gist_id=$(_find_gist_id "${file_description}")
    if [[ -n $gist_id ]]; then
      info "Loading \"${file_description}\" from gist: ${gist_id}"
      command gh gist view "${gist_id}" --filename "${gist_filename}" --raw > "${file_path}"
    else
      error "Gist \"${file_description}\" not found"
      return 1
    fi
  }

  save-dir-to-gist() {
    local dir_path="$1"
    local dir_description="$2"

    if [[ -z $dir_path || -z $dir_description ]]; then
      error "Usage: save-dir-to-gist <dir_path> <dir_description>"
      return 1
    fi

    if [[ ! -d $dir_path ]]; then
      error "Directory not found: ${dir_path}"
      return 1
    fi

    local files=()
    for f in "${dir_path}"/*(N.); do
      [[ -s $f ]] && files+=("$f")
    done

    if [[ ${#files[@]} -eq 0 ]]; then
      warn "No non-empty files found in ${dir_path}, nothing to save"
      return
    fi

    local gist_id=$(_find_gist_id "${dir_description}")
    if [[ -n $gist_id ]]; then
      info "Updating gist: ${gist_id} (${dir_description}) with ${#files[@]} files"
      for f in "${files[@]}"; do
        info "Adding/Updating ${f:t}..."
        command gh gist edit "${gist_id}" --add "$f"
      done
    else
      info "Creating new gist (${dir_description}) with ${#files[@]} files"
      command gh gist create "${files[@]}" --desc "${dir_description}"
    fi
  }

  load-dir-from-gist() {
    local dir_path="$1"
    local dir_description="$2"

    if [[ -z $dir_path || -z $dir_description ]]; then
      error "Usage: load-dir-from-gist <dir_path> <dir_description>"
      return 1
    fi

    local gist_id=$(_find_gist_id "${dir_description}")
    if [[ -z $gist_id ]]; then
      error "Gist \"${dir_description}\" not found"
      return 1
    fi

    info "Loading files from gist: ${gist_id}"
    command mkdir -p -- "${dir_path}"

    local filenames
    filenames=$(command gh api "/gists/${gist_id}" --jq '.files | keys[]')

    while IFS= read -r filename; do
      info "Restoring ${filename}..."
      command gh gist view "${gist_id}" --filename "${filename}" --raw > "${dir_path}/${filename}"
    done <<< "$filenames"
  }
fi

if ! exists brew; then
  return
fi

if exists gh; then
  uninstall-gh() {
    info "Uninstalling gh-cli..."
    command brew uninstall gh
    reload
  }
else
  install-gh() {
    info "Installing gh-cli..."
    command brew install gh
    reload
  }
fi
