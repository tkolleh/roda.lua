# Plan for Issue #17: Release Workflow Enhancements

## Objective
Update the release workflow to automatically build and attach the `roda` executable, its SHA256 checksum, and the source code archive to the GitHub release. Ensure the changelog generation is properly handled. The project should be released to luarocks following the best practices for lua projects.

## Current State
- The `.github/workflows/release-please.yml` workflow uses `googleapis/release-please-action@v4` with `release-type: simple`.
- It creates a PR with changelog updates and creates a GitHub release when merged.
- However, it does not build the standalone executable, nor attach it to the GitHub release.
- The GitHub release automatically includes the source code archive (zip/tar.gz) and the changelog in the release body.

## Research Findings (Based on Researcher Analysis)
The project has a Lua version mismatch between development and CI environments:
- **Development**: Defaults to Lua 5.5 (macOS Homebrew)
- **CI (Ubuntu 24.04)**: Only provides Lua 5.4 packages (`lua5.4`, `liblua5.4-dev`)
- The `justfile` hard‑codes `lua_version := "5.5"`, causing build failures in CI

**Best Practice Recommendations:**
1. Implement adaptive Lua version detection with environment variable overrides
2. Use multi‑path library detection for Ubuntu's multiarch layout (`/usr/lib/x86_64-linux-gnu/`)
3. Default to Lua 5.5 on macOS, 5.4 on Linux
4. Allow explicit override via `LUA_VERSION` environment variable
5. Consider just modules for CI‑specific recipes (optional, due to variable sharing limitations)

## Updated Step-by-Step Plan

### Phase 1: Fix Build Environment & Lua Version Management
1. **Update `justfile` with adaptive Lua detection**:
   - Replace hard‑coded `lua_version := "5.5"` with conditional default (5.5 on macOS, 5.4 on Linux)
   - Add multi‑path library detection for `liblua.a` (versioned, unversioned, multiarch)
   - Update all Lux commands to use `{{lua_version}}` variable
   - Allow override via `LUA_VERSION`, `LUA_INCLUDE`, `LUA_LIB`, `LUA_PREFIX` environment variables

2. **Install Required Dependencies in CI**:
   - Install `build-essential`, `cmake`, `luarocks`, `lua5.4`, `liblua5.4-dev`
   - **Do NOT symlink `liblua.a`** – let the justfile's path detection handle it

### Phase 2: Update Release Workflow
3. **Add CI Environment Variables**:
   - Set `LUA_VERSION=5.4` in release‑please.yml workflow
   - Set `LUA_PREFIX=/usr` for Ubuntu CI environment

4. **Build Executable**:
   - Run `just build` with proper environment variables
   - Generate SHA256 checksum: `sha256sum roda > roda.sha256`

5. **Generate & Validate Rockspec**:
   - Run `lx generate-rockspec` to create `.rockspec` file
   - Add `luarocks lint *.rockspec` validation step

6. **Upload Artifacts**:
   - Use `gh release upload` to attach `roda`, `roda.sha256`, and `*.rockspec`
   - Publish to LuaRocks with `luarocks upload`

### Phase 3: Testing & Validation
7. **Manual Test Before Merge**:
   - Create temporary tag `v9.9.9‑test`
   - Trigger workflow via `workflow_dispatch` to verify all steps succeed

8. **Add CI Build Verification**:
   - Add a `build` job to existing CI workflows
   - Test that the static linking works with Ubuntu packages

### Phase 4: Documentation & Maintenance
9. **Update Project Documentation**:
   - Update `AGENTS.md` with new environment variables
   - Document Lua version management approach

10. **Future Enhancements** (Optional):
    - Create just module for CI‑specific recipes (`.github/justfile` or `justfile.ci`)
    - Add multi‑version CI matrix (Lua 5.1, 5.3, 5.4, 5.5)
    - Implement caching for build directory
    - Create Lua installation script for CI

## Implementation Details

### Updated justfile Changes (Core Fix)
```diff
--- a/justfile
+++ b/justfile
@@ -33,14 +33,24 @@ set positional-arguments := true
 # Cross-platform support
 # --- Variables ---
 
 # Lua installation prefix (default: brew --prefix lua on macOS, /usr on other platforms)
 lua_prefix := env('LUA_PREFIX', if os() == "macos" { `brew --prefix lua` } else { "/usr" })
-# Lua version for development headers (default: 5.5)
-lua_version := "5.5"
+# Lua version for development headers (default: 5.5 on macOS, 5.4 on Linux)
+lua_version := env('LUA_VERSION', if os() == "macos" { "5.5" } else { "5.4" })
 # Include path for Lua development headers (override with LUA_INCLUDE env var)
 lua_include := env('LUA_INCLUDE', lua_prefix / ("include/lua" + lua_version))
-# Static Lua library (adjust path if using shared library)
-lua_lib := lua_prefix / "lib/liblua.a"
+# Static Lua library (try versioned name first, then fallback to liblua.a)
+lua_lib_versioned := lua_prefix / ("lib/liblua" + lua_version + ".a")
+lua_lib_unversioned := lua_prefix / "lib/liblua.a"
+lua_lib_multiarch := "/usr/lib/x86_64-linux-gnu/liblua" + lua_version + ".a"
+lua_lib := env('LUA_LIB',
+  if path_exists(lua_lib_versioned) {
+    lua_lib_versioned
+  } else if path_exists(lua_lib_unversioned) {
+    lua_lib_unversioned
+  } else {
+    lua_lib_multiarch
+  })
 macos_version := if os() == "macos" { `sw_vers -productVersion | cut -d. -f1-2` } else { "" }
 build_dir := absolute_path(clean(env('BUILD_DIR', '.build')))
 package_name := "roda"
```

### Updated Workflow Example
```yaml
      - name: Checkout repository
        if: ${{ steps.release.outputs.release_created }}
        uses: actions/checkout@v4
        with:
          ref: ${{ steps.release.outputs.tag_name }}

      - name: Install System Dependencies
        if: ${{ steps.release.outputs.release_created }}
        run: |
          sudo apt-get update -qq
          sudo apt-get install -y -qq build-essential cmake luarocks lua5.4 liblua5.4-dev

      - name: Install Lux
        if: ${{ steps.release.outputs.release_created }}
        uses: lumen-oss/gh-actions-lux@v1
        with:
          version: 0.25.3

      - name: Install just
        if: ${{ steps.release.outputs.release_created }}
        run: |
          mkdir -p /tmp/just
          curl -L https://github.com/casey/just/releases/download/1.48.1/just-1.48.1-x86_64-unknown-linux-musl.tar.gz -o /tmp/just/just.tar.gz
          tar -xzf /tmp/just/just.tar.gz -C /tmp/just
          sudo mv /tmp/just/just /usr/local/bin/
          rm -rf /tmp/just

      - name: Build Executable
        if: ${{ steps.release.outputs.release_created }}
        env:
          LUA_VERSION: "5.4"
          LUA_PREFIX: "/usr"
        run: |
          just build
          sha256sum roda > roda.sha256

      - name: Generate Rockspec
        if: ${{ steps.release.outputs.release_created }}
        run: |
          lx generate-rockspec

      - name: Validate Rockspec
        if: ${{ steps.release.outputs.release_created }}
        run: |
          luarocks lint *.rockspec

      - name: Upload Release Artifacts
        if: ${{ steps.release.outputs.release_created }}
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        run: |
          gh release upload ${{ steps.release.outputs.tag_name }} roda roda.sha256 *.rockspec

      - name: Publish to LuaRocks
        if: ${{ steps.release.outputs.release_created }}
        env:
          LUAROCKS_API_KEY: ${{ secrets.LUAROCKS_API_KEY }}
        run: |
          luarocks upload *.rockspec --api-key=${LUAROCKS_API_KEY}
```

## Risk Assessment
- **Low Risk**: Adaptive detection maintains backward compatibility
- **Medium Risk**: Path detection may need adjustment for uncommon distributions
- **Mitigation**: Environment variable overrides provide escape hatch

## Success Criteria
1. Release workflow builds `roda` executable successfully in CI
2. Artifacts (executable, checksum, rockspec) attached to GitHub release
3. Project published to LuaRocks without errors
4. No regression in existing CI workflows
5. Local development continues to work (macOS with Lua 5.5)
