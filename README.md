# Roda

> Elegant terminal spinners for Lua

[![CI](https://github.com/tkolleh/roda.lua/actions/workflows/tests.yml/badge.svg)](https://github.com/tkolleh/roda.lua/actions/workflows/tests.yml)
[![LuaRocks](https://img.shields.io/luarocks/v/tkolleh/roda)](https://luarocks.org/modules/tkolleh/roda)
[![License: EUPL 1.2](https://img.shields.io/badge/License-EUPL--1.2-blue.svg)](https://opensource.org/licenses/EUPL-1.2)

**Roda** (Portuguese for "wheel") is a pure Lua terminal spinner library

![Demo](./assets/demo.gif)

## Features

- **16 built-in spinner styles** - dots, line, arc, bounce, and more
- **Colorized output**     - 9 terminal colors supported
- **Terminal states**      - succeed, fail, warn, info with symbols
- **Dynamic text updates** - change text while spinning
- **Highly configurable**  - intervals, colors, prefixes, suffixes
- **Minimal dependencies** - only requires `luasystem`
- **Lua 5.1+ compatible**  - works with Lua 5.1, 5.2, 5.3, 5.4, and LuaJIT

## Installation

### Using Lux (recommended)

```bash
lx add roda
```

### Using LuaRocks

```bash
luarocks install roda
```

### Manual Installation

Clone the repository and add to your `package.path`:

```lua
package.path = "/path/to/roda.lua/lua/?.lua;/path/to/roda.lua/lua/?/init.lua;" .. package.path
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
  text = "Processing...",
  spinner = "dots2",
  color = "yellow",
})
spinner:start()
-- do work
spinner:succeed()
```

## API Reference

### `roda(opts)` / `roda.new(opts)`

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

#### `:start(text?)`

Start the spinner. Optionally set new text.

```lua
spinner:start()
spinner:start("New loading text")
```

#### `:stop()`

Stop and clear the spinner from the terminal.

#### `:succeed(text?)`

Stop with green checkmark.

```lua
spinner:succeed("Completed!")
```

#### `:fail(text?)`

Stop with red X.

```lua
spinner:fail("Failed to connect")
```

#### `:warn(text?)`

Stop with yellow warning.

```lua
spinner:warn("Deprecated API used")
```

#### `:info(text?)`

Stop with blue info.

```lua
spinner:info("Using cached data")
```

#### `:spin()`

Render next frame. Call this in a loop for manual animation control.

```lua
while working do
  spinner:spin()
  system.sleep(0.08)
end
```

#### `:setText(text)`

Update spinner text while spinning.

```lua
spinner:setText("Processing item 5/10")
```

#### `:setColor(color)`

Change spinner color.

```lua
spinner:setColor("yellow")
```

#### `:isSpinning()`

Check if spinner is currently active.

```lua
if spinner:isSpinning() then
  -- still working
end
```

#### `:stopAndPersist(opts)`

Stop with custom symbol and text.

```lua
spinner:stopAndPersist({
  symbol = "->",
  text = "Skipped",
})
```

### Available Spinners

| Name | Preview | Interval |
|------|---------|----------|
| `dots` | ......... | 80ms |
| `dots2` | ........ | 80ms |
| `dots3` | .......... | 80ms |
| `line` | -\\|/ | 130ms |
| `line2` | .--.-- | 100ms |
| `pipe` | ........ | 100ms |
| `simpleDots` | . .. ... | 400ms |
| `star` | ...... | 70ms |
| `arc` | ...... | 100ms |
| `circle` | ... | 120ms |
| `bounce` | .... | 120ms |
| `bouncingBar` | [=   ] | 80ms |
| `arrow` | ........ | 100ms |
| `growVertical` | ....... | 120ms |
| `growHorizontal` | ....... | 120ms |
| `aesthetic` | .... | 80ms |

### Available Colors

`black`, `red`, `green`, `yellow`, `blue`, `magenta`, `cyan`, `white`, `gray`

Set to `false` to disable coloring.

## Advanced Usage

### Async Command Execution

```lua
local roda = require("roda")
local system = require("system")

local function exec_with_spinner(cmd, text)
  local spinner = roda(text):start()
  
  local tmpfile = os.tmpname()
  local exitfile = os.tmpname()
  os.execute(string.format("(%s) > %s 2>&1; echo $? > %s &", cmd, tmpfile, exitfile))
  
  local exit_code = nil
  while exit_code == nil do
    spinner:spin()
    local ef = io.open(exitfile, "r")
    if ef then
      local content = ef:read("*a")
      ef:close()
      if content:match("%d+") then
        exit_code = tonumber(content:match("%d+"))
      end
    end
    system.sleep(0.08)
  end
  
  local f = io.open(tmpfile, "r")
  local output = f and f:read("*a") or ""
  if f then f:close() end
  os.remove(tmpfile)
  os.remove(exitfile)
  
  if exit_code == 0 then
    spinner:succeed(text)
  else
    spinner:fail(text)
  end
  
  return output, exit_code == 0
end

-- Usage
local output, success = exec_with_spinner("npm install", "Installing dependencies")
```

### Custom Spinners

```lua
local spinner = roda({
  text = "Moon phases",
  spinner = {
    interval = 100,
    frames = { "moon1", "moon2", "moon3", "moon4", "moon5", "moon6", "moon7", "moon8" },
  },
})
spinner:start()
```

### Promise-style Wrapping

```lua
local result = roda.promise({
  text = "Fetching data...",
  successText = "Data fetched!",
  failText = "Failed to fetch data",
  fn = function()
    -- your work here
    return fetch_data()
  end,
})
```

### Progress Updates

```lua
local spinner = roda("Processing..."):start()
for i = 1, total do
  spinner:setText(string.format("Processing [%d/%d]", i, total))
  spinner:spin()
  process_item(i)
  system.sleep(0.02)
end
spinner:succeed(string.format("Processed %d items", total))
```

## Compatibility

- Lua 5.1, 5.2, 5.3, 5.4
- LuaJIT 2.0, 2.1
- Requires a terminal that supports ANSI escape codes

## Related Projects

- [sindresorhus/ora](https://github.com/sindresorhus/ora) - An inspirational Node.js implementation
- [cli-spinners](https://github.com/sindresorhus/cli-spinners) - Spinner frame definitions

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines, including how to debug with Neovim DAP.

## License

EUPL-1.2 (c) TJ Kolleh
