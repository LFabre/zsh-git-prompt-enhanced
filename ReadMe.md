# Enhanced Git Prompt for ZSH

A __Zsh__ plugin written in `bash` which provides a more granular information about git repositories.

The Enhanced Git Prompt can show information about the current branch/hash name, it can tell if there is an upstream branch being tracked and the difference in commits between the upstream. When there is any stash entries a flag will also be shown.

The prompt can also provide information about the status of a repository. It will display the amount of modified and deleted files and the ones which are staged, untracked and conflicted.

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
| Un     | cyan   | there are `n` untracked files  |
| !n     | red    | there are `n` conflicted files |
| ✔      | green  | repository is clean            |

### Examples

This first example displays a repository current on `develop` branch with 4 modified files, 3 deleted files, 2 staged and one untracked change.

![Example01](./imgs/example01.png)

On the example below, there is a clean repository on the `feature` branch with no upstream branch being tracked.

![Example02](./imgs/example02.png)

On the last example, there is a clean repository on the `feature` branch ahead of the upstream branch by 1 commit and behind by 2.

![Example03](./imgs/example03.png)

## Installation

1. Create a new folder called `git-prompt-enhanced` inside `~/.oh-my-zsh/custom/plugins`.
2. Copy the `git-prompt-enhanced.plugin.zsh` script to the new folder.
3. Add the plugin `git-prompt-enhanced` to your `plugins` variable on your `.zshrc` file.
    * `plugins=( ... git-prompt-enhanced )`

## Customization

Add Section
