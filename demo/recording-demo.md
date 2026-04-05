# Recording the Demo GIF

Generate the demo GIF using [VHS](https://github.com/charmbracelet/vhs).

## Prerequisites

```bash
brew install vhs          # Terminal recorder
lx install                # Or ensure roda is in package.path
```

## Demo Script

`demo/demo.lua` showcases Roda features:
- Basic spinner usage
- Terminal states (succeed, fail, warn, info)
- Dynamic text updates
- Different spinner styles

Run interactively: `just demo run`

## Recording

Generate the GIF:
```bash
just demo record
```

This runs `vhs` with `demo/demo.tape`, producing `assets/demo.gif`.

## Tape Configuration

`demo/demo.tape` configures the recording:
```tape
Output ../assets/demo.gif
Set Shell "bash"
Set FontSize 30
Set Width 1200
Set Height 600
Set TypingSpeed 50ms
Set PlaybackSpeed 1
```

Customize settings like `FontSize`, `Width`, `Height` as needed.

## Tips

- Use a dark terminal background for contrast
- Ensure terminal uses a monospace font (JetBrains Mono, Fira Code)
- The demo runs ~18 seconds; adjust `Sleep` in the tape accordingly
- For MP4 output: `vhs demo.tape --output ../assets/demo.mp4`
