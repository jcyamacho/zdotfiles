# dotenv (run commands with literal environment files)

dotenv() (
  # Subshell body so nothing leaks into the caller; the trimming patterns below
  # need extendedglob for # (zero or more).
  emulate -L zsh
  setopt extendedglob

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

  if (( ! $# )); then
    builtin print -ru2 -- "$usage"
    return 2
  fi

  # More specific files come later: env keeps the last assignment of a key.
  local -a files=(.env .env.local) assignments=() match
  [[ -n "$environment" ]] && files+=(".env.$environment" ".env.$environment.local")

  # Quoted values must close on the same line, with only a comment after them.
  local assignment_pattern='^[[:blank:]]*(export[[:blank:]]+)?([A-Za-z_][A-Za-z0-9_]*)[[:blank:]]*=(.*)$'
  local double_pattern='^"([^"]*)"([[:blank:]]+#.*)?$'
  local single_pattern="^'([^']*)'([[:blank:]]+#.*)?$"
  local file line key value
  local -i line_number

  for file in "${files[@]}"; do
    # Missing files are skipped, but broken symlinks (caught by -L) are reported.
    [[ -e "$file" || -L "$file" ]] || continue
    if [[ ! -f "$file" || ! -r "$file" ]]; then
      builtin print -ru2 -- "dotenv: cannot read $file"
      return 1
    fi

    line_number=0
    # The -n test also processes a final line without a trailing newline.
    while IFS= read -r line || [[ -n "$line" ]]; do
      (( ++line_number ))
      line="${line%$'\r'}"
      [[ "$line" == [[:blank:]]# || "$line" == [[:blank:]]#\#* ]] && continue

      # Diagnostics report only the location, never values that may be secrets.
      if [[ ! "$line" =~ "$assignment_pattern" ]]; then
        builtin print -ru2 -- "dotenv: invalid assignment at $file:$line_number"
        return 1
      fi
      key="$match[2]"
      value="${match[3]%%[[:blank:]]#}"
      value="${value##[[:blank:]]#}"

      # Values stay literal: no evaluation or escape processing, so $(...) is text.
      case "$value" in
        [\"\']*)
          if [[ "$value" =~ "$double_pattern" || "$value" =~ "$single_pattern" ]]; then
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

      # Nothing runs until every file has been parsed.
      assignments+=("$key=$value")
    done < "$file" || return 1
  done

  # env takes the names as data, so keys may match special zsh parameters.
  command env -- "${assignments[@]}" "$@"
)

compdef '_arguments "-e[load .env.<environment> files]:environment" "(-)--[end of options]" "*::command:_normal"' dotenv
