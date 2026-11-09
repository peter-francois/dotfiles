# Dépôt perso : dotfiles

Ce dépôt n'est pas un projet de code : il sert à retrouver mon environnement (zsh, p10k, git, Claude) sur une nouvelle machine.
C'est un dépôt perso : les règles allégées du CLAUDE.md global s'appliquent ici.

## Ce qui change par rapport au global
- Travaille directement sur `main` : pas de branche, pas de worktree.
- Pas de TDD, pas de tests à écrire.
- Pas de specs ni de plans superpowers : des modifications simples se font directement.
- Commits : propose le message et attends mon accord avant de commiter.

## Ce qui reste valable
- Ne push jamais sans mon accord.
- Ne touche jamais aux secrets (tokens, clés SSH, `.env`) et ne les ajoute jamais au dépôt.
- Réponses en français, commits en anglais au format Conventional Commits.

## Structure
- `install.sh` : crée les liens symboliques de ce dépôt vers `$HOME`.
- `claude/CLAUDE.md` : mon CLAUDE.md global (lié vers `~/.claude/CLAUDE.md`). Ne pas le confondre avec ce fichier.
