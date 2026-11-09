# Instructions globales

## Qui je suis
- Développeur junior. Je veux progresser, pas seulement obtenir du code qui marche.
- Stack principale : Python et JavaScript/TypeScript.
- J'utilise le plugin superpowers. Ces règles le complètent ; en cas de conflit, ce fichier gagne.

## Dépôts perso
- Les règles Git (branche, worktree) et Tests ci-dessous visent les vrais projets de code.
- Un dépôt dont le CLAUDE.md se déclare « dépôt perso » (dotfiles, notes, doc pour moi) suit les règles allégées de ce fichier, qui priment sur celles-ci.

## Langue
- Réponds-moi en français.
- Code, noms de variables, commentaires et messages de commit en anglais.
- Specs et plans (`docs/superpowers/`) en français : c'est moi qui les relis.

## Comment m'aider
- Écris le code, puis explique brièvement les choix et les concepts nouveaux.
- Quand je fais une erreur, explique pourquoi c'est une erreur, pas seulement comment la corriger.
- Signale les bonnes pratiques et les pièges courants quand ils sont pertinents.
- Évite le jargon non expliqué.

## Outils
- Python : utilise `uv` (`uv add`, `uv run`), pas `pip` directement.
- JS/TS : utilise le gestionnaire de paquets du projet (repère le fichier lock : `pnpm-lock.yaml`, `package-lock.json`, `bun.lock`…).
- Pour la documentation d'une librairie ou d'un framework, utilise Context7 plutôt que ta mémoire.
- Mes tâches sont dans Linear : quand je cite un ticket (ex. `ABC-123`), lis-le avant de commencer.

## Git
- Messages de commit au format Conventional Commits (`feat:`, `fix:`, `chore:`, `refactor:`, `docs:`, `test:`).
- Ne travaille jamais directement sur `main` : isole le travail dans un worktree (sans me demander).
- Sur une branche de travail, tu peux commiter seul, y compris pendant les plans superpowers.
- Ne commit jamais sur `main`.
- Ne push et ne merge jamais sans mon accord.

## Demande-moi avant de
- Installer ou supprimer une dépendance.
- Supprimer ou écraser des fichiers existants (ce que tu viens de créer dans la tâche en cours ne compte pas).
- Lire ou modifier des secrets (`.env`, clés API, mots de passe).
- Modifier du code au-delà de ce que j'ai demandé (refactor, renommage, réorganisation).

## Style de code
- Peu de commentaires : seulement pour expliquer le *pourquoi* d'un choix non évident.
- Respecte le style et les conventions déjà présents dans le projet.

## Tests
- TDD : écris le test, vérifie qu'il échoue, puis écris le code (skill `superpowers:test-driven-development`).
- Lance toute la suite de tests avant de dire qu'une tâche est finie.
