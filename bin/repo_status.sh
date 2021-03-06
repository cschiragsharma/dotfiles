#!/bin/bash
# script to call repository status functions in screen's backtick

# Prompt setup, with SCM status
function parse_git_branch() {
  local DIRTY STATUS
  STATUS=$(git status --porcelain 2>/dev/null)
  [ $? -eq 128 ] && return
  [ -z "$(echo "$STATUS" | grep -e '^ [M]')"   ] || DIRTY="*"
  [ -z "$(echo "$STATUS" | grep -e '^?? ')"    ] || DIRTY="*"
  [ -z "$(echo "$STATUS" | grep -e '^[MDA]')"  ] || DIRTY="${DIRTY}+"
  [ -z "$(git stash list)"                     ] || DIRTY="${DIRTY}^"
  AHEAD=$(git status 2>/dev/null | grep -e 'ahead of' | awk '{ print $9; }')
  [ -z "${AHEAD}"                              ] || DIRTY="${DIRTY}!"
  echo " ($(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* //')$DIRTY)"
}

function parse_svn_revision() {
  local DIRTY REV=$(svn info 2>/dev/null | grep Revision | sed -e 's/Revision: //')
  [ "$REV" ] || return
  [ "$(svn st | grep -e '^ \?[M?] ')" ] && DIRTY='*'
  echo " (r$REV$DIRTY)"
}

echo "$(parse_git_branch)$(parse_svn_revision)"
