#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Remplace ~/<dest> par un lien vers le fichier du repo,
# en sauvegardant l'original s'il s'agit d'un vrai fichier
link() {
  local src="$DOTFILES/$1" dest="$HOME/$2"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.backup.$(date +%Y%m%d%H%M%S)"
    echo "sauvegarde : $dest"
  fi
  ln -sfn "$src" "$dest"
  echo "lien : $dest -> $src"
}

mkdir -p "$HOME/.claude"
link claude/CLAUDE.md .claude/CLAUDE.md
link claude/settings.json .claude/settings.json
link zsh/.zshrc     .zshrc
link zsh/.p10k.zsh  .p10k.zsh
link git/.gitconfig .gitconfig

# Plugins Oh My Zsh : ils sont clonés à part, donc pas dans le repo
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
clone() { [ -d "$2" ] || git clone --depth=1 "$1" "$2"; }
clone https://github.com/zsh-users/zsh-autosuggestions     "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone https://github.com/romkatv/powerlevel10k             "$ZSH_CUSTOM/themes/powerlevel10k"
