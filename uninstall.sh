#!/bin/bash
# Removes the Mac battery full alert.
PLIST="$HOME/Library/LaunchAgents/com.user.battery-reminder.plist"
launchctl bootout "gui/$(id -u)" "$PLIST" 2>/dev/null || true
rm -rf "$HOME/.battery-reminder" "$PLIST"
echo "🗑️  Battery reminder removed."
