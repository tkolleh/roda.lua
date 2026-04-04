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

set dotenv-load := true

# Auto-load .env files

set export := true

# Export variables to recipe environment

set shell := ["zsh", "-euo", "pipefail", "-c"]

# Consistent shell with strict mode

set positional-arguments := true

# Enable $@ for recipe arguments

set windows-shell := ["powershell.exe", "-NoLogo", "-Command"]

# Cross-platform support
# --- Variables ---

lua_prefix := env('LUA_PREFIX', `brew --prefix lua`)
lua55_dir := "/opt/homebrew/opt/lua"
lua_include := lua55_dir / "include/lua5.5"
lua_lib := lua_prefix / "lib/liblua.a"
macos_version := if os() == "macos" { `sw_vers -productVersion | cut -d. -f1-2` } else { "" }
build_dir := absolute_path(clean(env('BUILD_DIR', '.build')))
package_name := "roda"

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
    lx --lua-version 5.5 fmt

[doc("Lint Lua files")]
[group('dev')]
lint:
    lx --lua-version 5.5 check

[doc("Lint for CI (Lua 5.4)")]
[group('ci')]
lint-ci:
    lx --lua-version 5.4 --variables "WITH_SHARED_LIBUV=OFF" --no-lock lint

[doc("Run code quality checks")]
[group('dev')]
check: lint fmt

# --- Unit Tests ---

[doc("Run unit tests (all spec/*_spec.lua files via lux/busted)")]
[group('test')]
test-unit:
    @echo "Running unit tests..."
    lx --lua-version 5.5 --lua-dir {{ lua55_dir }} --variables "WITH_SHARED_LIBUV=OFF" test

[doc("Alias for test-unit")]
[group('test')]
test: test-unit

[doc("Run unit tests for CI (Lua 5.4)")]
[group('ci')]
test-ci:
    @echo "Running unit tests for CI..."
    lx --lua-version 5.4 --variables "WITH_SHARED_LIBUV=OFF" --no-lock test

# --- Build ---

[doc("Ensure all lux dependencies are installed")]
[private]
ensure-deps:
    @echo "Ensuring dependencies are installed..."
    CFLAGS="-I{{ lua55_dir }}/include/lua5.5 {{ if os() == 'macos' { '-mmacosx-version-min=' + macos_version } else { '' } }}" \
    {{ if os() == 'macos' { 'MACOSX_DEPLOYMENT_TARGET=' + macos_version } else { '' } }} \
    lx --lua-version 5.5 --lua-dir {{ lua55_dir }} --variables "WITH_SHARED_LIBUV=OFF" build --only-deps --no-lock

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
    @echo "Building static luv..."
    {{ if path_exists(build_dir / "luv") == "true" { "" } else { "git clone --recursive https://github.com/luvit/luv.git " + (build_dir / "luv") } }}
    cd {{ build_dir / 'luv' }} && cmake -DBUILD_STATIC_LIBS=ON -DBUILD_MODULE=OFF -DWITH_LUA_ENGINE=Lua -DLUA_BUILD_TYPE=System -DLUA_INCLUDE_DIR={{ lua_include }} -DLUA_LIBRARIES={{ lua_lib }} .
    cd {{ build_dir / 'luv' }} && make
    cp {{ build_dir / 'luv' / 'libluv.a' }} {{ build_dir }}/
    cp {{ build_dir / 'luv' / 'deps' / 'libuv' / 'libuv.a' }} {{ build_dir }}/

[doc("Statically compile luasystem (GCC/AR)")]
[group('build')]
[private]
build-system: prep
    @echo "Building static luasystem..."
    {{ if path_exists(build_dir / "luasystem") == "true" { "" } else { "git clone https://github.com/o-lim/luasystem.git " + (build_dir / "luasystem") } }}
    cd {{ build_dir / 'luasystem' }} && gcc -c src/core.c src/compat.c src/time.c -I{{ lua_include }}
    cd {{ build_dir / 'luasystem' }} && ar rcs libsystem.a core.o compat.o time.o
    cp {{ build_dir / 'luasystem' / 'libsystem.a' }} {{ build_dir }}/

[doc("Compile the final binary using luastatic")]
[group('build')]
[private]
compile:
    @echo "Compiling standalone binary..."
    cd lua && luastatic ../bin/spin.lua \
      roda/init.lua roda/spinners.lua roda/ansi.lua roda/symbols.lua roda/util.lua roda/argp.lua \
      ../{{ build_dir / 'libluv.a' }} ../{{ build_dir / 'libuv.a' }} ../{{ build_dir / 'libsystem.a' }} {{ lua_lib }} \
      -I{{ lua_include }} && \
    mv spin.luastatic.c ../{{ build_dir }}/ && \
    cd .. && \
    mv lua/spin roda

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
    CFLAGS="-I{{ lua55_dir }}/include/lua5.5 {{ if os() == 'macos' { '-mmacosx-version-min=' + macos_version } else { '' } }}" \
    {{ if os() == 'macos' { 'MACOSX_DEPLOYMENT_TARGET=' + macos_version } else { '' } }} \
    lx --lua-version 5.5 --lua-dir {{ lua55_dir }} --variables "WITH_SHARED_LIBUV=OFF" build --only-deps --no-lock

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

[doc("Publish to LuaRocks via lux")]
[confirm("Publish to LuaRocks? This action cannot be undone.")]
[group('release')]
publish: release
    @echo "Publishing to LuaRocks..."
    lx --lua-version 5.5 publish

# --- Maintenance ---

[doc("Clean build artifacts")]
[confirm("Remove all build artifacts and binaries?")]
[group('maintenance')]
clean:
    rm -rf {{ build_dir }}
    rm -f roda
    rm -f *.luastatic.c lua/*.luastatic.c || true

[doc("Update lux dependencies")]
[group('maintenance')]
update:
    lx --lua-version 5.5 update
