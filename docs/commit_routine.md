# Commit Routine

Use this process for every feature/fix before pushing to GitHub.

## 1) Sync and branch
- `git checkout main`
- `git pull --ff-only` (if remote exists)
- `git checkout -b codex/<short-feature-name>`

## 2) Build safety checks
- `flutter pub get`
- `flutter analyze`
- `flutter test`

## 3) Review changes
- `git status`
- `git diff --stat`
- Confirm no secrets are included (`.env`, Firebase keys, signing keys).

## 4) Commit
- `git add -A`
- `git commit -m "<type>: <short summary>"`

Suggested types: `feat`, `fix`, `chore`, `refactor`, `docs`, `test`.

## 5) Push
- `git push -u origin <branch-name>`

## 6) PR workflow (recommended)
- Open PR to `main`
- Add summary, screenshots (if UI change), and test notes
- Merge only after checks pass
