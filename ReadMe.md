# Enhanced Git Prompt for ZSH

A __Zsh__ plugin written in `bash` which provides a more granular information about a git repository.

The Enhanced Git Prompt can show information about the current branch/hash name, it can tell if there is an upstream branch being tracked and the difference in commits between the upstream. When there is any stash entries a flag will be shown.

The prompt also provides information about the status of the repository. It will show the amount of files that were modified, deleted, conflicted, staged and untracked.

## Enhanced Prompt

### Branch Tracking Symbols

| Symbol | Color  | Meaning                            |
|--------|--------|------------------------------------|
| ✗      | red    | current branch has no upstream     |
| ↑n     | cyan   | ahead of upstream by `n` commits   |
| ↓n     | yellow | behind of upstream by `n` commits  |
| ⚑      | yellow | there is a stash entry             |

### Repository Status Symbols

| Symbol | Color  | Meaning                        |
|--------|--------|--------------------------------|
| +n     | blue   | there are `n` modified files   |
| -n     | red    | there are `n` deleted files    |
| ●n     | yellow | there are `n` staged files     |
| ●n     | cyan   | there are `n` untracked files  |
| !n     | red    | there are `n` conflicted files |
| ✔      | green  | repository is clean            |

### Examples

Add Examples

## Installation

1. Create a new folder called `git-prompt-enhanced` inside `~/.oh-my-zsh/custom/plugins`
2. Copy the `git-prompt-enhanced.plugin.zsh` script to this new folder
3. Add the plugin `git-prompt-enhanced` to your `plugins` variable on your `.zshrc` file
    * `plugins=( ... git-prompt-enhanced )`

## Customization

Add Section

## Motivation

Add Section
