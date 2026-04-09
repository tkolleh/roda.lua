# AGENTS.md

## Project Overview
Roda (Portuguese for "wheel") is a pure Lua terminal spinner library and CLI tool for adding elegant loading indicators to bash scripts and Lua applications. It provides multiple spinner styles, colorized output, success/failure/warning states, and asynchronous command execution. The project includes a standalone executable built with static linking of luv and luasystem.

## Repo Map
- `lua/roda/` – Core Lua library modules (`init.lua`, `ansi.lua`, `spinners.lua`, etc.)
- `spec/` – Busted unit tests (`*_spec.lua`)
- `demo/` – Example scripts and recordings
- `assets/` – Images and demo GIF
- `bin/` – CLI entry point (`spin.lua`)
- `.github/workflows/` – CI/CD pipelines (tests, publish, release)
- `justfile` – Primary task runner (format, lint, test, build)
- `.luacheckrc` – Linting configuration
- `lux.toml` – Dependency management (luasystem, luv, busted)

## Setup
- **Prerequisites:** Lua (5.1+), Lux (package manager), just (task runner), git, C compiler (for static builds)
- **Install dependencies:** `just install` (uses Lux to fetch luasystem, luv, busted)
- **Environment variables (optional):** `LUA_PREFIX` (path to Lua installation), `BUILD_DIR` (default `.build`), `LOG_LEVEL`

## Common Commands
All commands are run via `just <recipe>` from the repository root.

| Command | Purpose |
|---------|---------|
| `just fmt` | Format Lua files (lux fmt) |
| `just lint` | Lint Lua files (lux check) |
| `just check` | Run both lint and format checks |
| `just test-unit` | Run unit tests (via lux/busted) |
| `just test` | Alias for `test-unit` |
| `just test-cli` | Build the standalone binary and run CLI integration tests |
| `just test-all` | Run unit + CLI tests |
| `just test-perf` | Performance benchmark with hyperfine |
| `just build` | Build standalone executable (static compile luv + luasystem) |
| `just install` | Install lux dependencies |
| `just dev <args>` | Run spinner directly without building (`lx lua -- bin/spin.lua`) |
| `just validate` | Full pre‑commit validation (check + test) |
| `just all` | Full CI pipeline (validate + build + integration tests) |
| `just clean` | Remove build artifacts and binaries |
| `just publish` | Publish to LuaRocks (requires confirmation) |

## Coding Conventions
- **Formatting:** Use `just fmt` (lux fmt). No manual formatting needed.
- **Linting:** Follow `.luacheckrc` rules. Warnings are treated as errors except for ignored codes (deep nesting, long lines >120 chars, etc.).
- **Global variables:** Only allowed globals are listed in `.luacheckrc`. Avoid adding new ones.
- **Unused arguments:** Prefix with `_` (e.g., `_unused`) to suppress warnings.
- **Line length:** Maximum 120 characters.
- **Testing:** Write Busted specs in `spec/` following existing patterns. Use `describe`, `it`, `before_each`.
- **Error handling:** Use Lua `error` and `assert` appropriately; library functions return `nil, err` on failure.
- **Documentation:** Update README.md, CHANGELOG.md, and API reference in docs as needed.

## Change Workflow
1. **Make your change** – Ensure changes are focused and small.
2. **Run `just check`** – Verify linting and formatting.
3. **Run `just test-unit`** – Ensure existing tests pass.
4. **Add/update tests** – Modify or create `*_spec.lua` files in `spec/`.
5. **Test CLI changes** – If modifying CLI behavior, run `just test-cli`.
6. **Build verification** – For changes to core library, run `just build` and test the binary.
7. **Keep diffs small** – Avoid large, unrelated changes in a single commit.
8. **Never commit secrets or credentials** – No secrets in the repository.

## Gotchas
- **Lua version:** Default development uses Lua 5.5; CI runs tests with Lua 5.4. Ensure compatibility across 5.1+.
- **Static build dependencies:** Building the standalone binary (`just build`) clones luv and luasystem repos, compiles them statically, and links with liblua.a. Requires CMake, GCC/AR, and Lua development headers.
- **Lux version:** CI uses Lux 0.28.0 (busted dependency issues resolved); local development uses newer versions. Be aware of version mismatches.
- **Environment variables:** `LUA_PREFIX` may need to be set if Lua is installed in a non‑standard location (e.g., Homebrew on macOS).
- **Performance overhead:** The CLI adds minimal overhead; benchmark with `just test-perf` to ensure it stays under 1.3s for a 1s sleep.
- **Pre‑commit hooks:** The repo uses lefthook (see `lefthook.yml`); ensure hooks pass before committing.

## When You're Stuck
- **Ask 1 targeted question** instead of guessing or exploring blindly.
- **If commands fail** due to environment/tooling, report the exact error and **STOP** rather than looping.
- **Prefer the smallest reproducible check** that validates the change (e.g., `just test-unit` for library changes, `just test-cli` for CLI changes).
- **When uncertain about architectural decisions**, ask before implementing.
- **Check the justfile** for the exact command you need; it's the source of truth for workflows.