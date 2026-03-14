# Contributing to Roda

Thank you for considering contributing to Roda! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Running Tests](#running-tests)
- [Code Style](#code-style)
- [Debugging in Neovim](#debugging-in-neovim)
- [Submitting Changes](#submitting-changes)
- [Commit Messages](#commit-messages)

## Code of Conduct

Please be respectful and constructive in all interactions. We welcome contributors of all skill levels.

## Getting Started

1. Fork the repository on GitHub
2. Clone your fork:
   ```bash
   git clone https://github.com/<your-username>/roda.lua.git
   cd roda.lua
   ```
3. Add upstream remote:
   ```bash
   git remote add upstream https://github.com/tkolleh/roda.lua.git
   ```

## Development Setup

### Prerequisites

- [Lux](https://lux.lumen-labs.org/) (recommended) or LuaRocks
- Lua 5.1+ or LuaJIT
- A terminal with ANSI support
- (Optional) Neovim for debugging

### Install Dependencies

```bash
# Using Lux
lx install

# Or using LuaRocks
luarocks install luasystem
luarocks install busted --dev
```

### Project Structure

```
roda.lua/
├── lua/roda/          # Source code
│   ├── init.lua       # Main module (~300 lines)
│   ├── spinners.lua   # Spinner definitions (~150 lines)
│   ├── ansi.lua       # ANSI escape codes (~50 lines)
│   └── symbols.lua    # Final state symbols (~15 lines)
└── spec/              # Tests
    ├── roda_spec.lua
    ├── spinners_spec.lua
    ├── ansi_spec.lua
    └── symbols_spec.lua
```

## Running Tests

```bash
# Run all tests
lx test

# Run with verbose output
lx test -- --verbose

# Run specific test file
lx test -- spec/roda_spec.lua

# Run tests matching a pattern
lx test -- --filter="spinner"

# Run tests for specific Lua version
lx --lua-version 5.1 test
lx --lua-version 5.4 test
```

## Code Style

### lux.toml Guidelines

When editing `lux.toml`, be aware of this **known Lux bug**:

> **⚠️ Avoid multiline TOML strings** (triple-quoted `"""` strings) in `lux.toml`.
> Lux generates invalid Lua rockspec syntax from multiline TOML strings,
> causing `lx upload` to fail with a 400 Bad Request error.

**Bad** (causes upload failure):
```toml
[description]
detailed = """
This is a multiline
description that will break.
"""
```

**Good** (use single-line strings):
```toml
[description]
detailed = "This is a single-line description that works correctly."
```

This issue is tracked in the Lux project. Until fixed, always use single-line strings
for all `lux.toml` fields.

### Formatting

We use `lx fmt` for consistent code formatting:

```bash
lx fmt
```

### Linting

Run the linter before submitting:

```bash
lx lint
```

### Type Checking

We use LuaCATS annotations. Run type checks with:

```bash
lx check
```

### Guidelines

- Use descriptive variable and function names
- Add LuaCATS type annotations to all public functions
- Keep functions small and focused
- Prefer immutable patterns where practical
- Comment *why*, not *what*
- All public methods should be chainable (return `self`)

## Debugging in Neovim

For debugging Roda or Lua code that uses Roda in Neovim, we recommend using [one-small-step-for-vimkind](https://github.com/jbyuki/one-small-step-for-vimkind) (osv).

### Prerequisites

Install the following Neovim plugins using your plugin manager:

#### Using lazy.nvim

```lua
{
  "mfussenegger/nvim-dap",
  dependencies = {
    "jbyuki/one-small-step-for-vimkind",
  },
  config = function()
    local dap = require("dap")

    -- Configure the Lua adapter
    dap.configurations.lua = {
      {
        type = "nlua",
        request = "attach",
        name = "Attach to running Neovim instance",
      },
    }

    dap.adapters.nlua = function(callback, config)
      callback({
        type = "server",
        host = config.host or "127.0.0.1",
        port = config.port or 8086,
      })
    end
  end,
}
```

#### Using vim-plug

```vim
Plug 'mfussenegger/nvim-dap'
Plug 'jbyuki/one-small-step-for-vimkind'
```

### Keybindings

Add these keybindings to your Neovim config:

```lua
-- Toggle breakpoint
vim.keymap.set("n", "<leader>db", require("dap").toggle_breakpoint, { desc = "Toggle breakpoint" })

-- Continue/Start debugging
vim.keymap.set("n", "<leader>dc", require("dap").continue, { desc = "Continue" })

-- Step over
vim.keymap.set("n", "<leader>do", require("dap").step_over, { desc = "Step over" })

-- Step into
vim.keymap.set("n", "<leader>di", require("dap").step_into, { desc = "Step into" })

-- Step out
vim.keymap.set("n", "<leader>dO", require("dap").step_out, { desc = "Step out" })

-- Launch debugger server (in debuggee)
vim.keymap.set("n", "<leader>dl", function()
  require("osv").launch({ port = 8086 })
end, { desc = "Launch debug server" })

-- Inspect variable under cursor
vim.keymap.set("n", "<leader>dw", function()
  require("dap.ui.widgets").hover()
end, { desc = "Inspect variable" })

-- Show stack frames
vim.keymap.set("n", "<leader>df", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.frames)
end, { desc = "Show frames" })
```

### Debugging Workflow

#### Step 1: Launch the Debug Server (Debuggee)

In the Neovim instance where your code will run:

1. Press `<leader>dl` to launch the debug server
2. You should see: `"Server started on port 8086"`

#### Step 2: Set Breakpoints (Debugger)

In a separate Neovim instance:

1. Open the Roda source file you want to debug, e.g., `lua/roda/init.lua`
2. Navigate to a line inside a function (e.g., inside `Spinner:start()`)
3. Press `<leader>db` to set a breakpoint (red dot appears)

#### Step 3: Connect to Debuggee

In the debugger Neovim instance:

1. Press `<leader>dc` to connect
2. Select "Attach to running Neovim instance" if prompted

#### Step 4: Trigger the Code (Debuggee)

In the debuggee Neovim instance, run Lua code that uses Roda:

```lua
-- In command mode or a scratch buffer
:lua local roda = require("roda"); roda("Test"):start():succeed("Done!")
```

The debugger will pause at your breakpoint.

#### Step 5: Inspect and Navigate

- `<leader>dw` - Hover over variable to inspect
- `<leader>do` - Step over (execute line, don't enter functions)
- `<leader>di` - Step into (enter function calls)
- `<leader>dO` - Step out (exit current function)
- `<leader>dc` - Continue (run until next breakpoint)

### Debugging Tips

#### Breakpoints Not Hit?

1. **Check paths**: Breakpoints are path-sensitive. The file path in the debugger must match the actual path being executed.

2. **Use tracing**:
   ```lua
   -- In debuggee, before running your code:
   :lua require("osv").start_trace()
   
   -- Run your code
   :lua require("roda")("Test"):start():succeed()
   
   -- Check which files were loaded:
   :lua =require("osv").stop_trace()
   ```

3. **Verify package.path**: Ensure Roda is loaded from the expected location:
   ```lua
   :lua print(package.searchpath("roda", package.path))
   ```

#### Common Issues

- **"Neovim is waiting for input at startup"**: The headless instance has an error. Start Neovim with `nvim --headless` to see startup errors.

- **100% CPU at breakpoint**: Set `require("osv").launch({ port = 8086, delay_frozen = 100 })`.

- **Using flatten.nvim**: Set `nest_if_no_args = true` in flatten config.

### Example Debug Session

```lua
-- 1. In debuggee: Launch server
:lua require("osv").launch({ port = 8086 })

-- 2. In debugger: Open lua/roda/init.lua, go to line ~280 (Spinner:start)
-- Press <leader>db to set breakpoint

-- 3. In debugger: Connect
-- Press <leader>dc

-- 4. In debuggee: Run code
:lua local s = require("roda")("Debug test"); s:start()

-- 5. Debugger pauses at breakpoint!
-- Use <leader>dw on `self` to inspect the spinner state
```

## Submitting Changes

### Pull Request Process

1. Create a feature branch from `main`:
   ```bash
   git checkout main
   git pull upstream main
   git checkout -b feat/my-feature
   ```

2. Make your changes with clear, atomic commits

3. Ensure all tests pass:
   ```bash
   lx test
   ```

4. Run code quality checks:
   ```bash
   lx fmt
   lx lint
   lx check
   ```

5. Push to your fork:
   ```bash
   git push origin feat/my-feature
   ```

6. Open a Pull Request against `main`

### PR Requirements

- [ ] All tests pass
- [ ] Code is formatted (`lx fmt`)
- [ ] No linting errors (`lx lint`)
- [ ] New features have tests
- [ ] Documentation updated if needed
- [ ] Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/)

## Commit Messages

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Types

| Type | Description |
|------|-------------|
| `feat` | A new feature |
| `fix` | A bug fix |
| `docs` | Documentation only changes |
| `style` | Code style changes (formatting, semicolons, etc.) |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `perf` | Performance improvement |
| `test` | Adding or updating tests |
| `build` | Changes to build system or dependencies |
| `ci` | Changes to CI configuration |
| `chore` | Other changes that don't modify src or test files |

### Examples

```
feat(spinner): add moon phase spinner style

Adds a new "moon" spinner with lunar phase emoji frames.

fix(ansi): handle terminals without color support

Check for NO_COLOR environment variable before emitting
ANSI escape sequences.

docs(readme): add async execution example

test(spinner): add tests for custom spinner frames

refactor(init): extract frame cycling to separate method

Improves readability by moving the frame index cycling
logic into its own method.
```

## Questions?

Open an issue or start a discussion. We're happy to help!
