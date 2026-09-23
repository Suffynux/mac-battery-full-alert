# 🔋 Mac Battery Full Alert — Get Notified When Your MacBook Is 100% Charged

**A free, lightweight macOS script that alerts you when your MacBook battery is fully charged, so you remember to unplug the charger.**

No app to install, no menu bar icon, no background app eating RAM. It's a small Bash script run by macOS's built-in `launchd`. It shows a notification and **speaks out loud** ("Battery is full. Please unplug the charger.") when your MacBook Air or MacBook Pro reaches 100% while plugged in.

![macOS](https://img.shields.io/badge/macOS-Sonoma%20%7C%20Sequoia%20%7C%20Tahoe-black?logo=apple)
![Shell](https://img.shields.io/badge/shell-bash-green)
![License](https://img.shields.io/badge/license-MIT-blue)
![Apple Silicon](https://img.shields.io/badge/Apple%20Silicon%20%26%20Intel-supported-lightgrey)

---

## ⚡ Install in one command

Open **Terminal** and paste:

```bash
curl -fsSL https://raw.githubusercontent.com/Suffynux/mac-battery-full-alert/main/install.sh | bash
```

That's it. You'll see `✅ Battery reminder installed.` It starts working right away and keeps running after restarts.

> The first time the alert fires, macOS may ask whether **Script Editor** can send notifications. Click **Allow**.

---

## 🤔 Why use a battery full notification on Mac?

- **Protect your battery health.** Keeping a lithium-ion battery at 100% on the charger for hours puts extra wear on it. Unplugging when it's full can help it last longer.
- **Don't forget the charger.** Get a reminder the moment charging is done instead of checking the battery icon over and over.
- **Hear it from across the room.** The Mac *says* the battery is full, so you notice even when you're not looking at the screen.
- **No third-party app.** Unlike AlDente, Battery Monitor, Coconut Battery or other paid battery apps, this is about 30 lines of readable shell script you can check yourself.

---

## ✨ Features

| Feature | Details |
|---|---|
| 🔔 macOS notification | "🔋 Battery Full: Battery is at 100%. Unplug your charger." with the Glass sound |
| 🗣️ Voice alert | Uses the built-in `say` command |
| 🔁 Repeat reminders | Reminds you every 5 minutes until you unplug |
| 🔌 Smart reset | Resets when you unplug, so the next full charge alerts right away |
| 🪶 Uses almost no resources | Checks once a minute with `pmset`, then exits (no always-running process) |
| 🚀 Starts at login | Managed by `launchd`, keeps running after restarts |
| 💻 Works on any Mac laptop | MacBook Air, MacBook Pro, Apple Silicon (M1, M2, M3, M4) and Intel |

---

## ⚙️ Configuration

Edit `~/.battery-reminder/check.sh`:

```bash
THRESHOLD=100      # alert at or above this % (for example 80 or 90 to stop charging earlier)
REPEAT_EVERY=300   # seconds between repeat reminders while still plugged in
```

Changes apply at the next check (within 1 minute). You don't need to restart anything.

**Tip:** Set `THRESHOLD=80` to get an **80% battery charge alert on Mac**, a common way to reduce battery wear.

---

## 🛠️ How it works

1. `install.sh` writes the checker script to `~/.battery-reminder/check.sh`.
2. It creates a LaunchAgent at `~/Library/LaunchAgents/com.user.battery-reminder.plist` that runs the checker every **60 seconds**.
3. The checker reads the battery level and power source with `pmset -g batt`.
4. If the Mac is on **AC power** and the battery is at or above the threshold, it shows a notification with `osascript` and speaks with `say`.

No `sudo` and no admin password needed. Nothing is sent over the network.

---

## 🧪 Manual install (without curl)

```bash
git clone https://github.com/Suffynux/mac-battery-full-alert.git
cd mac-battery-full-alert
bash install.sh
```

## 🗑️ Uninstall

```bash
curl -fsSL https://raw.githubusercontent.com/Suffynux/mac-battery-full-alert/main/uninstall.sh | bash
```

Or from the cloned folder: `bash uninstall.sh`

---

## ❓ FAQ

**Does macOS have a built-in battery full notification?**
No. macOS has *Optimized Battery Charging*, but it doesn't tell you when your MacBook reaches 100%. This script adds that alert.

**Does it work on macOS Tahoe, Sequoia, Sonoma and Ventura?**
Yes. It only uses standard macOS tools (`pmset`, `osascript`, `say`, `launchd`), which have been available for years.

**Will it drain my battery?**
No. It runs for a fraction of a second once a minute and then exits.

**I'm not getting notifications.**
Open **System Settings → Notifications → Script Editor** and turn on *Allow Notifications*. Also check that Focus / Do Not Disturb is off.

**How do I test it without waiting for 100%?**
Plug in your charger, set `THRESHOLD=1` in `~/.battery-reminder/check.sh`, wait up to a minute, then set it back.

**Can I copy it to my other MacBook?**
Yes. Run the same one-line install command on each Mac. It adjusts to each Mac's username automatically.

---

## 🤝 Contributing

Issues and pull requests are welcome. Ideas: low battery alerts, custom voices, a menu bar toggle.

## 📄 License

[MIT](LICENSE) © Sufiyan Ali

---

<sub>**Keywords:** mac battery full notification, macbook battery 100% alert, macbook charged notification, unplug charger reminder mac, macOS battery alert script, battery health macbook, stop overcharging macbook, battery charge limit reminder, 80% battery alert mac, launchd battery script, pmset battery script, free AlDente alternative, macbook air battery alert, macbook pro battery notification, apple silicon battery reminder</sub>
