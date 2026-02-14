#!/bin/bash
set -e

echo "Unloading old plist..."
launchctl unload ~/Library/LaunchAgents/com.user.background-tmux-monitor.plist

echo "Removing old plist from LaunchAgents..."
rm ~/Library/LaunchAgents/com.user.background-tmux-monitor.plist

echo "Copying new plist to LaunchAgents..."
cp /Users/evanthomas/.dotfiles/scripts/background/com.evan.background-tmux-monitor.plist ~/Library/LaunchAgents/

echo "Loading new plist..."
launchctl load ~/Library/LaunchAgents/com.evan.background-tmux-monitor.plist

echo "Verifying..."
launchctl list | grep background-tmux

echo "Removing old plist from dotfiles..."
rm /Users/evanthomas/.dotfiles/scripts/background/com.user.background-tmux-monitor.plist

echo "Done!"
