# java

Provides commands that install
[Amazon Corretto](https://aws.amazon.com/corretto/) JDKs with Homebrew, and
[Maven](https://maven.apache.org/) and [Gradle](https://gradle.org/) from their
official binary distributions. The plugin also selects an installed JDK for
`JAVA_HOME`; loading it installs nothing.

## Commands

| Command | Description |
| --- | --- |
| `install-java-25` | Install Amazon Corretto 25 with Homebrew (`corretto@25` cask) |
| `install-java-21` | Install Amazon Corretto 21 with Homebrew (`corretto@21` cask) |
| `uninstall-java-25` | Uninstall the `corretto@25` cask; if `JAVA_HOME` points to it, select another JDK |
| `uninstall-java-21` | Uninstall the `corretto@21` cask; if `JAVA_HOME` points to it, select another JDK |
| `install-maven` | Install the newest Maven 3 release |
| `update-maven` | Replace the installed Maven with the newest Maven 3 release |
| `uninstall-maven` | Delete `$CUSTOM_TOOLS_DIR/.java/maven` |
| `install-gradle` | Install the current Gradle release |
| `update-gradle` | Replace the installed Gradle with the current release |
| `uninstall-gradle` | Delete `$CUSTOM_TOOLS_DIR/.java/gradle` |

Each command reloads the shell after it succeeds. An install command exists
only while its tool is missing, and the update and uninstall commands only
while it is installed.

Corretto has no update command: `update-brew` upgrades the casks. `update-all`
includes both the Homebrew update and the Maven and Gradle updates.

## Environment Variables

| Variable | Default |
| --- | --- |
| `JAVA_HOME` | Corretto 25 if installed, otherwise Corretto 21, otherwise unset |

## JDK Selection

The plugin treats Corretto `<version>` as installed when `bin/java` and
`bin/javac` are executable in
`/Library/Java/JavaVirtualMachines/amazon-corretto-<version>.jdk/Contents/Home`.
Other JDKs are ignored: the plugin never selects them automatically, and
`install-java-25` and `install-java-21` stay available when they are installed.

The plugin sets `JAVA_HOME` only when it is unset. It keeps a value that is
already set, even an empty or invalid one. Whenever `JAVA_HOME` is set, the
plugin exports it. It prepends `$JAVA_HOME/bin` to `PATH` only when that
directory has executable `java` and `javac`.

To use a specific JDK, set `JAVA_HOME` in `~/.zshrc` before the `source` line:

```zsh
# ~/.zshrc
export JAVA_HOME="/Library/Java/JavaVirtualMachines/amazon-corretto-21.jdk/Contents/Home"
source "${ZDOTFILES_DIR:-$HOME/.zdotfiles}/zshrc.sh"
```

Once `JAVA_HOME` is set, `reload` keeps it, so installing a JDK does not switch
the current shell to it. Uninstalling the JDK that `JAVA_HOME` points to clears
`JAVA_HOME` and its `bin` from `PATH` first, so the reload selects the next
installed Corretto JDK, if any. To select a JDK again yourself, run:

```zsh
unset JAVA_HOME
reload
```

## Maven and Gradle

Installing Maven or Gradle, or updating it to a new release, requires
`JAVA_HOME` to point to a JDK with executable `java` and `javac`. These
commands never install a JDK.

| Tool | Version source | Checksum | Install directory |
| --- | --- | --- | --- |
| Maven | Newest `3.x.y` release listed at <https://downloads.apache.org/maven/maven-3/> | SHA-512 | `$CUSTOM_TOOLS_DIR/.java/maven` |
| Gradle | `version` field of <https://services.gradle.org/versions/current> | SHA-256 | `$CUSTOM_TOOLS_DIR/.java/gradle` |

`CUSTOM_TOOLS_DIR` defaults to `~/.local/bin` (see
[Customizing](../../README.md#customizing)). The plugin prepends each tool's
`bin` directory to `PATH`.

The install and update commands download the archive and its published
checksum over HTTPS and stop if they do not match. They then run
`mvn --version` or `gradle --version` from the new distribution with the
current `JAVA_HOME`, and replace the existing installation only if that
succeeds. An update stops before downloading the archive when the installed
version already matches the release.

- `uninstall-maven` and `uninstall-gradle` delete only their install
  directories. Dependency caches such as `~/.m2` and `~/.gradle` stay in place.
- When `mvn` or `gradle` is already on `PATH` from another installation and no
  copy exists in the install directory, the plugin defines no commands for that
  tool.

Updates can change the build tool version: Maven stays on Maven 3, but Gradle
follows the current release and can move to a new major version. To build with
the version a project declares, use its `./mvnw` or `./gradlew` when present.
