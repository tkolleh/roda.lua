# Roda

> Elegant terminal spinners for bash scripts and Lua

[![CI](https://github.com/tkolleh/roda.lua/actions/workflows/tests.yml/badge.svg)](https://github.com/tkolleh/roda.lua/actions/workflows/tests.yml)
[![LuaRocks](https://img.shields.io/luarocks/v/tkolleh/roda)](https://luarocks.org/modules/tkolleh/roda)
[![License: EUPL 1.2](https://img.shields.io/badge/License-EUPL--1.2-blue.svg)](https://opensource.org/licenses/EUPL-1.2)

**Roda** (Portuguese for "wheel") is an elegant terminal spinner utility. It can be used as a standalone executable in bash scripts to show progress for long-running commands, or as a pure Lua library.

## Features

![Demo](./assets/demo.gif)
*(Want to create a demo like this? Check out the [recording documentation](demo/recording-demo.md))*

- **Standalone Executable** - perfect for wrapping slow commands in bash scripts
- **16 built-in spinner styles** - dots, line, arc, bounce, and more
- **Colorized output**     - 9 terminal colors supported
- **Terminal states**      - succeed, fail, warn, info with symbols
- **Dynamic text updates** - change text while spinning
- **Highly configurable**  - intervals, colors, prefixes, suffixes
- **Minimal dependencies** - only requires `luasystem` and `luv`
- **Asynchronous**         - non-blocking execution

## Installation

### Homebrew (macOS and Linux)

```bash
brew install tkolleh/tap/roda
```

Or tap first, then install:

```bash
brew tap tkolleh/tap
brew install roda
```

### Standalone Binary (no Lua required)

Download a prebuilt binary from the [latest release](https://github.com/tkolleh/roda.lua/releases/latest). Binaries are available for **macOS ARM64**, **macOS Intel**, **Linux x86\_64**, and **Linux ARM64**.

#### macOS (Apple Silicon)

```bash
curl -fSLO https://github.com/tkolleh/roda.lua/releases/latest/download/roda-macos-arm64.tar.gz
curl -fSLO https://github.com/tkolleh/roda.lua/releases/latest/download/roda-macos-arm64.tar.gz.sha256
shasum -a 256 -c roda-macos-arm64.tar.gz.sha256
tar xzf roda-macos-arm64.tar.gz
chmod +x roda
sudo mv roda /usr/local/bin/
```

#### macOS (Intel)

```bash
curl -fSLO https://github.com/tkolleh/roda.lua/releases/latest/download/roda-macos-x86_64.tar.gz
curl -fSLO https://github.com/tkolleh/roda.lua/releases/latest/download/roda-macos-x86_64.tar.gz.sha256
shasum -a 256 -c roda-macos-x86_64.tar.gz.sha256
tar xzf roda-macos-x86_64.tar.gz
chmod +x roda
sudo mv roda /usr/local/bin/
```

#### Linux (x86\_64)

```bash
curl -fSLO https://github.com/tkolleh/roda.lua/releases/latest/download/roda-linux-x86_64.tar.gz
curl -fSLO https://github.com/tkolleh/roda.lua/releases/latest/download/roda-linux-x86_64.tar.gz.sha256
shasum -a 256 -c roda-linux-x86_64.tar.gz.sha256
tar xzf roda-linux-x86_64.tar.gz
chmod +x roda
sudo mv roda /usr/local/bin/
```

#### Linux (ARM64)

```bash
curl -fSLO https://github.com/tkolleh/roda.lua/releases/latest/download/roda-linux-aarch64.tar.gz
curl -fSLO https://github.com/tkolleh/roda.lua/releases/latest/download/roda-linux-aarch64.tar.gz.sha256
shasum -a 256 -c roda-linux-aarch64.tar.gz.sha256
tar xzf roda-linux-aarch64.tar.gz
chmod +x roda
sudo mv roda /usr/local/bin/
```

#### Windows

Windows users can build from source using [MSYS2 UCRT64](https://www.msys2.org/) with the MinGW toolchain. See the justfile and past CI workflow history for reference.

### Lua Library

If you want to use Roda as a Lua library in your own scripts or applications:

#### Using Lux (recommended)

```bash
lx add roda
```

#### Using LuaRocks

```bash
luarocks install roda
```

## Usage (CLI)

Use Roda to add elegant loading indicators to your bash scripts. Simply wrap your long-running commands with `roda`:

```bash
# Basic usage
roda --title "Installing dependencies..." -- npm install

# Custom spinner style
roda --title "Waiting for database..." --spinner "dots2" -- sleep 5

# Show output of the command (by default output is hidden while spinning)
roda --show-output --title "Building project..." -- make build
```

### CLI Options

| Option | Description |
|--------|-------------|
| `--title TEXT` | Text to display next to the spinner |
| `--spinner NAME` | Spinner style to use (e.g., `dots`, `line`, `arc`) |
| `--show-output` | Display the command's stdout/stderr after it finishes |
| `--` | Separates roda options from the command to execute |

## Usage (Lua Library)

Roda is compatible with Lua 5.1, 5.2, 5.3, 5.4, and LuaJIT.

```lua
local roda = require("roda")

-- Basic usage
local spinner = roda("Loading..."):start()
-- do work
spinner:succeed("Done!")

-- With options
local spinner = roda({
  text = "Processing...",
  spinner = "dots2",
  color = "yellow",
})
spinner:start()
-- do work
spinner:succeed()
```

### Async Command Execution

Roda supports running child processes asynchronously without blocking the Lua runtime.

```lua
local roda = require("roda")

local spinner = roda("Installing dependencies...")

-- Execute a command asynchronously
spinner:execute("npm", {"install"})(function(exit_code, output)
  if exit_code == 0 then
    print("\nOutput:\n" .. output)
  end
end)

-- Run the event loop to wait for async tasks
roda.run()
```

### API Reference

#### `roda(opts)` / `roda.new(opts)`

Create a new spinner instance.

**Parameters:**

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `text` | `string` | `""` | Text to display next to spinner |
| `prefixText` | `string` | `""` | Text before spinner |
| `suffixText` | `string` | `""` | Text after spinner text |
| `spinner` | `string\|table` | `"dots"` | Spinner style name or custom frames |
| `color` | `string\|boolean` | `"cyan"` | Spinner color, `false` to disable |
| `interval` | `number` | varies | Milliseconds between frames |
| `stream` | `file` | `io.stderr` | Output stream |
| `hideCursor` | `boolean` | `true` | Hide cursor while spinning |
| `indent` | `number` | `0` | Spaces to indent |

**Returns:** `Spinner` instance

#### Instance Methods

- `:start(text?)` - Start the spinner. Optionally set new text.
- `:stop()` - Stop and clear the spinner from the terminal.
- `:succeed(text?)` - Stop with green checkmark.
- `:fail(text?)` - Stop with red X.
- `:warn(text?)` - Stop with yellow warning.
- `:info(text?)` - Stop with blue info.
- `:spin()` - Render next frame. Call this in a loop for manual animation control.
- `:setText(text)` - Update spinner text while spinning.
- `:setColor(color)` - Change spinner color.
- `:isSpinning()` - Check if spinner is currently active.
- `:stopAndPersist(opts)` - Stop with custom symbol and text.
- `:execute(command, args)` - Execute a child process asynchronously while spinning. Returns a Thunk that expects an `on_complete` callback.

#### Module Methods

- `roda.run()` - Run the libuv event loop. Blocks until all async tasks finish.

## License

EUPL-1.2 (c) TJ Kolleh
