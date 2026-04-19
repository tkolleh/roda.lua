# Roda Project Hub
# Pure Lua terminal spinner library with CLI tool
# Usage: just <recipe> [args...]
#
# Expected .env variables (optional, override defaults):
#   LUA_PREFIX  - Path to Lua installation (default: brew --prefix lua)
#   BUILD_DIR   - Build output directory (default: .build)
#   LOG_LEVEL   - Logging verbosity (default: info)
# --- Global Settings ---

set unstable := true

# Enable latest Just features

mod demo

set dotenv-load := true

# Auto-load .env files

set export := true

# Export variables to recipe environment
# Shell configuration (bash works on macOS & Linux, Windows uses PowerShell)

set shell := ["bash", "-euo", "pipefail", "-c"]
set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

# Consistent shell with strict mode

set positional-arguments := true

# Enable $@ for recipe arguments
# Cross-platform support
# --- Variables ---
# Lua installation prefix (default: brew --prefix lua on macOS, /usr on other platforms)

lua_prefix := env('LUA_PREFIX', if os() == "macos" { `brew --prefix lua` } else { "/usr" })

# Lua version for development headers (default: 5.5 on macOS, 5.4 on Linux)

lua_version := env('LUA_VERSION', if os() == "macos" { "5.5" } else { "5.4" })

# Add lux build dependencies to PATH so luastatic can be found automatically
path_sep := if os() == "windows" { ";" } else { ":" }
export PATH := absolute_path(".lux/" + lua_version + "/build_dependencies/" + lua_version + "/bin") + path_sep + env_var('PATH')

# Include path for Lua development headers (override with LUA_INCLUDE env var)

lua_include := env('LUA_INCLUDE', lua_prefix / ("include/lua" + lua_version))

# Static Lua library (default: unversioned name; override with LUA_LIB env var)

lua_lib_unversioned := lua_prefix / "lib/liblua.a"
lua_lib := env('LUA_LIB', lua_lib_unversioned)
macos_version := if os() == "macos" { `sw_vers -productVersion | cut -d. -f1-2` } else { "" }
build_dir := absolute_path(clean(env('BUILD_DIR', '.build')))
package_name := "roda"

# Cross-compilation support (set CMAKE_OSX_ARCHITECTURES and CC env vars for cross builds)

cmake_osx_arch := env('CMAKE_OSX_ARCHITECTURES', '')
cmake_osx_arch_flag := if cmake_osx_arch != "" { "-DCMAKE_OSX_ARCHITECTURES=" + cmake_osx_arch } else { "" }
cc := env('CC', 'gcc')

# --- Default ---

[doc("Show all available recipes grouped by category")]
default:
    @just --list

# --- Validation ---

[doc("Validate environment and tooling")]
[group('workflow')]
check-env:
    @echo {{ assert(lua_prefix != '', "Lua not found! Set LUA_PREFIX env var or install via brew") }}
    @echo "Lua prefix: {{ lua_prefix }}"
    @echo "Build dir: {{ build_dir }}"
    @echo "Environment validated."

# --- Core Development ---

[doc("Format Lua files")]
[group('dev')]
fmt:
    lx --lua-version {{ lua_version }} fmt

[doc("Lint Lua files")]
[group('dev')]
lint:
    lx --lua-version {{ lua_version }} check

[doc("Lint for CI (Lua 5.4)")]
[group('ci')]
lint-ci:
    lx --lua-version 5.4 --lua-dir {{ lua_prefix }} lint

[doc("Run code quality checks")]
[group('dev')]
check: lint fmt

# --- Unit Tests ---

[doc("Run unit tests (all spec/*_spec.lua files via lux/busted)")]
[group('test')]
test-unit: build-luv
    @echo "Running unit tests..."
    LUA_CPATH="{{ build_dir }}/?.so;;" lx --lua-version {{ lua_version }} --lua-dir {{ lua_prefix }} test

[doc("Alias for test-unit")]
[group('test')]
test: test-unit

[doc("Run unit tests with coverage and generate report")]
[group('test')]
test-coverage: build-luv
    @echo "Running unit tests with coverage..."
    LUA_CPATH="{{ build_dir }}/?.so;;" lx --lua-version 5.5 --lua-dir {{ lua_prefix }} test -- --coverage
    @echo "Generating coverage report..."
    @luacov_src=$(find .lux/5.5/test_dependencies/5.5 -maxdepth 1 -name '*luacov*' -type d -print -quit 2>/dev/null)/src; \
    lx exec --no-loader lua -- -e "package.path = package.path .. ';"$luacov_src"/?.lua'; local r = require('luacov.runner'); r.run_report(r.load_config())"
    @echo "Coverage report written to luacov.report.out"

[doc("Run unit tests for CI (Lua 5.4)")]
[group('ci')]
test-ci: build-luv
    @echo "Running unit tests for CI..."
    LUA_CPATH="{{ build_dir }}/?.so;;" lx --lua-version 5.4 --lua-dir {{ lua_prefix }} test

# --- Build ---

[doc("Ensure all lux dependencies are installed")]
[private]
ensure-deps:
    @echo "Ensuring dependencies are installed..."
    lx --lua-version {{ lua_version }} --lua-dir {{ lua_prefix }} build --only-deps --no-lock

[doc("Build the standalone executable")]
[group('build')]
build: ensure-deps prep build-luv build-system compile

[doc("Prepare the build directory")]
[group('build')]
[private]
prep:
    mkdir -p {{ build_dir }}

[doc("Statically compile luv (CMake)")]
[group('build')]
[private]
build-luv: prep
    @echo "Building static luv and shared module..."
    {{ if path_exists(build_dir / "luv") == "true" { "" } else { "git clone --recursive https://github.com/luvit/luv.git " + (build_dir / "luv") } }}
    cd {{ build_dir / 'luv' }} && cmake -DCMAKE_C_FLAGS="-Wno-error=incompatible-pointer-types" -DBUILD_MODULE=ON -DBUILD_STATIC_LIBS=ON -DWITH_LUA_ENGINE=Lua -DLUA_BUILD_TYPE=System -DLUA_INCLUDE_DIR={{ lua_include }} -DLUA_LIBRARIES={{ lua_lib }} {{ cmake_osx_arch_flag }} .
    cd {{ build_dir / 'luv' }} && cmake --build .
    cp {{ build_dir / 'luv' / 'libluv.a' }} {{ build_dir }}/
    cp {{ build_dir / 'luv' / 'deps' / 'libuv' / 'libuv.a' }} {{ build_dir }}/
    cp {{ build_dir / 'luv' / 'luv.so' }} {{ build_dir }}/ 2>/dev/null || cp {{ build_dir / 'luv' / 'luv.dll' }} {{ build_dir }}/ 2>/dev/null || true

[doc("Statically compile luasystem (GCC/AR)")]
[group('build')]
[private]
build-system: prep
    @echo "Building static luasystem..."
    {{ if path_exists(build_dir / "luasystem") == "true" { "" } else { "git clone https://github.com/o-lim/luasystem.git " + (build_dir / "luasystem") } }}
    cd {{ build_dir / 'luasystem' }} && {{ cc }} \
      -Wno-error=incompatible-pointer-types \
      {{ if os() == "windows" { "-D_WIN32_WINNT=0x0601" } else { "" } }} \
      -c src/core.c src/compat.c src/time.c \
      -I{{ lua_include }}
    cd {{ build_dir / 'luasystem' }} && ar rcs libsystem.a core.o compat.o time.o
    cp {{ build_dir / 'luasystem' / 'libsystem.a' }} {{ build_dir }}/

[doc("Compile the final binary using luastatic")]
[group('build')]
[private]
compile:
    @echo {{ assert(path_exists("bin/spin.lua") == "true", "bin/spin.lua not found - CLI entry point missing") }}
    @echo "Compiling standalone binary..."
    cd lua && PATH="/ucrt64/bin:$PATH" lx --lua-version {{ lua_version }} exec -- luastatic ../bin/spin.lua \
      roda/init.lua roda/spinners.lua roda/ansi.lua roda/symbols.lua roda/util.lua roda/argp.lua \
      {{ build_dir / 'libluv.a' }} {{ build_dir / 'libuv.a' }} {{ build_dir / 'libsystem.a' }} {{ lua_lib }} \
      {{ if os() == "windows" { "-lwinmm -lws2_32" } else { "" } }} \
      -I{{ lua_include }} && \
    mv spin.luastatic.c {{ build_dir }}/ && \
    cd .. && \
    mv lua/{{ if os() == "windows" { "spin.exe" } else { "spin" } }} {{ if os() == "windows" { "roda.exe" } else { "roda" } }}

[doc("Test the standalone executable")]
[group('test')]
test-cli: build
    @echo "=== Test 1: Normal execution (sleep 2) ==="
    ./roda --title "Sleeping..." -- sleep 2
    @echo "=== Test 2: Custom spinner (sleep 1) ==="
    ./roda --title "Sleeping..." --spinner "line" -- sleep 1
    @echo "=== Test 3: Error case (nonexistent command) ==="
    ./roda --title "Missing command" -- nonexistentcommand || true
    @echo "=== Test 4: Command returns false (exit code 1) ==="
    ./roda --title "Failing" -- false || true
    @echo "=== Test 5: Show output flag ==="
    ./roda --show-output -- echo "hello"
    @echo "=== Test 6: No command (should exit 0) ==="
    ./roda
    @echo "=== Test 7: Invalid spinner name ==="
    ./roda --spinner invalid_spinner -- sleep 1 || true
    @echo "All tests completed!"

[doc("Run all tests (unit + CLI)")]
[group('test')]
test-all: test-unit test-cli

[doc("Performance benchmark: verify roda adds minimal overhead to wrapped commands")]
[group('test')]
test-perf: build
    @echo "Running performance benchmark..."
    @echo "Benchmarking: roda --title 'test' -- sleep 1"
    @hyperfine --warmup 1 --runs 5 \
        --min-runs 3 \
        --export-json .build/benchmark-results.json \
        --export-markdown .build/benchmark-results.md \
        "./roda --title 'perf-test' -- sleep 1"
    @echo ""
    @echo "Results saved to .build/benchmark-results.json and .build/benchmark-results.md"
    @# Validate: sleep 1 should complete in < 1.3s (1s sleep + 0.3s overhead budget)
    @MEAN=$(jq -r '.results[0].mean' .build/benchmark-results.json) && \
        echo "Mean execution time: $${MEAN}s" && \
        PASS=$(echo "$$MEAN < 1.3" | bc -l) && \
        if [ "$$PASS" -eq 1 ]; then \
            echo "✅ Performance check passed (threshold: 1.3s)"; \
        else \
            echo "❌ Performance check FAILED: mean $${MEAN}s exceeds 1.3s threshold"; \
            exit 1; \
        fi

# --- Workflow ---

[doc("Install dependencies")]
[group('workflow')]
install:
    lx --lua-version {{ lua_version }} build --only-deps --no-lock

[doc("Run spinner directly without building (development mode)")]
[group('dev')]
dev *args:
    @lx lua --no-lock -- bin/spin.lua {{ args }}

[doc("Full pre-commit validation (code quality + unit tests)")]
[group('workflow')]
validate: check test

[doc("Full CI pipeline (validate + build + integration tests)")]
[group('workflow')]
all: validate build test-cli

# --- Release & Publishing ---

[doc("Prepare release (requires full pipeline to pass)")]
[group('release')]
release: all
    @echo "Preparing release..."
    @echo "Release artifacts ready."

[confirm("Publish to LuaRocks? This action cannot be undone.")]
[doc("Publish to LuaRocks via lux")]
[group('release')]
publish: release
    @echo "Publishing to LuaRocks..."
    lx --lua-version {{ lua_version }} publish

# --- Local CI (act) ---

[doc("Run test job locally via act (requires: docker, gh auth login)")]
[group('ci')]
act-test:
    act push --job test -W .github/workflows/tests.yml -s GITHUB_TOKEN="$(gh auth token)"

[doc("Run lint job locally via act")]
[group('ci')]
act-lint:
    act push --job lint -W .github/workflows/tests.yml -s GITHUB_TOKEN="$(gh auth token)"

[doc("Run publish validation locally via act (upload step skipped)")]
[group('ci')]
act-publish:
    act workflow_dispatch -W .github/workflows/publish.yml -s GITHUB_TOKEN="$(gh auth token)"

# --- Maintenance ---

[confirm("Remove all build artifacts and binaries?")]
[doc("Clean build artifacts")]
[group('maintenance')]
clean:
    rm -rf {{ build_dir }}
    rm -f roda
    rm -f *.luastatic.c lua/*.luastatic.c || true

[doc("Update lux dependencies")]
[group('maintenance')]
update:
    lx --lua-version {{ lua_version }} update
