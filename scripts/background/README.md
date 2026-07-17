# Background Tmux Session

Auto-starts background jobs in a tmux session called "Background" at login and monitors them every 5 minutes.

## Installation

```bash
# Copy plist to LaunchAgents directory
cp com.user.background-tmux-monitor.plist ~/Library/LaunchAgents/

# Load the agent
launchctl load ~/Library/LaunchAgents/com.user.background-tmux-monitor.plist
```

## What It Does

The `background-tmux` script:
- Creates a tmux session at login with panes for each `*.d` job
- Runs every 5 minutes to check and restart dead scripts

## Verify

```bash
tmux attach -t Background
```

## Uninstall

```bash
launchctl unload ~/Library/LaunchAgents/com.user.background-tmux-monitor.plist
rm ~/Library/LaunchAgents/com.user.background-tmux-monitor.plist
```
