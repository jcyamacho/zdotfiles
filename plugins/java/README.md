# Java tooling

Java, Maven, and Gradle have separate installers. Loading the plugin does not
download or install them.

## Java

`install-java-25` and `install-java-21` install Amazon Corretto 25 LTS and
21 LTS through Homebrew on macOS. Each installer is available when its JDK is
missing. Both versions can be installed together. `uninstall-java-25` and
`uninstall-java-21` remove the corresponding cask; `update-brew` handles patch
updates.

When `JAVA_HOME` is unset, the plugin selects the first installed Corretto JDK
in this order: 25, then 21. It requires both `java` and `javac`. An explicitly
defined `JAVA_HOME` is preserved, including an empty or invalid value.
The variable is exported when defined, and its `bin` directory is added to
`PATH` only when it points to a valid JDK.

To select a version explicitly, set `JAVA_HOME` before loading the dotfiles.
To repeat automatic selection in the current shell, run `unset JAVA_HOME`
followed by `reload`.

## Maven and Gradle

With a JDK configured in `JAVA_HOME`, run either or both:

```sh
install-maven
install-gradle
```

Maven and Gradle install from their official binary distributions under
`$CUSTOM_TOOLS_DIR/.java/maven` and `$CUSTOM_TOOLS_DIR/.java/gradle`. Their `bin`
directories are added to `PATH`. They use the existing JDK; no additional JDK
or version manager is installed.

Maven uses the latest stable Maven 3 release from Apache's download directory.
Gradle uses the current stable release from Gradle's version API. Downloads
are checked against the official SHA-512 (Maven) or SHA-256 (Gradle) checksum.
The new distribution must run with `JAVA_HOME` before replacing an existing
installation.

- `update-maven` and `update-gradle` install the current release and reload.
  Both also participate in `update-all`.
- `uninstall-maven` and `uninstall-gradle` remove only their managed
  distributions. Dependency caches and project files are preserved.
- Tools already available from another installation are left to their owner;
  this plugin does not define lifecycle commands for them.

Updates can change the default build tool version, including Gradle's major
version. Use the project's `./mvnw` or `./gradlew` when available to build with
the version declared by that project.
