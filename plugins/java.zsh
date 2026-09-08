# java (Amazon Corretto LTS JDK): https://aws.amazon.com/corretto/

typeset _java_home="/Library/Java/JavaVirtualMachines/amazon-corretto-25.jdk/Contents/Home"

# macOS provides java launchers even when no JDK is installed.
if [[ -x "$_java_home/bin/java" && -x "$_java_home/bin/javac" ]]; then
  if [[ -z ${JAVA_HOME:-} || ! -x "$JAVA_HOME/bin/java" || ! -x "$JAVA_HOME/bin/javac" ]]; then
    JAVA_HOME="$_java_home"
  fi

  export JAVA_HOME
  path=("$JAVA_HOME/bin" "${path[@]}")

  if exists brew; then
    uninstall-java() {
      info "Uninstalling Amazon Corretto 25..."
      command brew uninstall --cask corretto@25 || return
      reload
    }
  fi
elif exists brew; then
  install-java() {
    info "Installing Amazon Corretto 25..."
    command brew install --no-ask --cask corretto@25 || return
    reload
  }
fi

unset _java_home
