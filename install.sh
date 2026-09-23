#!/bin/bash
# Installs the battery-full reminder on this Mac (works for any username).
set -e

DIR="$HOME/.battery-reminder"
PLIST="$HOME/Library/LaunchAgents/com.user.battery-reminder.plist"
mkdir -p "$DIR" "$HOME/Library/LaunchAgents"

cat > "$DIR/check.sh" <<'EOF'
#!/bin/bash
# Reminds you to unplug the charger when the battery is full.
# Runs every minute via launchd (see ~/Library/LaunchAgents/com.user.battery-reminder.plist).

THRESHOLD=100          # notify at or above this percentage
REPEAT_EVERY=300       # seconds between repeat reminders while still plugged in
STAMP="$HOME/.battery-reminder/last_notified"

batt=$(pmset -g batt)
percent=$(echo "$batt" | grep -Eo '[0-9]+%' | head -1 | tr -d '%')

if ! echo "$batt" | grep -q "AC Power"; then
  rm -f "$STAMP"   # unplugged: reset so the next full charge notifies right away
  exit 0
fi

[ -z "$percent" ] || [ "$percent" -lt "$THRESHOLD" ] && exit 0

now=$(date +%s)
last=$(cat "$STAMP" 2>/dev/null || echo 0)
[ $((now - last)) -lt "$REPEAT_EVERY" ] && exit 0
echo "$now" > "$STAMP"

osascript -e "display notification \"Battery is at ${percent}%. Unplug your charger.\" with title \"🔋 Battery Full\" sound name \"Glass\""
say "Battery is full. Please unplug the charger." &
EOF
chmod +x "$DIR/check.sh"

cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>com.user.battery-reminder</string>
  <key>ProgramArguments</key>
  <array><string>/bin/bash</string><string>$DIR/check.sh</string></array>
  <key>StartInterval</key><integer>60</integer>
  <key>RunAtLoad</key><true/>
</dict>
</plist>
EOF

launchctl bootout "gui/$(id -u)" "$PLIST" 2>/dev/null || true
launchctl bootstrap "gui/$(id -u)" "$PLIST"
echo "✅ Battery reminder installed. It checks every minute."
