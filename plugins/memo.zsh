# memo (durable memory CLI): https://github.com/jcyamacho/memo

if exists memo; then
  cache-completion memo completion zsh

  memo-configure-claude-hook() {
    exists jq || {
      warn "memo hook setup requires jq. Run install-jq first."
      return 1
    }

    local target="$HOME/.claude/settings.json"
    command mkdir -p -- "${target:h}"

    local jq_filter='
      .hooks = (.hooks // {})
      | .hooks.SessionStart = (
          (.hooks.SessionStart // [])
          | map(
              if has("hooks") then
                .hooks = (.hooks | map(select(.type != "command" or .command != $command)))
              else
                .
              end
            )
          | map(select((has("hooks") | not) or (.hooks | length > 0)))
          + [{"hooks":[{"type":"command","command":"memo context"}]}]
        )
    '

    local tmp
    tmp="$(command mktemp "${target}.XXXXXX")" || return 1

    local exit_status=0
    if [[ -f "$target" ]]; then
      command jq --arg command "memo context" "$jq_filter" "$target" >| "$tmp"
      exit_status=$?
    else
      builtin print -r -- "{}" | command jq --arg command "memo context" "$jq_filter" >| "$tmp"
      exit_status=$?
    fi

    if (( exit_status != 0 )); then
      command rm -f -- "$tmp"
      return $exit_status
    fi

    command mv -f -- "$tmp" "$target"
    info "Configured memo hook in $target"
  }

  memo-configure-codex-hook() {
    exists jq || {
      warn "memo hook setup requires jq. Run install-jq first."
      return 1
    }

    local target="$HOME/.codex/hooks.json"
    command mkdir -p -- "${target:h}"

    local jq_filter='
      .hooks = (.hooks // {})
      | .hooks.SessionStart = (
          (.hooks.SessionStart // [])
          | map(
              if has("hooks") then
                .hooks = (.hooks | map(select(.type != "command" or .command != $command)))
              else
                .
              end
            )
          | map(select((has("hooks") | not) or (.hooks | length > 0)))
          + [{
              "matcher":"startup|resume|clear|compact",
              "hooks":[{
                "type":"command",
                "command":"memo context",
                "statusMessage":"Loading memories",
                "timeout":5
              }]
            }]
        )
    '

    local tmp
    tmp="$(command mktemp "${target}.XXXXXX")" || return 1

    local exit_status=0
    if [[ -f "$target" ]]; then
      command jq --arg command "memo context" "$jq_filter" "$target" >| "$tmp"
      exit_status=$?
    else
      builtin print -r -- "{}" | command jq --arg command "memo context" "$jq_filter" >| "$tmp"
      exit_status=$?
    fi

    if (( exit_status != 0 )); then
      command rm -f -- "$tmp"
      return $exit_status
    fi

    command mv -f -- "$tmp" "$target"
    info "Configured memo hook in $target"
  }

  if exists brew; then
    uninstall-memo() {
      info "Uninstalling memo..."
      command brew uninstall jcyamacho/tap/memo
      reload
    }
  fi
elif exists brew; then
  install-memo() {
    info "Installing memo..."
    command brew install jcyamacho/tap/memo
    reload
  }
fi
