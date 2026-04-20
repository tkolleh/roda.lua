#!/usr/bin/env bash
# build-windows.sh — Build standalone roda.exe on MSYS2/UCRT64
#
# Required environment variables (set by the workflow before calling this script):
#   BUILD_DIR    — build output directory (Windows or POSIX path; normalized below)
#   LUA_PREFIX   — path to Lua installation (e.g. /ucrt64)
#   LUA_LIB      — path to liblua.a static library
#   LUA_INCLUDE  — path to Lua headers directory
#   LUA_VERSION  — Lua version string (e.g. "5.4")
#
# Design decisions (log-confirmed, agent-researched):
#   - All incoming paths are normalized to POSIX via cygpath -u at the top.
#     just's absolute_path() emits Windows-style paths (D:\a\...) which bash
#     mangles by stripping backslashes before any tool can process them.
#   - cmake uses -S/-B flags (no "cd DIR && cmake .") to eliminate CWD dependency.
#     The "cd + cmake ." pattern caused cmake to write build files to a mangled
#     path (D:/aroda.luaroda.lua.build/luv) instead of the intended directory.
#   - BUILD_MODULE=OFF: static-only build; no .dll needed (tests not run on Windows).
#   - luasystem cloned from lunarmodules/luasystem (canonical, actively maintained).
#   - CC=gcc set explicitly: MSYS2 UCRT64 has no "cc" symlink; luastatic defaults
#     to "cc" and fails with "C compiler not found" without this.
#   - Full libuv Windows link flags: -lws2_32 -lpsapi -liphlpapi -luserenv -ldbghelp
#     (sourced from libuv's CMakeLists.txt WIN32 target_link_libraries list).
#   - -static-libgcc: prevents dependency on libgcc_s_seh-1.dll at runtime.

set -euo pipefail

# ── 1. Normalize ALL incoming paths to POSIX ───────────────────────────────
# cygpath -u: D:\a\foo → /d/a/foo
# The || echo fallback is a no-op safety net (cygpath always exists on MSYS2).
_posix() { cygpath -u "$1" 2>/dev/null || echo "$1"; }

BUILD_DIR=$(_posix "${BUILD_DIR:?BUILD_DIR is required}")
LUA_PREFIX=$(_posix "${LUA_PREFIX:?LUA_PREFIX is required}")
LUA_LIB=$(_posix "${LUA_LIB:?LUA_LIB is required}")
LUA_INCLUDE=$(_posix "${LUA_INCLUDE:?LUA_INCLUDE is required}")
LUA_VERSION="${LUA_VERSION:?LUA_VERSION is required}"

echo "=== Windows build configuration ==="
echo "  BUILD_DIR:   ${BUILD_DIR}"
echo "  LUA_PREFIX:  ${LUA_PREFIX}"
echo "  LUA_LIB:     ${LUA_LIB}"
echo "  LUA_INCLUDE: ${LUA_INCLUDE}"
echo "  LUA_VERSION: ${LUA_VERSION}"
echo "  PATH:        ${PATH}"

# ── 2. Ensure build directory exists ───────────────────────────────────────
mkdir -p "${BUILD_DIR}"

# ── 3. Install lux build dependencies (luastatic) ──────────────────────────
echo "=== Installing lux build dependencies ==="
lx --lua-version "${LUA_VERSION}" --lua-dir "${LUA_PREFIX}" build --only-deps --no-lock

# ── 4. Clone luv (if not already present) ──────────────────────────────────
LUV_SRC="${BUILD_DIR}/luv"
LUV_BUILD="${BUILD_DIR}/luv-build"

if [[ ! -d "${LUV_SRC}" ]]; then
  echo "=== Cloning luv ==="
  git clone --recursive https://github.com/luvit/luv.git "${LUV_SRC}"
fi

# ── 5. Build luv statically with CMake + Ninja ─────────────────────────────
# -S/-B flags: no CWD dependency, no path mangling from "cd DIR && cmake ."
# BUILD_MODULE=OFF: static archive only; no .dll needed (no tests on Windows)
# libluv_a.a: luv's CMake names the static archive with _a suffix when
#             BUILD_MODULE=ON would conflict; with OFF it may be libluv.a —
#             we copy both names to cover either case.
echo "=== Building luv (CMake + Ninja) ==="
mkdir -p "${LUV_BUILD}"

cmake -G Ninja \
  -S "${LUV_SRC}" \
  -B "${LUV_BUILD}" \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_MODULE=OFF \
  -DBUILD_STATIC_LIBS=ON \
  -DWITH_LUA_ENGINE=Lua \
  -DLUA_BUILD_TYPE=System \
  -DLUA_INCLUDE_DIR="${LUA_INCLUDE}" \
  -DLUA_LIBRARIES="${LUA_LIB}" \
  -DCMAKE_C_FLAGS="-Wno-error=incompatible-pointer-types"

cmake --build "${LUV_BUILD}"

# Copy static archives — handle both libluv.a and libluv_a.a naming
cp "${LUV_BUILD}/libluv_a.a" "${BUILD_DIR}/libluv.a" 2>/dev/null || \
  cp "${LUV_BUILD}/libluv.a"   "${BUILD_DIR}/libluv.a"
cp "${LUV_BUILD}/deps/libuv/libuv.a" "${BUILD_DIR}/"

# ── 6. Clone luasystem (if not already present) ────────────────────────────
LUASYSTEM_SRC="${BUILD_DIR}/luasystem"

if [[ ! -d "${LUASYSTEM_SRC}" ]]; then
  echo "=== Cloning luasystem ==="
  git clone https://github.com/lunarmodules/luasystem.git "${LUASYSTEM_SRC}"
fi

# ── 7. Build luasystem statically with GCC/AR ──────────────────────────────
# -D_WIN32_WINNT=0x0601: Windows 7+ baseline (matches libuv minimum)
# Source files from lunarmodules/luasystem (superset of o-lim fork)
echo "=== Building luasystem (GCC/AR) ==="
pushd "${LUASYSTEM_SRC}"

gcc -O2 -fno-common \
  -DWINVER=0x0600 -D_WIN32_WINNT=0x0601 \
  -Wno-error=incompatible-pointer-types \
  -I"${LUA_INCLUDE}" \
  -c src/bitflags.c src/compat.c src/core.c src/environment.c \
     src/random.c src/term.c src/time.c src/wcwidth.c \
     src/wcwidth_ambiguous_width.c src/wcwidth_double_width.c \
     src/wcwidth_zero_width.c

ar rcs "${BUILD_DIR}/libsystem.a" \
  bitflags.o compat.o core.o environment.o \
  random.o term.o time.o wcwidth.o \
  wcwidth_ambiguous_width.o wcwidth_double_width.o wcwidth_zero_width.o
popd

# ── 8. Compile standalone binary with luastatic ────────────────────────────
# CC is hardcoded to "gcc -static-libgcc" here rather than inherited from the
# environment for two reasons:
#   1. MSYS2 UCRT64 has no "cc" symlink; luastatic defaults to
#      os.getenv("CC") or "cc" and fails with "C compiler not found".
#   2. -static-libgcc prevents a runtime dependency on libgcc_s_seh-1.dll.
# The Unix justfile path uses cc := env('CC', 'gcc') to allow cross-compile
# overrides (e.g. CC="clang -arch x86_64" for macOS x86_64). Windows does
# not cross-compile, so hardcoding is correct and intentional here.
#
# Windows link flags (sourced from libuv CMakeLists.txt WIN32 section):
#   -lws2_32   Winsock2 (libuv networking)
#   -lpsapi    Process Status API (libuv process memory)
#   -liphlpapi IP Helper API (libuv network interface enumeration)
#   -luserenv  User Environment (libuv process spawning)
#   -ldbghelp  Debug Help (libuv stack traces)
echo "=== Compiling standalone binary with luastatic ==="
export CC="gcc -static-libgcc"
export PATH="/ucrt64/bin:${PATH}"

pushd lua

lx --lua-version "${LUA_VERSION}" exec -- luastatic \
  ../bin/spin.lua \
  roda/init.lua roda/spinners.lua roda/ansi.lua \
  roda/symbols.lua roda/util.lua roda/argp.lua \
  "${BUILD_DIR}/libluv.a" \
  "${BUILD_DIR}/libuv.a" \
  "${BUILD_DIR}/libsystem.a" \
  "${LUA_LIB}" \
  -lws2_32 -lpsapi -liphlpapi -luserenv -ldbghelp \
  -I"${LUA_INCLUDE}"

mv spin.luastatic.c "${BUILD_DIR}/"
mv spin.exe ../roda.exe
popd

echo "=== Build complete: roda.exe ==="
