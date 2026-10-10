# java (verified Maven and Gradle distributions): https://maven.apache.org/install.html

_java_install_distribution() {
  local tool="${1:?missing tool}"
  local version="${2:?missing version}"
  local url="${3:?missing distribution URL}"
  local algorithm="${4:?missing checksum algorithm}"
  local archive_dir="${5:?missing archive directory}"
  local binary="${6:?missing executable}"

  local destination="$CUSTOM_TOOLS_DIR/.java/$tool"
  if [[ -r "$destination/version" && "$(< "$destination/version")" == "$version" ]]; then
    info "$tool $version is already installed"
    return 0
  fi

  if [[ -z ${JAVA_HOME:-} || ! -x "$JAVA_HOME/bin/java" || ! -x "$JAVA_HOME/bin/javac" ]]; then
    error "Set JAVA_HOME to an installed JDK before installing $tool"
    return 1
  fi

  local tmp
  command mkdir -p -- "$CUSTOM_TOOLS_DIR/.java" || return
  tmp="$(command mktemp -d "$CUSTOM_TOOLS_DIR/.java/.$tool.XXXXXX")" || return

  info "Installing $tool $version..."
  {
    local checksum actual
    checksum="$(command curl --proto '=https' --proto-redir '=https' --tlsv1.2 -fsSL "$url.sha$algorithm")" || return
    checksum="${checksum%%[[:space:]]*}"

    command curl --proto '=https' --proto-redir '=https' --tlsv1.2 -fsSL "$url" -o "$tmp/distribution" || return
    actual="$(command shasum -a "$algorithm" "$tmp/distribution")" || return
    if [[ "${actual%% *}" != "${checksum:l}" ]]; then
      error "$tool checksum mismatch"
      return 1
    fi

    command tar -xf "$tmp/distribution" -C "$tmp" || return

    command "$tmp/$archive_dir/bin/$binary" --version > /dev/null || {
      error "$tool $version could not run with JAVA_HOME=$JAVA_HOME"
      return 1
    }
    builtin print -r -- "$version" > "$tmp/$archive_dir/version" || return

    if [[ -d "$destination" ]]; then
      command mv -- "$destination" "$tmp/previous" || return
    fi
    command mv -- "$tmp/$archive_dir" "$destination" || return
  } always {
    command rm -rf -- "$tmp"
  }
}
