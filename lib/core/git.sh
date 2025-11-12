#!/usr/bin/env bash
# lib/core/git.sh - Pure functions for git operations

set -euo pipefail

# is_git_repo - Check if current directory is a git repository
# input: "check if current directory is git repository"
# Returns: 0 if git repo, 1 if not
is_git_repo() {
    git rev-parse --git-dir >/dev/null 2>&1
}

# has_uncommitted_changes - Check if there are uncommitted changes
# input: "check if git repo has uncommitted changes"
# Returns: 0 if has changes, 1 if clean
has_uncommitted_changes() {
    ! git diff-index --quiet HEAD -- 2>/dev/null
}

# has_untracked_files - Check if there are untracked files
# input: "check if git repo has untracked files"
# Returns: 0 if has untracked files, 1 if none
has_untracked_files() {
    [[ -n "$(git ls-files --others --exclude-standard)" ]]
}

# is_clean_working_tree - Check if working tree is clean
# input: "check if git working tree is clean"
# Returns: 0 if clean, 1 if dirty
is_clean_working_tree() {
    ! has_uncommitted_changes && ! has_untracked_files
}

# get_current_branch - Get current branch name
# input: "get current git branch name"
# Returns: 0 on success, 1 on failure
# Outputs: Branch name to stdout
get_current_branch() {
    git rev-parse --abbrev-ref HEAD 2>/dev/null
}

# branch_exists - Check if branch exists locally
# input: "check if git branch exists locally"
# Args: $1 - branch name
# Returns: 0 if exists, 1 if not
branch_exists() {
    local branch="$1"
    git rev-parse --verify "$branch" >/dev/null 2>&1
}

# remote_branch_exists - Check if branch exists on remote
# input: "check if git branch exists on remote"
# Args: $1 - remote name, $2 - branch name
# Returns: 0 if exists, 1 if not
remote_branch_exists() {
    local remote="$1"
    local branch="$2"
    git ls-remote --heads "$remote" "$branch" | grep -q "$branch"
}

# fetch_remote - Fetch from remote
# input: "fetch updates from git remote"
# Args: $1 - remote name (default: origin)
# Returns: 0 on success, 1 on failure
fetch_remote() {
    local remote="${1:-origin}"
    git fetch "$remote" 2>&1
}

# pull_branch - Pull from remote branch
# input: "pull updates from remote branch"
# Args: $1 - remote name, $2 - branch name
# Returns: 0 on success, 1 on failure, 2 on conflicts
pull_branch() {
    local remote="$1"
    local branch="$2"

    # Try to pull
    if ! git pull "$remote" "$branch" 2>&1; then
        # Check if it's a merge conflict
        if has_merge_conflicts; then
            return 2
        fi
        return 1
    fi

    return 0
}

# has_merge_conflicts - Check if there are merge conflicts
# input: "check if git has merge conflicts"
# Returns: 0 if has conflicts, 1 if none
has_merge_conflicts() {
    git ls-files --unmerged | grep -q "^"
}

# get_conflicted_files - Get list of files with conflicts
# input: "get list of files with merge conflicts"
# Returns: 0 on success
# Outputs: List of conflicted file paths, one per line
get_conflicted_files() {
    git diff --name-only --diff-filter=U
}

# abort_merge - Abort current merge
# input: "abort current git merge"
# Returns: 0 on success, 1 on failure
abort_merge() {
    git merge --abort 2>&1
}

# stage_file - Stage a file for commit
# input: "stage file for git commit"
# Args: $1 - file path
# Returns: 0 on success, 1 on failure
stage_file() {
    local file="$1"
    git add "$file" 2>&1
}

# stage_all - Stage all changes
# input: "stage all changes for git commit"
# Returns: 0 on success, 1 on failure
stage_all() {
    git add -A 2>&1
}

# commit_changes - Create a commit
# input: "create git commit with message"
# Args: $1 - commit message
# Returns: 0 on success, 1 on failure
commit_changes() {
    local message="$1"
    git commit -m "$message" 2>&1
}

# push_branch - Push to remote branch
# input: "push commits to remote branch"
# Args: $1 - remote name, $2 - branch name
# Returns: 0 on success, 1 on failure
push_branch() {
    local remote="$1"
    local branch="$2"
    git push "$remote" "$branch" 2>&1
}

# remove_file_from_git - Remove file from git tracking
# input: "remove file from git tracking"
# Args: $1 - file path
# Returns: 0 on success, 1 on failure
remove_file_from_git() {
    local file="$1"
    git rm -rf "$file" 2>&1
}

# get_file_status - Get git status of a specific file
# input: "get git status of specific file"
# Args: $1 - file path
# Returns: 0 on success, 1 if not tracked
# Outputs: Status (unmodified, modified, added, deleted, untracked)
get_file_status() {
    local file="$1"

    # Check if file is tracked
    if ! git ls-files --error-unmatch "$file" >/dev/null 2>&1; then
        echo "untracked"
        return 0
    fi

    # Check status
    local status
    status=$(git status --porcelain "$file" 2>/dev/null | awk '{print $1}')

    case "$status" in
        "M"|"MM")
            echo "modified"
            ;;
        "A")
            echo "added"
            ;;
        "D")
            echo "deleted"
            ;;
        "R")
            echo "renamed"
            ;;
        "")
            echo "unmodified"
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# is_behind_remote - Check if local branch is behind remote
# input: "check if local branch is behind remote"
# Args: $1 - remote name, $2 - branch name
# Returns: 0 if behind, 1 if up-to-date or ahead
is_behind_remote() {
    local remote="$1"
    local branch="$2"

    # Fetch to get latest remote info
    fetch_remote "$remote" >/dev/null 2>&1 || return 1

    # Compare commits
    local local_commit remote_commit
    local_commit=$(git rev-parse "$branch" 2>/dev/null) || return 1
    remote_commit=$(git rev-parse "$remote/$branch" 2>/dev/null) || return 1

    [[ "$local_commit" != "$remote_commit" ]] && \
    ! git merge-base --is-ancestor "$remote_commit" "$local_commit" 2>/dev/null
}

# is_ahead_of_remote - Check if local branch is ahead of remote
# input: "check if local branch is ahead of remote"
# Args: $1 - remote name, $2 - branch name
# Returns: 0 if ahead, 1 if up-to-date or behind
is_ahead_of_remote() {
    local remote="$1"
    local branch="$2"

    # Fetch to get latest remote info
    fetch_remote "$remote" >/dev/null 2>&1 || return 1

    # Compare commits
    local local_commit remote_commit
    local_commit=$(git rev-parse "$branch" 2>/dev/null) || return 1
    remote_commit=$(git rev-parse "$remote/$branch" 2>/dev/null) || return 1

    [[ "$local_commit" != "$remote_commit" ]] && \
    ! git merge-base --is-ancestor "$local_commit" "$remote_commit" 2>/dev/null
}

# get_commit_count_ahead - Get number of commits ahead of remote
# input: "get number of commits ahead of remote"
# Args: $1 - remote name, $2 - branch name
# Returns: 0 on success
# Outputs: Number of commits ahead
get_commit_count_ahead() {
    local remote="$1"
    local branch="$2"

    git rev-list --count "$remote/$branch..$branch" 2>/dev/null || echo "0"
}

# get_commit_count_behind - Get number of commits behind remote
# input: "get number of commits behind remote"
# Args: $1 - remote name, $2 - branch name
# Returns: 0 on success
# Outputs: Number of commits behind
get_commit_count_behind() {
    local remote="$1"
    local branch="$2"

    git rev-list --count "$branch..$remote/$branch" 2>/dev/null || echo "0"
}
