## Go Development Guidelines
- Follow the Google Go style guide.
- Always use fakes instead of mocks. Don't use the word "mock" as the name for fakes

## General Development Practices
- Format all files you have modified at the end of your task

## JJ VCS Usage
When working in repositories that use JJ (Jujutsu) version control instead of Git, use these JJ commands for common operations:

### Status and Information
- Use `jj status` instead of `git status`
- Use `jj log` instead of `git log`
- Use `jj diff` instead of `git diff`

### Making Changes
- Use `jj new` to create a new change (equivalent to starting new work)
- Use `jj describe` instead of `git commit` to add/update commit messages
- Use `jj squash` to combine changes instead of `git commit --amend`

### Branch Operations
- Use `jj edit <name>` instead of `git checkout -b <name>`
- Use `jj bookmark set -r <revision> <name>` to update the last commit of a branch
- Use `jj bookmark list` instead of `git branch`
- Use `jj bookmark delete` instead of `git push -D :<name>`

### Remote Operations
- Use `jj git push` instead of `git push`
- Use `jj git fetch` instead of `git fetch`
- Use `jj rebase -d <dest>` instead of `git rebase <dest>`

### Detection
- Check for `.jj/` directory instead of `.git/` to detect JJ repositories
- Look for `jj status` command availability to confirm JJ usage
