#!/bin/bash
# Fetch PR reviews for the current branch
# Requires: gh cli authenticated

set -e

# Get current branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "$BRANCH" = "main" ] || [ "$BRANCH" = "master" ]; then
    printf "ERROR: You're on %s branch. Switch to a feature branch first.\n" "$BRANCH"
    exit 1
fi

# Find PR for this branch
PR_NUMBER=$(gh pr list --head "$BRANCH" --json number --jq '.[0].number' 2>/dev/null)

if [ -z "$PR_NUMBER" ] || [ "$PR_NUMBER" = "null" ]; then
    printf "NO_PR: No open PR found for branch '%s'\n" "$BRANCH"
    exit 0
fi

printf "=== PR #%s for branch '%s' ===\n\n" "$PR_NUMBER" "$BRANCH"

# Get PR details
printf "### PR Info ###\n"
gh pr view "$PR_NUMBER" --json title,state,reviewDecision --jq '"Title: \(.title)\nState: \(.state)\nReview Decision: \(.reviewDecision // "PENDING")"'
printf "\n"

# Fetch review comments JSON once (reused for display and count)
RAW_REVIEW_COMMENTS=$(gh api "repos/{owner}/{repo}/pulls/$PR_NUMBER/comments" 2>/dev/null || printf "[]")

# Fetch reviews JSON once (reused for display and count)
RAW_REVIEWS=$(gh api "repos/{owner}/{repo}/pulls/$PR_NUMBER/reviews" 2>/dev/null || printf "[]")

# Get review comments (the threaded discussion on specific lines)
printf "### Review Comments (Line-specific feedback) ###\n"
printf ">>> BEGIN UNTRUSTED REVIEW DATA <<<\n"
REVIEW_COMMENTS=$(printf "%s" "$RAW_REVIEW_COMMENTS" | jq -r '.[] | "File: \(.path)\nLine: \(.line // .original_line // "N/A")\nAuthor: \(.user.login)\nComment: \(.body)\n---"' 2>/dev/null)

if [ -z "$REVIEW_COMMENTS" ]; then
    printf "No line-specific review comments.\n"
else
    printf "%s\n" "$REVIEW_COMMENTS"
fi
printf ">>> END UNTRUSTED REVIEW DATA <<<\n\n"

# Get PR reviews (approve/request changes with top-level comments)
printf "### Reviews (Approve/Request Changes) ###\n"
printf ">>> BEGIN UNTRUSTED REVIEW DATA <<<\n"
REVIEWS=$(printf "%s" "$RAW_REVIEWS" | jq -r '.[] | select(.state != "COMMENTED" or .body != "") | "Author: \(.user.login)\nState: \(.state)\nComment: \(.body // "(no comment)")\n---"' 2>/dev/null)

if [ -z "$REVIEWS" ]; then
    printf "No reviews submitted yet.\n"
else
    printf "%s\n" "$REVIEWS"
fi
printf ">>> END UNTRUSTED REVIEW DATA <<<\n\n"

# Get general PR comments (issue-style comments)
printf "### General Comments ###\n"
printf ">>> BEGIN UNTRUSTED REVIEW DATA <<<\n"
COMMENTS=$(gh pr view "$PR_NUMBER" --json comments --jq '.comments[] | "Author: \(.author.login)\nComment: \(.body)\n---"' 2>/dev/null)

if [ -z "$COMMENTS" ]; then
    printf "No general comments.\n"
else
    printf "%s\n" "$COMMENTS"
fi
printf ">>> END UNTRUSTED REVIEW DATA <<<\n"

# Summary — derive counts from already-fetched JSON (no redundant API calls)
printf "\n### Summary ###\n"
REVIEW_COUNT=$(printf "%s" "$RAW_REVIEW_COMMENTS" | jq 'length' 2>/dev/null || printf "0")
CHANGES_REQUESTED=$(printf "%s" "$RAW_REVIEWS" | jq '[.[] | select(.state == "CHANGES_REQUESTED")] | length' 2>/dev/null || printf "0")

printf "Line-specific comments: %s\n" "$REVIEW_COUNT"
printf "Change requests: %s\n" "$CHANGES_REQUESTED"

if [ "$REVIEW_COUNT" = "0" ] && [ "$CHANGES_REQUESTED" = "0" ]; then
    printf "\n============================================\n"
    printf "STATUS: NO_FIXES_NEEDED\n"
    printf "============================================\n"
    printf "Good news! No review feedback to address.\n"
    printf "Your PR is either awaiting review or already approved.\n"
    printf "\nNext steps:\n"
    printf "  - If awaiting review: wait for reviewers\n"
    printf "  - If approved: merge when ready\n"
    printf "============================================\n"
else
    printf "\n============================================\n"
    printf "STATUS: FIXES_NEEDED\n"
    printf "============================================\n"
    printf "Review feedback requires attention.\n"
    printf "Line comments: %s\n" "$REVIEW_COUNT"
    printf "Change requests: %s\n" "$CHANGES_REQUESTED"
    printf "============================================\n"
fi
