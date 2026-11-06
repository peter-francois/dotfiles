# dotfiles

Personal configuration for my development environment: WSL2 (Ubuntu) + Zsh.

## Contents

- `zsh/.zshrc`: Oh My Zsh, plugins (git, gh, ssh-agent, fzf, autosuggestions, syntax-highlighting), zoxide
- `zsh/.p10k.zsh`: Powerlevel10k prompt
- `git/.gitconfig`: git defaults (rebase on pull, SSH commit signing)
- `install.sh`: symlinks the files into `~` and installs the Zsh plugins

## Prerequisites

- Zsh and Oh My Zsh
- zoxide, fzf
- MesloLGS NF font set in the terminal

## Install

    git clone git@github.com:peter-francois/dotfiles.git ~/projects/dotfiles
    cd ~/projects/dotfiles && ./install.sh
    exec zsh

Existing files are backed up as `*.backup.<date>` before being replaced.
