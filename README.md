# Roda

> Elegant terminal spinners for Lua

[![CI](https://github.com/tkolleh/roda.lua/actions/workflows/tests.yml/badge.svg)](https://github.com/tkolleh/roda.lua/actions/workflows/tests.yml)
[![LuaRocks](https://img.shields.io/luarocks/v/tkolleh/roda)](https://luarocks.org/modules/tkolleh/roda)
[![License: EUPL 1.2](https://img.shields.io/badge/License-EUPL--1.2-blue.svg)](https://opensource.org/licenses/EUPL-1.2)

**Roda** (Portuguese for "wheel") is a pure Lua terminal spinner library.

## Features

![Demo](./assets/demo.gif)

- **16 built-in spinner styles** - dots, line, arc, bounce, and more
- **Colorized output**     - 9 terminal colors supported
- **Terminal states**      - succeed, fail, warn, info with symbols
- **Dynamic text updates** - change text while spinning
- **Highly configurable**  - intervals, colors, prefixes, suffixes
- **Minimal dependencies** - only requires `luasystem` and `luv`
- **Lua 5.1+ compatible**  - works with Lua 5.1, 5.2, 5.3, 5.4, and LuaJIT
- **Asynchronous**         - non-blocking execution using `luv`

## Installation

### Using Lux (recommended)

```bash
lx add roda
```

### Using LuaRocks

```bash
luarocks install roda
```

## Quick Start

```lua
local roda = require("roda")

-- Basic usage
local spinner = roda("Loading..."):start()
-- do work
spinner:succeed("Done!")

-- With options
local spinner = roda({
  text = "Loading...",
  spinner = "dots2",
  color = "yellow",
})
spinner:start()
-- do work
spinner:succeed()
```

## Async Command Execution

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

## API Reference

### `roda(opts)`

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

### Instance Methods

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

### Module Methods

- `roda.run()` - Run the libuv event loop, and wait until all async tasks finish.

## License

EUPL-1.2 (c) TJ Kolleh
