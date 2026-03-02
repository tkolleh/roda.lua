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

# Set up a 1200x600 terminal
Set FontSize 30
Set Width 1200
Set Height 600

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
Sleep 21s

# Brief pause at end
Sleep 1s
