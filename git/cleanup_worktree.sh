#!/usr/bin/env bash
#
# cleanup-merged-branches.sh
#
# Scans a directory for branch folders (git worktrees), checks whether each
# branch has been merged into main, notifies you, and asks before deleting.
#
# Usage:
#   ./cleanup-merged-branches.sh [DIR] [MAIN_BRANCH]
#
#   DIR          Folder containing the branch folders (default: current dir)
#   MAIN_BRANCH  Branch to check against (default: main)
#
# Detects both regular merges and squash merges.

set -uo pipefail

DIR="${1:-.}"
MAIN="${2:-main}"

GREEN=$'\e[32m'; YELLOW=$'\e[33m'; RED=$'\e[31m'; BOLD=$'\e[1m'; RESET=$'\e[0m'

notify() {
  local msg="$1"
  echo "${GREEN}${BOLD}✔ ${msg}${RESET}"
  # Desktop notification if available
  if command -v notify-send >/dev/null 2>&1; then
    notify-send "Branch merged" "$msg" 2>/dev/null
  elif command -v osascript >/dev/null 2>&1; then
    osascript -e "display notification \"$msg\" with title \"Branch merged\"" 2>/dev/null
  fi
}

# Returns 0 if $1 (branch) is merged into $2 (target), via normal or squash merge.
is_merged() {
  local repo="$1" branch="$2" target="$3"

  # Regular merge / fast-forward: branch tip is an ancestor of target
  if git -C "$repo" merge-base --is-ancestor "$branch" "$target" 2>/dev/null; then
    echo "merged"
    return 0
  fi

  # Squash merge: build a single commit equal to the branch's total diff,
  # then ask git cherry whether an equivalent patch already exists on target
  local base tree squashed
  base=$(git -C "$repo" merge-base "$target" "$branch" 2>/dev/null) || return 1
  tree=$(git -C "$repo" rev-parse "${branch}^{tree}") || return 1
  squashed=$(git -C "$repo" commit-tree "$tree" -p "$base" -m "_tmp_squash_check") || return 1
  if [[ $(git -C "$repo" cherry "$target" "$squashed") == -* ]]; then
    echo "squash-merged"
    return 0
  fi

  return 1
}

cd "$DIR" || { echo "${RED}Cannot cd into $DIR${RESET}"; exit 1; }

echo "${BOLD}Scanning $(pwd) for branch folders...${RESET}"
echo

found=0
merged_count=0
deleted_count=0

for folder in */; do
  folder="${folder%/}"
  [[ -d "$folder" ]] || continue

  # Must be a git working tree
  git -C "$folder" rev-parse --is-inside-work-tree >/dev/null 2>&1 || continue

  branch=$(git -C "$folder" symbolic-ref --short -q HEAD) || {
    echo "${YELLOW}⚠ $folder: detached HEAD, skipping${RESET}"
    continue
  }

  [[ "$branch" == "$MAIN" ]] && continue
  found=$((found + 1))

  # Prefer the remote's main if it exists (fresher), else local main
  git -C "$folder" fetch --quiet origin "$MAIN" 2>/dev/null
  if git -C "$folder" rev-parse --verify -q "origin/$MAIN" >/dev/null; then
    target="origin/$MAIN"
  elif git -C "$folder" rev-parse --verify -q "$MAIN" >/dev/null; then
    target="$MAIN"
  else
    echo "${YELLOW}⚠ $folder: no '$MAIN' branch found, skipping${RESET}"
    continue
  fi

  if how=$(is_merged "$folder" "$branch" "$target"); then
    merged_count=$((merged_count + 1))
    notify "'$branch' ($folder) has been $how into $target"

    # Warn about uncommitted work before offering deletion
    if [[ -n $(git -C "$folder" status --porcelain) ]]; then
      echo "${YELLOW}  ⚠ $folder has uncommitted changes — skipping deletion.${RESET}"
      echo
      continue
    fi

    read -r -p "  Delete folder '$folder' and branch '$branch'? [y/N] " answer < /dev/tty
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      # Find the main repo so we can run worktree/branch commands from outside the folder
      common_dir=$(git -C "$folder" rev-parse --path-format=absolute --git-common-dir)
      toplevel=$(git -C "$folder" rev-parse --show-toplevel)

      if [[ "$(git -C "$folder" rev-parse --absolute-git-dir)" != "$common_dir" ]]; then
        # It's a linked worktree
        git --git-dir="$common_dir" worktree remove "$toplevel" \
          && git --git-dir="$common_dir" branch -D "$branch" \
          && { echo "${GREEN}  🗑  Deleted $folder and $branch${RESET}"; deleted_count=$((deleted_count + 1)); } \
          || echo "${RED}  ✖ Failed to delete $folder${RESET}"
      else
        # It's a standalone clone, not a worktree
        read -r -p "  '$folder' is a full clone, not a worktree. Remove the whole folder? [y/N] " confirm < /dev/tty
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
          rm -rf "$folder" && { echo "${GREEN}  🗑  Deleted $folder${RESET}"; deleted_count=$((deleted_count + 1)); }
        else
          echo "  Skipped."
        fi
      fi
    else
      echo "  Kept."
    fi
    echo
  else
    echo "  $folder ($branch): not merged yet"
  fi
done

echo
echo "${BOLD}Done.${RESET} Branches checked: $found | Merged: $merged_count | Deleted: $deleted_count"