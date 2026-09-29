# maven (Java build tool): https://maven.apache.org/

_java_install_maven() {
  local listing line version
  local -a versions=()
  listing="$(command curl --proto '=https' --proto-redir '=https' --tlsv1.2 -fsSL https://downloads.apache.org/maven/maven-3/)" || return

  for line in "${(@f)listing}"; do
    if [[ "$line" =~ 'href="(3\.[0-9]+\.[0-9]+)/"' ]]; then
      versions+=("$match[1]")
    fi
  done
  (( $#versions )) || { error "Could not find a stable Maven 3 release"; return 1; }
  versions=("${(@On)versions}")
  version="$versions[1]"

  _java_install_distribution maven "$version" \
    "https://downloads.apache.org/maven/maven-3/$version/binaries/apache-maven-$version-bin.tar.gz" \
    512 "apache-maven-$version" mvn
}

if [[ -x "$CUSTOM_TOOLS_DIR/.java/maven/bin/mvn" ]]; then
  path=("$CUSTOM_TOOLS_DIR/.java/maven/bin" "${path[@]}")

  uninstall-maven() {
    info "Uninstalling Maven..."
    command rm -rf -- "$CUSTOM_TOOLS_DIR/.java/maven" || return
    path=("${(@)path:#$CUSTOM_TOOLS_DIR/.java/maven/bin}")
    reload
  }

  _update_maven() {
    info "Updating Maven..."
    _java_install_maven
  }

  update-maven() {
    _update_maven || return
    reload
  }

  updates+=(_update_maven)
elif ! exists mvn; then
  install-maven() {
    _java_install_maven || return
    reload
  }
fi
