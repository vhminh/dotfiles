function gco() {
  local ref
  # list local branches, remote branches (without remote prefix), and tags
  ref=$({ git branch --format='%(refname:short)'; git branch -r --format='%(refname:strip=3)'; git tag; } | sort -u |
    fzf --preview "git log --oneline --graph --color=always {}") || return
  git checkout "$ref"
}

function glog() {
  git log --oneline --color=always |
    fzf --ansi \
        --preview "git show --color=always {1}"
}

function gs() {
  # interactive staging/unstaging
  # ctrl-s: stage selected, ctrl-u: unstage selected
  local reload='reload(git -c color.status=always status --short)'
  git -c color.status=always status --short |
    fzf --ansi \
        --preview "git diff --color=always HEAD -- {2} 2>/dev/null || cat {2}" \
        --multi \
        --header "ctrl-s: stage | ctrl-u: unstage" \
        --bind "ctrl-s:execute-silent(echo {+2} | xargs git add)+$reload+clear-selection" \
        --bind "ctrl-u:execute-silent(echo {+2} | xargs git reset HEAD --)+$reload+clear-selection"
}

function gpr() {
  # ✔ = approved, ✘ = changes requested, ● = pending
  local jq_expr='.[] | (if .reviewDecision == "APPROVED" then "\u001b[32m✔" elif .reviewDecision == "CHANGES_REQUESTED" then "\u001b[31m✘" else "\u001b[33m●" end) + "\u001b[0m " + (.number|tostring) + "\t" + .author.login + "\t" + .title'
  local list_cmd="gh pr list --state=open --search {q} --json number,title,author,reviewDecision --jq '$jq_expr' | column -ts \$'\\t'"
  local preview='v=$(mktemp) d=$(mktemp); gh pr view {2} >$v & gh pr diff {2} --color=always >$d & wait; cat $v; echo; cat $d; rm $v $d'
  case "${1:-view}" in
    view)
      local pr
      pr=$(fzf --ansi --disabled \
            --preview "$preview" \
            --multi \
            --header "ctrl-a: approve selected | type to search" \
            --bind "start:reload:$list_cmd" \
            --bind "change:reload:sleep 0.3; $list_cmd" \
            --bind "ctrl-a:execute-silent(echo {+2} | xargs -n1 gh pr review --approve)+reload($list_cmd)+refresh-preview") || return
      gh pr view "$(echo "$pr" | awk '{print $2}')" --web
      ;;
    checkout)
      local pr
      pr=$(fzf --ansi --disabled \
            --preview "$preview" \
            --bind "start:reload:$list_cmd" \
            --bind "change:reload:sleep 0.3; $list_cmd") || return
      gh pr checkout "$(echo "$pr" | awk '{print $2}')"
      ;;
    *)
      echo "usage: gpr [view|checkout]" >&2
      return 1
      ;;
  esac
}
