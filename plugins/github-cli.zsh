# GITHUB_CLI (GitHub on the command line): https://github.com/cli/cli
if exists gh; then
  _find_gist_id() {
    gh api /gists --jq ".[] | select((.description==\"$1\") and (.public==false)) | .id" | head -n1
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
      info "Updating gist: ${gist_id}"
      gh gist edit "${gist_id}" "${file_path}" --desc "${file_description}"
    else
      info "Creating new gist"
      gh gist create "${file_path}" --desc "${file_description}"
    fi
  }

  load-file-from-gist() {
    local file_path="$1"
    local file_description="$2"

    if [[ -z $file_path || -z $file_description ]]; then
      error "Usage: load-file-from-gist <file_path> <file_description>"
      return 1
    fi

    local gist_filename=$(command basename "${file_path}")
    local gist_id=$(_find_gist_id "${file_description}")
    if [[ -n $gist_id ]]; then
      info "Loading \"${file_description}\" from gist: ${gist_id}"
      gh gist view "${gist_id}" --filename "${gist_filename}" --raw > "${file_path}"
    else
      error "Gist \"${file_description}\" not found"
      return 1
    fi
  }
fi

if ! exists brew; then
  return
fi

if exists gh; then
  uninstall-gh() {
    info "Uninstalling gh-cli..."
    brew uninstall gh
    reload
  }
else
  install-gh() {
    info "Installing gh-cli..."
    brew install gh
    reload
  }
fi
