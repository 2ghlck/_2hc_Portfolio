#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

source_branch="${1:-main}"
target_branch="${2:-gh-pages}"
json_path="data/site.json"

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Working tree is not clean. Commit or stash changes first."
  exit 1
fi

if ! git rev-parse --verify "$source_branch" >/dev/null 2>&1; then
  echo "Source branch not found: $source_branch"
  exit 1
fi

if ! git rev-parse --verify "$target_branch" >/dev/null 2>&1; then
  echo "Target branch not found: $target_branch"
  exit 1
fi

if ! git cat-file -e "${target_branch}:${json_path}" 2>/dev/null; then
  echo "Missing branch-specific JSON: ${target_branch}:${json_path}"
  exit 1
fi

current_branch="$(git branch --show-current)"
temp_json="$(mktemp)"
cleanup() {
  rm -f "$temp_json"
}
trap cleanup EXIT

git show "${target_branch}:${json_path}" > "$temp_json"
git checkout "$target_branch" >/dev/null

if ! git merge --no-commit --no-ff "$source_branch"; then
  echo "Merge conflict detected on $target_branch."
  echo "Resolve the conflicts, then keep $json_path from $target_branch if needed."
  echo "If you want to cancel, run: git merge --abort"
  exit 1
fi

if ! git rev-parse -q --verify MERGE_HEAD >/dev/null; then
  echo "$target_branch is already up to date with $source_branch."
  if [[ "$current_branch" != "$target_branch" ]]; then
    git checkout "$current_branch" >/dev/null
  fi
  exit 0
fi

cp "$temp_json" "$json_path"
git add "$json_path"
git commit -m "Merge ${source_branch} into ${target_branch} (keep ${json_path})"

if [[ "$current_branch" != "$target_branch" ]]; then
  git checkout "$current_branch" >/dev/null
fi

echo "Merged $source_branch into $target_branch and kept $target_branch's $json_path."
