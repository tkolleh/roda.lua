# VHS Tape File - roda.lua demo
# https://github.com/charmbracelet/vhs
#
# Prerequisites:
#   brew install vhs
#   lx install  (or ensure roda is in package.path)
#
# Generate GIF:
#   vhs demo.tape
#
# Generate MP4:
#   vhs demo.tape --output assets/demo.mp4

# Output configuration
Output assets/demo.gif
Set Shell "zsh"
Set FontFamily "JetBrains Mono"
Set FontSize 16
Set Width 900
Set Height 500
Set Padding 20
Set Theme "Dracula"
Set TypingSpeed 50ms
Set PlaybackSpeed 1

# Start recording
Sleep 500ms

# Show command being typed
Type "lua demo.lua"
Sleep 300ms
Enter

# Wait for demo to complete (adjust based on demo.lua timing)
# Total demo time: ~18 seconds
Sleep 20s

# Brief pause at end
Sleep 1s
