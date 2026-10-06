# java (Amazon Corretto LTS JDK): https://aws.amazon.com/corretto/

typeset -aU _java_versions=(25 21)
typeset _java_version _java_home

# macOS provides java launchers even when no JDK is installed.
for _java_version in "${_java_versions[@]}"; do
  _java_home="/Library/Java/JavaVirtualMachines/amazon-corretto-$_java_version.jdk/Contents/Home"

  if [[ -x "$_java_home/bin/java" && -x "$_java_home/bin/javac" ]]; then
    if (( ! ${+JAVA_HOME} )); then
      JAVA_HOME="$_java_home"
    fi

    functions[uninstall-java-$_java_version]="
      info \"Uninstalling Amazon Corretto $_java_version...\"
      command brew uninstall --cask corretto@$_java_version || return
      reload
    "
  else
    functions[install-java-$_java_version]="
      info \"Installing Amazon Corretto $_java_version...\"
      command brew install --no-ask --cask corretto@$_java_version || return
      reload
    "
  fi
done
unset _java_versions _java_version _java_home

if (( ${+JAVA_HOME} )); then
  export JAVA_HOME
  if [[ -n "$JAVA_HOME" && -x "$JAVA_HOME/bin/java" && -x "$JAVA_HOME/bin/javac" ]]; then
    path=("$JAVA_HOME/bin" "${path[@]}")
  fi
fi
