#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "========================================================"
echo "  DrawNote & Cartesia Voice AI — Native APK Builder"
echo "========================================================"

pkg update -y
pkg install -y git nodejs-lts gh unzip

git config --global user.name "DrawNote Builder"
git config --global user.email "drawnote@users.noreply.github.com"

if ! gh auth status >/dev/null 2>&1; then
  gh auth login
fi

if [ ! -d ".git" ]; then
  REPO_NAME="drawnote-voice-apk-$(date +%s)"
  git init
  git branch -M main
  git add .
  git commit -m "feat: Native DrawNote + ElevenLabs Cartesia Voice APK"
  gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
else
  git add .
  git commit -m "feat: update to native DrawNote + ElevenLabs UI" || true
  git push
fi

echo "Waiting 8s for GitHub Actions run to start..."
sleep 8
RUN_ID=$(gh run list --limit 1 --json databaseId -q '.[0].databaseId')
gh run watch "$RUN_ID"

mkdir -p ~/storage/downloads/ProNoteAPK
gh run download "$RUN_ID" -n ProNote-Studio-Debug-APK -D ~/storage/downloads/ProNoteAPK
echo "✅ Native APK Downloaded to: ~/storage/downloads/ProNoteAPK/app-debug.apk"
