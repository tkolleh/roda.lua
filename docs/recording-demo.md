# Recording the Demo GIF

This guide explains how to create the demo GIF shown in the README.

## Prerequisites

Install the required tools:

```bash
# macOS
brew install asciinema
brew install agg  # asciinema-agg for GIF conversion

# Or use npm
npm install -g svg-term-cli
```

## Demo Script

The demo script is located at `demo/demo.lua`. It showcases Roda's features including:

- Basic spinner usage
- Different terminal states (succeed, fail, warn, info)
- Dynamic text updates
- Different spinner styles

## Recording

1. **Record the terminal session**:

```bash
# Start recording
asciinema rec demo.cast --cols 80 --rows 24

# Run the demo
lua demo/demo.lua

# Press Ctrl+D to stop recording
```

2. **Convert to GIF**:

Using agg (recommended):
```bash
agg demo.cast assets/demo.gif --cols 80 --rows 24 --speed 1.0
```

Using svg-term:
```bash
svg-term --in demo.cast --out assets/demo.svg --window
```

## Tips

- Use a clean terminal with a dark background
- Set terminal to 80x24 for consistency
- Use a monospace font that supports Unicode (e.g., JetBrains Mono, Fira Code)
- Keep the demo under 15 seconds for a reasonable GIF size

## Alternative: VHS

[VHS](https://github.com/charmbracelet/vhs) is another excellent option:

```bash
brew install vhs
```

Create a `.tape` file:

**File**: `demo/demo.tape`

```tape
Output assets/demo.gif
Set FontSize 14
Set Width 800
Set Height 400

Type "lua demo/demo.lua"
Enter
Sleep 15s
```

Run:
```bash
vhs demo/demo.tape
```

## Optimizing the GIF

If the GIF is too large:

```bash
# Using gifsicle
brew install gifsicle
gifsicle -O3 --colors 64 assets/demo.gif -o assets/demo-optimized.gif
```
