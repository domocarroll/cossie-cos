#!/bin/bash
# Cossie v2 — Chief of Staff installer
# Installs shell scripts to ~/bin/, SKILL.md to Claude Code, and initializes state

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/bin"
SKILL_DIR="$HOME/.claude/skills/chief-of-staff"
COS_DIR="$HOME/.cos"

echo "Installing Cossie v2 — Chief of Staff"
echo "======================================"

# 1. Install bin scripts
mkdir -p "$BIN_DIR"
for script in cos-email-digest cos-calendar cos-followups cos-krang cos-infra; do
  cp "$SCRIPT_DIR/bin/$script" "$BIN_DIR/$script"
  chmod +x "$BIN_DIR/$script"
  echo "  Installed: $BIN_DIR/$script"
done

# 2. Install SKILL.md
mkdir -p "$SKILL_DIR"
cp "$SCRIPT_DIR/SKILL.md" "$SKILL_DIR/SKILL.md"
echo "  Installed: $SKILL_DIR/SKILL.md"

# 3. Install sender classifications template (if none exists)
if [ ! -f "$SKILL_DIR/sender-classifications.json" ]; then
  cp "$SCRIPT_DIR/templates/sender-classifications.example.json" "$SKILL_DIR/sender-classifications.json"
  echo "  Created:   $SKILL_DIR/sender-classifications.json (edit to match your inbox)"
else
  echo "  Skipped:   sender-classifications.json already exists"
fi

# 4. Initialize state directory
mkdir -p "$COS_DIR/briefing-history"
[ ! -f "$COS_DIR/state.json" ] && echo '{}' > "$COS_DIR/state.json"
[ ! -f "$COS_DIR/followups.json" ] && echo '[]' > "$COS_DIR/followups.json"
[ ! -f "$COS_DIR/context.json" ] && echo '{"summaries":[],"decisions":[],"pending":[]}' > "$COS_DIR/context.json"
echo "  State dir: $COS_DIR/"

# 5. Add ~/bin to PATH (fish)
if command -v fish &>/dev/null; then
  FISH_CONF_DIR="$HOME/.config/fish/conf.d"
  mkdir -p "$FISH_CONF_DIR"
  if [ ! -f "$FISH_CONF_DIR/cos-bin.fish" ]; then
    echo 'fish_add_path $HOME/bin' > "$FISH_CONF_DIR/cos-bin.fish"
    echo "  Fish PATH: Added ~/bin"
  fi
fi

# 6. Add ~/bin to PATH (bash/zsh)
for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  if [ -f "$rc" ] && ! grep -q 'HOME/bin' "$rc"; then
    echo 'export PATH="$HOME/bin:$PATH"' >> "$rc"
    echo "  PATH:      Added ~/bin to $(basename $rc)"
  fi
done

echo ""
echo "Done! Prerequisites:"
echo "  - gws CLI: npm install -g @googleworkspace/cli"
echo "  - gws auth: gws auth login --scopes \"gmail.modify calendar\""
echo "  - Node.js (for cos-krang)"
echo "  - Python 3 (for email digest, follow-ups)"
echo ""
echo "Configure (optional environment variables):"
echo "  COS_KRANG_DIR  — Path to Krang SDK (default: ~/projects/huly-sdk-explorer)"
echo "  COS_SSH_KEY    — SSH key for infra check (default: ~/.ssh/id_rsa)"
echo "  COS_SSH_HOST   — SSH host for infra check (default: root@localhost)"
echo ""
echo "Update from GitHub:"
echo "  cd ~/cossie-cos && git pull && ./install.sh"
echo ""
echo "Usage: /cossie, /cossie sweep, /cossie dispatch, /cossie timeblock"
echo "       /cossie inbox, /cossie followup, /cossie prep, /cossie draft"
echo "       /cossie decide, /cossie eod, /cossie krang, /cossie infra"
