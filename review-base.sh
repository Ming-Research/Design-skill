#!/bin/sh
# Print the base a CI job passes to lint.py's --base: the revision preceding
# the change it checks. A push to main compares with the tip before the push,
# a manual run on main with the first parent, a pull request with its fork
# point from the branch it targets (GITHUB_BASE_REF, main when unset), and any
# other ref with its fork point from origin/main. It assumes the main line is
# the branch main on the remote origin. Stdout contains only the resolved
# commit.
set -eu

if [ "$#" -ne 3 ]; then
  echo 'usage: review-base.sh EVENT REF PUSH_BEFORE' >&2
  exit 1
fi
event=$1
ref=$2
before=$3
case "$event" in
  push|workflow_dispatch|pull_request) ;;
  *) echo "unsupported design review event: $event" >&2; exit 1 ;;
esac

if [ "$ref" = refs/heads/main ]; then
  if [ "$event" = push ]; then
    candidate=$before
  else
    # A manual main run checks the last revision against its first parent.
    candidate=HEAD^
  fi
else
  # New commits on the target are not changes made by this work branch. A pull
  # request stacked on another work branch is compared with that branch, so
  # its parent's unlogged edits are not charged to it; HEAD is the merge commit,
  # whose base is the target's tip.
  target=main
  if [ "$event" = pull_request ]; then
    target=${GITHUB_BASE_REF:-main}
  fi
  if ! git rev-parse --verify --quiet "refs/remotes/origin/$target^{commit}" >/dev/null; then
    echo "design review target origin/$target is missing; fetch it (fetch-depth: 0)" >&2
    exit 1
  fi
  candidate=$(git merge-base "origin/$target" HEAD)
fi

if ! base=$(git rev-parse --verify --end-of-options "${candidate}^{commit}"); then
  echo "cannot resolve design review base: $candidate" >&2
  exit 1
fi
if [ "$ref" = refs/heads/main ] && [ "$base" = "$(git rev-parse HEAD)" ]; then
  echo 'main design review base equals HEAD; refusing an empty comparison' >&2
  exit 1
fi
printf '%s\n' "$base"
