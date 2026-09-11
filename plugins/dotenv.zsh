# dotenv: run commands with literal environment files

dotenv() (
  # Parentheses run the function in a subshell, leaving the caller unchanged.
  # Reset Zsh options; extendedglob enables # (zero or more) in shell patterns.
  emulate -L zsh
  setopt extendedglob

  # Consume our options only. shift removes parsed arguments, leaving the command
  # and its arguments in "$@"; -- explicitly marks where that command starts.
  local environment=""
  local usage='Usage: dotenv [-e environment] [--] command [args...]'
  while (( $# )); do
    case "$1" in
      -e)
        if (( $# < 2 )) || [[ -z "$2" || "$2" == */* || "$2" == -* ]]; then
          builtin print -ru2 -- "$usage"
          return 2
        fi
        environment="$2"
        shift 2
        ;;
      --) shift; break ;;
      -*) builtin print -ru2 -- "$usage"; return 2 ;;
      *) break ;;
    esac
  done

  # $# is the remaining argument count. A command is required after the options.
  if (( ! $# )); then
    builtin print -ru2 -- "$usage"
    return 2
  fi

  # Load general files first, then environment-specific ones. env applies later
  # assignments last, so more specific files override earlier values.
  local -a files=(.env .env.local) assignments=() match
  [[ -n "$environment" ]] && files+=(".env.$environment" ".env.$environment.local")

  # Regex captures separate optional export, the key, and the raw value.
  # Quoted values must close on the same line, with only a comment after them.
  local assignment_pattern='^[[:blank:]]*(export[[:blank:]]+)?([A-Za-z_][A-Za-z0-9_]*)[[:blank:]]*=(.*)$'
  local double_pattern='^"([^"]*)"([[:blank:]]+#.*)?$'
  local single_pattern="^'([^']*)'([[:blank:]]+#.*)?$"
  local file line key value
  local -i line_number

  for file in "${files[@]}"; do
    # Skip missing files, but report unreadable files, directories, and broken
    # symlinks. -L detects a symlink even when its target does not exist.
    [[ -e "$file" || -L "$file" ]] || continue
    if [[ ! -f "$file" || ! -r "$file" ]]; then
      builtin print -ru2 -- "dotenv: cannot read $file"
      return 1
    fi

    # IFS= preserves whitespace and read -r preserves backslashes. The extra
    # condition also processes a final line that has no terminating newline.
    line_number=0
    while IFS= read -r line || [[ -n "$line" ]]; do
      (( ++line_number ))
      # Remove the carriage return from CRLF endings; skip blanks and comments.
      line="${line%$'\r'}"
      [[ "$line" == [[:blank:]]# || "$line" == [[:blank:]]#\#* ]] && continue

      # =~ fills Zsh's match array with capture groups (indexed from 1).
      # Reject invalid syntax without including potentially secret values.
      if [[ ! "$line" =~ "$assignment_pattern" ]]; then
        builtin print -ru2 -- "dotenv: invalid assignment at $file:$line_number"
        return 1
      fi
      key="$match[2]"
      # %% removes the longest matching suffix; ## removes the longest prefix.
      # Here they trim spaces and tabs outside the value's optional quotes.
      value="${match[3]%%[[:blank:]]#}"
      value="${value##[[:blank:]]#}"

      # For either quote style, keep only the captured contents. No shell
      # evaluation or escape processing takes place, so $(...) stays literal.
      case "$value" in
        \"*)
          if [[ "$value" =~ "$double_pattern" ]]; then
            value="$match[1]"
          else
            builtin print -ru2 -- "dotenv: invalid quoted value at $file:$line_number"
            return 1
          fi
          ;;
        \'*)
          if [[ "$value" =~ "$single_pattern" ]]; then
            value="$match[1]"
          else
            builtin print -ru2 -- "dotenv: invalid quoted value at $file:$line_number"
            return 1
          fi
          ;;
        *)
          # Start from the raw capture so whitespace before a comment is kept
          # long enough to recognize it, including an empty value: KEY= # note.
          value="${match[3]%%[[:blank:]]\#*}"
          value="${value%%[[:blank:]]#}"
          value="${value##[[:blank:]]#}"
          if [[ "$value" == *[\"\']* ]]; then
            builtin print -ru2 -- "dotenv: invalid value at $file:$line_number"
            return 1
          fi
          ;;
      esac

      # Collect each assignment as one array element, preserving spaces and
      # empty values. The command runs only after every file has been parsed.
      assignments+=("$key=$value")
    done < "$file" || return 1
  done

  # env receives data directly, including names that are special Zsh parameters.
  # Quoted array expansion and "$@" preserve argument boundaries. As the final
  # command, env supplies the function's exit status, including command failures.
  command env -- "${assignments[@]}" "$@"
)
