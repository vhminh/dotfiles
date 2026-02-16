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

function _gpr_list() {
  # ✔ = approved, ✘ = changes requested, ● = pending
  gh pr list --state=open \
    --json number,title,author,reviewDecision \
    --jq '.[] | (if .reviewDecision == "APPROVED" then "\u001b[32m✔" elif .reviewDecision == "CHANGES_REQUESTED" then "\u001b[31m✘" else "\u001b[33m●" end) + "\u001b[0m " + (.number|tostring) + "\t" + .title + "\t" + .author.login'
}

function gpr() {
  case "${1:-view}" in
    view)
      local pr
      pr=$(_gpr_list |
        fzf --ansi --preview 'v=$(mktemp) d=$(mktemp); gh pr view {2} >$v & gh pr diff {2} --color=always >$d & wait; cat $v; echo; cat $d; rm $v $d' \
            --header "ctrl-a: approve" \
            --bind "ctrl-a:execute-silent(gh pr review {2} --approve)+refresh-preview") || return
      gh pr view "$(echo "$pr" | awk '{print $2}')" --web
      ;;
    checkout)
      local pr
      pr=$(_gpr_list |
        fzf --ansi --preview 'v=$(mktemp) d=$(mktemp); gh pr view {2} >$v & gh pr diff {2} --color=always >$d & wait; cat $v; echo; cat $d; rm $v $d') || return
      gh pr checkout "$(echo "$pr" | awk '{print $2}')"
      ;;
    *)
      echo "usage: gpr [view|checkout]" >&2
      return 1
      ;;
  esac
}
