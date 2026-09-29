# gradle (JVM build tool): https://gradle.org/

_java_install_gradle() {
  local metadata version
  metadata="$(command curl --proto '=https' --proto-redir '=https' --tlsv1.2 -fsSL https://services.gradle.org/versions/current)" || return
  if [[ "$metadata" =~ '"version"[[:space:]]*:[[:space:]]*"([0-9]+\.[0-9]+\.[0-9]+)"' ]]; then
    version="$match[1]"
  else
    error "Could not find a stable Gradle release"
    return 1
  fi

  _java_install_distribution gradle "$version" \
    "https://services.gradle.org/distributions/gradle-$version-bin.zip" \
    256 "gradle-$version" gradle
}

if [[ -x "$CUSTOM_TOOLS_DIR/.java/gradle/bin/gradle" ]]; then
  path=("$CUSTOM_TOOLS_DIR/.java/gradle/bin" "${path[@]}")

  uninstall-gradle() {
    info "Uninstalling Gradle..."
    command rm -rf -- "$CUSTOM_TOOLS_DIR/.java/gradle" || return
    path=("${(@)path:#$CUSTOM_TOOLS_DIR/.java/gradle/bin}")
    reload
  }

  _update_gradle() {
    info "Updating Gradle..."
    _java_install_gradle
  }

  update-gradle() {
    _update_gradle || return
    reload
  }

  updates+=(_update_gradle)
elif ! exists gradle; then
  install-gradle() {
    _java_install_gradle || return
    reload
  }
fi
