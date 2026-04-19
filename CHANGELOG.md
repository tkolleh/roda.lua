# Changelog

## [1.16.6](https://github.com/tkolleh/roda.lua/compare/v1.16.5...v1.16.6) (2026-04-19)


### Bug Fixes

* **ci:** fix Windows path mangling in cp/mv by converting build_dir to POSIX ([dfd7953](https://github.com/tkolleh/roda.lua/commit/dfd7953cec59357d374a90df86c63deaa7ef390f))

## [1.16.5](https://github.com/tkolleh/roda.lua/compare/v1.16.4...v1.16.5) (2026-04-19)


### Bug Fixes

* **ci:** fix Windows build and upgrade Lux + action dependencies ([#63](https://github.com/tkolleh/roda.lua/issues/63)) ([b693dab](https://github.com/tkolleh/roda.lua/commit/b693dab629067b65a90d51fbefa23963c37a194f))

## [1.16.4](https://github.com/tkolleh/roda.lua/compare/v1.16.3...v1.16.4) (2026-04-19)


### Bug Fixes

* **ci:** use cmake --build . instead of make for luv ([#61](https://github.com/tkolleh/roda.lua/issues/61)) ([8431c0b](https://github.com/tkolleh/roda.lua/commit/8431c0b3730d241ec1ea0fac16061f64ae28b971))

## [1.16.3](https://github.com/tkolleh/roda.lua/compare/v1.16.2...v1.16.3) (2026-04-19)


### Bug Fixes

* **ci:** fix gcc 14+ incompatible-pointer-types error on Windows ([#59](https://github.com/tkolleh/roda.lua/issues/59)) ([560c74f](https://github.com/tkolleh/roda.lua/commit/560c74f85197f8bfdf5e17f55ff0f69bf7340ae7))

## [1.16.2](https://github.com/tkolleh/roda.lua/compare/v1.16.1...v1.16.2) (2026-04-19)


### Bug Fixes

* **ci:** use correct path separator in justfile for Windows ([#57](https://github.com/tkolleh/roda.lua/issues/57)) ([036d66e](https://github.com/tkolleh/roda.lua/commit/036d66e452d0c3d0fdd9bec499083057b4b43671))

## [1.16.1](https://github.com/tkolleh/roda.lua/compare/v1.16.0...v1.16.1) (2026-04-19)


### Bug Fixes

* **ci:** add UCRT64 to GITHUB_PATH for Windows build ([#55](https://github.com/tkolleh/roda.lua/issues/55)) ([59ef9d6](https://github.com/tkolleh/roda.lua/commit/59ef9d6d5e706102af95661efd8ab2cfb031a4a1))

## [1.16.0](https://github.com/tkolleh/roda.lua/compare/v1.15.0...v1.16.0) (2026-04-19)


### Features

* **ci:** Security hardening - SLSA Level 3 compliance and Renovate migration ([#53](https://github.com/tkolleh/roda.lua/issues/53)) ([580274e](https://github.com/tkolleh/roda.lua/commit/580274e71fcf7a03b753741f366382da54a753d9))

## [1.15.0](https://github.com/tkolleh/roda.lua/compare/v1.14.0...v1.15.0) (2026-04-19)


### Features

* Add code coverage ([#50](https://github.com/tkolleh/roda.lua/issues/50)) ([e9a1981](https://github.com/tkolleh/roda.lua/commit/e9a19819652d92c7312e912c4cb0780ccff4faf2))

## [1.14.0](https://github.com/tkolleh/roda.lua/compare/v1.13.10...v1.14.0) (2026-04-09)


### Features

* add Homebrew formula support and expand CI platform matrix ([010db21](https://github.com/tkolleh/roda.lua/commit/010db21af30cb779dfc33339467e4c5a98cf8039))

## [1.13.10](https://github.com/tkolleh/roda.lua/compare/v1.13.9...v1.13.10) (2026-04-09)


### Bug Fixes

* **ci:** remove invalid luarocks package from msys2 install list ([#43](https://github.com/tkolleh/roda.lua/issues/43)) ([c5b0335](https://github.com/tkolleh/roda.lua/commit/c5b0335f41283c97b66cd8dd9ba3f18181a35b7f))

## [1.13.9](https://github.com/tkolleh/roda.lua/compare/v1.13.8...v1.13.9) (2026-04-09)


### Bug Fixes

* trigger release to build cross-platform binaries ([#41](https://github.com/tkolleh/roda.lua/issues/41)) ([4da7ac5](https://github.com/tkolleh/roda.lua/commit/4da7ac5289152a44fe89a637468f4dbb639e91cf))

## [1.13.8](https://github.com/tkolleh/roda.lua/compare/v1.13.7...v1.13.8) (2026-04-09)


### Bug Fixes

* **ci:** consolidate LuaRocks publication to tag-triggered workflow ([#37](https://github.com/tkolleh/roda.lua/issues/37)) ([843baec](https://github.com/tkolleh/roda.lua/commit/843baec18968cf03ad49d19ba6bc0003c11ae087))

## [1.13.7](https://github.com/tkolleh/roda.lua/compare/v1.13.6...v1.13.7) (2026-04-09)


### Bug Fixes

* **build:** Add missing CLI entry point and upgrade Lux to v0.28.0 ([#35](https://github.com/tkolleh/roda.lua/issues/35)) ([259d3db](https://github.com/tkolleh/roda.lua/commit/259d3dbedff87bdd6db5bce1055c45293b7e354b))

## [1.13.6](https://github.com/tkolleh/roda.lua/compare/v1.13.5...v1.13.6) (2026-04-05)


### Bug Fixes

* **ci:** export local lux build dependencies to PATH natively ([abc8a7d](https://github.com/tkolleh/roda.lua/commit/abc8a7da34e5a2aaa23f747b6ef3882a1daa1ca1))

## [1.13.5](https://github.com/tkolleh/roda.lua/compare/v1.13.4...v1.13.5) (2026-04-05)


### Bug Fixes

* **ci:** use lx exec to resolve luastatic build dependency ([a03d119](https://github.com/tkolleh/roda.lua/commit/a03d1194e8e35b8e5717fb6c5939ef764945daba))

## [1.13.4](https://github.com/tkolleh/roda.lua/compare/v1.13.3...v1.13.4) (2026-04-05)


### Bug Fixes

* **ci:** use $GITHUB_PATH for lux bin in release workflow ([#29](https://github.com/tkolleh/roda.lua/issues/29)) ([54fe971](https://github.com/tkolleh/roda.lua/commit/54fe971ab2ad191fedf9cd6e7415fb977ea0009b))

## [1.13.3](https://github.com/tkolleh/roda.lua/compare/v1.13.2...v1.13.3) (2026-04-05)


### Bug Fixes

* **ci:** use $HOME in run step for PATH in release workflow ([#27](https://github.com/tkolleh/roda.lua/issues/27)) ([a1bb2fb](https://github.com/tkolleh/roda.lua/commit/a1bb2fb90821df787a98b604fae76f96d7045b1a))

## [1.13.2](https://github.com/tkolleh/roda.lua/compare/v1.13.1...v1.13.2) (2026-04-05)


### Bug Fixes

* **ci:** add Lux bin directory to PATH for luastatic in release workflow ([#25](https://github.com/tkolleh/roda.lua/issues/25)) ([19e5d5a](https://github.com/tkolleh/roda.lua/commit/19e5d5abb57a547590febd31d99a537b935b30ab))

## [1.13.1](https://github.com/tkolleh/roda.lua/compare/v1.13.0...v1.13.1) (2026-04-05)


### Bug Fixes

* **build:** build luv.so shared module alongside libluv.a for tests ([fe217e3](https://github.com/tkolleh/roda.lua/commit/fe217e355f97ad0f26b1bbe7bdbd881544b6bda1))
* **build:** remove luv/luasystem from lux dependencies to fix CI build ([d53b78a](https://github.com/tkolleh/roda.lua/commit/d53b78aa1b3280d9425a6c81074d1aee8be2deda))

## [1.13.0](https://github.com/tkolleh/roda.lua/compare/v1.12.1...v1.13.0) (2026-04-05)


### Features

* **17:** enhance release workflow to build and publish artifacts ([c1ac576](https://github.com/tkolleh/roda.lua/commit/c1ac5762361c5d45cbc3ba37272395fc3ac42fe8))


### Bug Fixes

* **#16:** correct path in demo record recipe ([5355de4](https://github.com/tkolleh/roda.lua/commit/5355de4018e7f8d6798a05ede1ffb2093099ecb1))
* **#16:** use bash instead of zsh for shell portability ([58fa6fc](https://github.com/tkolleh/roda.lua/commit/58fa6fcf3df5e7406a70da8b7c3ea9030be1d2f2))
* Correct demo gif ([091a76a](https://github.com/tkolleh/roda.lua/commit/091a76a12424cdd2e1c86224d82a2bb052e161f3))

## [1.12.2](https://github.com/tkolleh/roda.lua/compare/v1.12.1...v1.12.2) (2026-04-05)


### Bug Fixes

* **#16:** correct path in demo record recipe ([5355de4](https://github.com/tkolleh/roda.lua/commit/5355de4018e7f8d6798a05ede1ffb2093099ecb1))
* **#16:** use bash instead of zsh for shell portability ([58fa6fc](https://github.com/tkolleh/roda.lua/commit/58fa6fcf3df5e7406a70da8b7c3ea9030be1d2f2))

## [1.12.1](https://github.com/tkolleh/roda.lua/compare/v1.1.0...v1.12.1) (2026-04-04)


### Features

* **ansi:** add ANSI escape code utilities module ([b734c8f](https://github.com/tkolleh/roda.lua/commit/b734c8f893c7a1cdb1172c6ead438374154b01d6))
* **core:** add main roda module with Spinner class ([98d8f63](https://github.com/tkolleh/roda.lua/commit/98d8f63666fff5243e07da90a0389b83b70a1601))
* Dependencies added for building an executable ([3de1d2b](https://github.com/tkolleh/roda.lua/commit/3de1d2b58c45bb5c3bf976135f890954dace83d0))
* migrate Justfile to Lua 5.5 with argp and lx tooling ([946dc2d](https://github.com/tkolleh/roda.lua/commit/946dc2d3afcc5448111a56238eb3f5660e84312e))
* Spinner should keep spinning while process is running ([#6](https://github.com/tkolleh/roda.lua/issues/6)) ([3b27a5f](https://github.com/tkolleh/roda.lua/commit/3b27a5f0e5130dfdbb403b391579cc16b7691f37))
* **spinners:** add 16 spinner frame definitions ([5a37dbc](https://github.com/tkolleh/roda.lua/commit/5a37dbca84e34ebae5a95e1b755ea9440fc03750))
* **symbols:** add terminal state symbols module ([e996065](https://github.com/tkolleh/roda.lua/commit/e996065cc1abc7699b74306b973e9e2971bf93ca))
* Use justfile as an executable document ([58adff0](https://github.com/tkolleh/roda.lua/commit/58adff0dd70eee4ce041b610cb7f481274d6a0f6))
* vendor argp.lua as argparse replacement for Lua 5.5 ([800dcf6](https://github.com/tkolleh/roda.lua/commit/800dcf6c2dd73647e576c52688e66224d87c0b35))


### Bug Fixes

* add sudo to apt commands in CI ([11f4af1](https://github.com/tkolleh/roda.lua/commit/11f4af13aa45062be0220133c421c5987d2f68a1))
* align move_to_col_1 test expectation with actual implementation ([9317699](https://github.com/tkolleh/roda.lua/commit/9317699a2c1331d10357da02ce05d2529f3c224e))
* **argp:** replace truthy string literal with proper type comparison ([1b9987c](https://github.com/tkolleh/roda.lua/commit/1b9987ce4aa2c99c06d62d83ffcd34bebccf8632))
* Better ansi color support ([db660f4](https://github.com/tkolleh/roda.lua/commit/db660f477c5289412a0ae637796d9c227bfee403))
* **ci:** add --lua-version flag to lx upload ([4dbff9c](https://github.com/tkolleh/roda.lua/commit/4dbff9ca9059d6efba0e93f5f19595ea6a097de7))
* **ci:** format code and add luafilesystem test dependency ([81d8c1d](https://github.com/tkolleh/roda.lua/commit/81d8c1d6be1eb84e5b63c01e4a120146ff07a803))
* **ci:** pin Lux to v0.18.8 per official docs recommendation ([300fc77](https://github.com/tkolleh/roda.lua/commit/300fc77056b43aa3bc5dea7e42200d3abc26eeae))
* **ci:** simplify test matrix to Lua 5.4 and fix lint warnings ([988553f](https://github.com/tkolleh/roda.lua/commit/988553f8f3aaaadc9df7392ce744ca4e3797a7a2))
* **ci:** update Lux action to latest and fix fmt check ([93591f0](https://github.com/tkolleh/roda.lua/commit/93591f04a08399f07c1e12278d86ded4e1beee40))
* **ci:** use ubuntu-only for tests due to macOS Lux path bug ([a74c650](https://github.com/tkolleh/roda.lua/commit/a74c650e9d29443babe2429061466efce232d0e3))
* **core:** preserve false value for color option ([5aee276](https://github.com/tkolleh/roda.lua/commit/5aee276f767194a33147acd2b83b26b9697706bf))
* **demo:** add spin_for() to animate spinners ([e092b4e](https://github.com/tkolleh/roda.lua/commit/e092b4ec7f7b585b9b0b05a943faafdec0afa2e1))
* **deps:** move luafilesystem to runtime dependencies ([f9920ce](https://github.com/tkolleh/roda.lua/commit/f9920ce0fcb9c3f33cb775ebd7f41938e66e6e9e))
* extract just tarball to temp directory to avoid overwriting repository files ([cae0565](https://github.com/tkolleh/roda.lua/commit/cae056595882be3f5cdb490568e05301ca3e47f7))
* install just 1.48.1 from GitHub releases in CI ([9aa664c](https://github.com/tkolleh/roda.lua/commit/9aa664c2b9adb38b952f5d5d52f546b0ed6624b5))
* Properly handle the sub process ([23cb13a](https://github.com/tkolleh/roda.lua/commit/23cb13a14f8ad4f4dde1ae2a710f654d8a6f843c))
* **publish:** add tag field to source section ([8514e30](https://github.com/tkolleh/roda.lua/commit/8514e30b22048bea1d42670f49cefc76b4979630))
* **publish:** restore --lua-version 5.4 flag for lx upload ([31d2b72](https://github.com/tkolleh/roda.lua/commit/31d2b72cd37eb768e140b43c9bf72568ba2489d8))
* **publish:** revert to template URL and remove --lua-version flag ([6f78d90](https://github.com/tkolleh/roda.lua/commit/6f78d9047a50183b1caf75746dd46e9e0c79bc32))
* **publish:** upgrade Lux to v0.25.3 and use --lua-version 5.1 ([f4e9bdf](https://github.com/tkolleh/roda.lua/commit/f4e9bdf6113084bfcef665316ce9723c4c155e84))
* **publish:** use single-line detailed description ([4b4bbfa](https://github.com/tkolleh/roda.lua/commit/4b4bbfae42bcf7f5f838342b7107c02a3e94ca7f))
* resolve CI lint warnings and test failures ([7df5e81](https://github.com/tkolleh/roda.lua/commit/7df5e81dbbd46bfe57252df2120595728fae0ef8))
* simplify shell configuration to bash for CI compatibility ([01f087e](https://github.com/tkolleh/roda.lua/commit/01f087e04a526801cd336d3de97e25ba8febfa45))
* use bash shell in CI to avoid zsh dependency ([3526d5c](https://github.com/tkolleh/roda.lua/commit/3526d5ca1b6f1ef566146569ddeb3767f38dd512))


### Miscellaneous Chores

* bump version to 1.12.1 ([644c103](https://github.com/tkolleh/roda.lua/commit/644c1030a457bcb93efc68a2bba22150a0c576ea))

## [1.1.0](https://github.com/tkolleh/roda.lua/compare/v1.0.0...v1.1.0) (2026-04-04)


### Features

* **ansi:** add ANSI escape code utilities module ([b734c8f](https://github.com/tkolleh/roda.lua/commit/b734c8f893c7a1cdb1172c6ead438374154b01d6))
* **core:** add main roda module with Spinner class ([98d8f63](https://github.com/tkolleh/roda.lua/commit/98d8f63666fff5243e07da90a0389b83b70a1601))
* Dependencies added for building an executable ([3de1d2b](https://github.com/tkolleh/roda.lua/commit/3de1d2b58c45bb5c3bf976135f890954dace83d0))
* migrate Justfile to Lua 5.5 with argp and lx tooling ([946dc2d](https://github.com/tkolleh/roda.lua/commit/946dc2d3afcc5448111a56238eb3f5660e84312e))
* Spinner should keep spinning while process is running ([#6](https://github.com/tkolleh/roda.lua/issues/6)) ([3b27a5f](https://github.com/tkolleh/roda.lua/commit/3b27a5f0e5130dfdbb403b391579cc16b7691f37))
* **spinners:** add 16 spinner frame definitions ([5a37dbc](https://github.com/tkolleh/roda.lua/commit/5a37dbca84e34ebae5a95e1b755ea9440fc03750))
* **symbols:** add terminal state symbols module ([e996065](https://github.com/tkolleh/roda.lua/commit/e996065cc1abc7699b74306b973e9e2971bf93ca))
* Use justfile as an executable document ([58adff0](https://github.com/tkolleh/roda.lua/commit/58adff0dd70eee4ce041b610cb7f481274d6a0f6))
* vendor argp.lua as argparse replacement for Lua 5.5 ([800dcf6](https://github.com/tkolleh/roda.lua/commit/800dcf6c2dd73647e576c52688e66224d87c0b35))


### Bug Fixes

* add sudo to apt commands in CI ([11f4af1](https://github.com/tkolleh/roda.lua/commit/11f4af13aa45062be0220133c421c5987d2f68a1))
* align move_to_col_1 test expectation with actual implementation ([9317699](https://github.com/tkolleh/roda.lua/commit/9317699a2c1331d10357da02ce05d2529f3c224e))
* **argp:** replace truthy string literal with proper type comparison ([1b9987c](https://github.com/tkolleh/roda.lua/commit/1b9987ce4aa2c99c06d62d83ffcd34bebccf8632))
* Better ansi color support ([db660f4](https://github.com/tkolleh/roda.lua/commit/db660f477c5289412a0ae637796d9c227bfee403))
* **ci:** add --lua-version flag to lx upload ([4dbff9c](https://github.com/tkolleh/roda.lua/commit/4dbff9ca9059d6efba0e93f5f19595ea6a097de7))
* **ci:** format code and add luafilesystem test dependency ([81d8c1d](https://github.com/tkolleh/roda.lua/commit/81d8c1d6be1eb84e5b63c01e4a120146ff07a803))
* **ci:** pin Lux to v0.18.8 per official docs recommendation ([300fc77](https://github.com/tkolleh/roda.lua/commit/300fc77056b43aa3bc5dea7e42200d3abc26eeae))
* **ci:** simplify test matrix to Lua 5.4 and fix lint warnings ([988553f](https://github.com/tkolleh/roda.lua/commit/988553f8f3aaaadc9df7392ce744ca4e3797a7a2))
* **ci:** update Lux action to latest and fix fmt check ([93591f0](https://github.com/tkolleh/roda.lua/commit/93591f04a08399f07c1e12278d86ded4e1beee40))
* **ci:** use ubuntu-only for tests due to macOS Lux path bug ([a74c650](https://github.com/tkolleh/roda.lua/commit/a74c650e9d29443babe2429061466efce232d0e3))
* **core:** preserve false value for color option ([5aee276](https://github.com/tkolleh/roda.lua/commit/5aee276f767194a33147acd2b83b26b9697706bf))
* **demo:** add spin_for() to animate spinners ([e092b4e](https://github.com/tkolleh/roda.lua/commit/e092b4ec7f7b585b9b0b05a943faafdec0afa2e1))
* **deps:** move luafilesystem to runtime dependencies ([f9920ce](https://github.com/tkolleh/roda.lua/commit/f9920ce0fcb9c3f33cb775ebd7f41938e66e6e9e))
* extract just tarball to temp directory to avoid overwriting repository files ([cae0565](https://github.com/tkolleh/roda.lua/commit/cae056595882be3f5cdb490568e05301ca3e47f7))
* install just 1.48.1 from GitHub releases in CI ([9aa664c](https://github.com/tkolleh/roda.lua/commit/9aa664c2b9adb38b952f5d5d52f546b0ed6624b5))
* Properly handle the sub process ([23cb13a](https://github.com/tkolleh/roda.lua/commit/23cb13a14f8ad4f4dde1ae2a710f654d8a6f843c))
* **publish:** add tag field to source section ([8514e30](https://github.com/tkolleh/roda.lua/commit/8514e30b22048bea1d42670f49cefc76b4979630))
* **publish:** restore --lua-version 5.4 flag for lx upload ([31d2b72](https://github.com/tkolleh/roda.lua/commit/31d2b72cd37eb768e140b43c9bf72568ba2489d8))
* **publish:** revert to template URL and remove --lua-version flag ([6f78d90](https://github.com/tkolleh/roda.lua/commit/6f78d9047a50183b1caf75746dd46e9e0c79bc32))
* **publish:** upgrade Lux to v0.25.3 and use --lua-version 5.1 ([f4e9bdf](https://github.com/tkolleh/roda.lua/commit/f4e9bdf6113084bfcef665316ce9723c4c155e84))
* **publish:** use single-line detailed description ([4b4bbfa](https://github.com/tkolleh/roda.lua/commit/4b4bbfae42bcf7f5f838342b7107c02a3e94ca7f))
* resolve CI lint warnings and test failures ([7df5e81](https://github.com/tkolleh/roda.lua/commit/7df5e81dbbd46bfe57252df2120595728fae0ef8))
* simplify shell configuration to bash for CI compatibility ([01f087e](https://github.com/tkolleh/roda.lua/commit/01f087e04a526801cd336d3de97e25ba8febfa45))
* use bash shell in CI to avoid zsh dependency ([3526d5c](https://github.com/tkolleh/roda.lua/commit/3526d5ca1b6f1ef566146569ddeb3767f38dd512))

## 1.0.0 (2026-04-03)


### Features

* **ansi:** add ANSI escape code utilities module ([b734c8f](https://github.com/tkolleh/roda.lua/commit/b734c8f893c7a1cdb1172c6ead438374154b01d6))
* **core:** add main roda module with Spinner class ([98d8f63](https://github.com/tkolleh/roda.lua/commit/98d8f63666fff5243e07da90a0389b83b70a1601))
* Spinner should keep spinning while process is running ([#6](https://github.com/tkolleh/roda.lua/issues/6)) ([3b27a5f](https://github.com/tkolleh/roda.lua/commit/3b27a5f0e5130dfdbb403b391579cc16b7691f37))
* **spinners:** add 16 spinner frame definitions ([5a37dbc](https://github.com/tkolleh/roda.lua/commit/5a37dbca84e34ebae5a95e1b755ea9440fc03750))
* **symbols:** add terminal state symbols module ([e996065](https://github.com/tkolleh/roda.lua/commit/e996065cc1abc7699b74306b973e9e2971bf93ca))


### Bug Fixes

* **ci:** add --lua-version flag to lx upload ([4dbff9c](https://github.com/tkolleh/roda.lua/commit/4dbff9ca9059d6efba0e93f5f19595ea6a097de7))
* **ci:** format code and add luafilesystem test dependency ([81d8c1d](https://github.com/tkolleh/roda.lua/commit/81d8c1d6be1eb84e5b63c01e4a120146ff07a803))
* **ci:** pin Lux to v0.18.8 per official docs recommendation ([300fc77](https://github.com/tkolleh/roda.lua/commit/300fc77056b43aa3bc5dea7e42200d3abc26eeae))
* **ci:** simplify test matrix to Lua 5.4 and fix lint warnings ([988553f](https://github.com/tkolleh/roda.lua/commit/988553f8f3aaaadc9df7392ce744ca4e3797a7a2))
* **ci:** update Lux action to latest and fix fmt check ([93591f0](https://github.com/tkolleh/roda.lua/commit/93591f04a08399f07c1e12278d86ded4e1beee40))
* **ci:** use ubuntu-only for tests due to macOS Lux path bug ([a74c650](https://github.com/tkolleh/roda.lua/commit/a74c650e9d29443babe2429061466efce232d0e3))
* **core:** preserve false value for color option ([5aee276](https://github.com/tkolleh/roda.lua/commit/5aee276f767194a33147acd2b83b26b9697706bf))
* **demo:** add spin_for() to animate spinners ([e092b4e](https://github.com/tkolleh/roda.lua/commit/e092b4ec7f7b585b9b0b05a943faafdec0afa2e1))
* **deps:** move luafilesystem to runtime dependencies ([f9920ce](https://github.com/tkolleh/roda.lua/commit/f9920ce0fcb9c3f33cb775ebd7f41938e66e6e9e))
* **publish:** add tag field to source section ([8514e30](https://github.com/tkolleh/roda.lua/commit/8514e30b22048bea1d42670f49cefc76b4979630))
* **publish:** restore --lua-version 5.4 flag for lx upload ([31d2b72](https://github.com/tkolleh/roda.lua/commit/31d2b72cd37eb768e140b43c9bf72568ba2489d8))
* **publish:** revert to template URL and remove --lua-version flag ([6f78d90](https://github.com/tkolleh/roda.lua/commit/6f78d9047a50183b1caf75746dd46e9e0c79bc32))
* **publish:** upgrade Lux to v0.25.3 and use --lua-version 5.1 ([f4e9bdf](https://github.com/tkolleh/roda.lua/commit/f4e9bdf6113084bfcef665316ce9723c4c155e84))
* **publish:** use single-line detailed description ([4b4bbfa](https://github.com/tkolleh/roda.lua/commit/4b4bbfae42bcf7f5f838342b7107c02a3e94ca7f))

## [1.1.0](https://github.com/tkolleh/roda.lua/compare/v1.0.4...v1.1.0) (2026-03-14)


### Features

* Spinner should keep spinning while process is running ([#6](https://github.com/tkolleh/roda.lua/issues/6)) ([365c955](https://github.com/tkolleh/roda.lua/commit/365c9559709a1ba2fa67b92f4778cf2eee7473f8))

## [1.0.4](https://github.com/tkolleh/roda.lua/compare/v1.0.3...v1.0.4) (2026-03-02)


### Bug Fixes

* **demo:** add spin_for() to animate spinners ([2cc6fef](https://github.com/tkolleh/roda.lua/commit/2cc6fefd9ef4bb15de0a54827750ceb6a4e7c4dc))

## [1.0.3](https://github.com/tkolleh/roda.lua/compare/v1.0.2...v1.0.3) (2026-03-02)


### Bug Fixes

* **publish:** use single-line detailed description ([dfcea81](https://github.com/tkolleh/roda.lua/commit/dfcea81df00b70cd0a109ceb3c1cc61de68676ae))

## [1.0.2](https://github.com/tkolleh/roda.lua/compare/v1.0.1...v1.0.2) (2026-03-02)


### Bug Fixes

* **publish:** upgrade Lux to v0.25.3 and use --lua-version 5.1 ([01e94d1](https://github.com/tkolleh/roda.lua/commit/01e94d14e287e3ff11834d0eb11e40909f728d3a))
* **publish:** use single-line detailed description ([dfcea81](https://github.com/tkolleh/roda.lua/commit/dfcea81df00b70cd0a109ceb3c1cc61de68676ae))

## [1.0.1](https://github.com/tkolleh/roda.lua/compare/v1.0.0...v1.0.1) (2026-03-02)


### Bug Fixes

* **ci:** add --lua-version flag to lx upload ([51b388a](https://github.com/tkolleh/roda.lua/commit/51b388affeb95c6fcfef04198614fa6d058cde42))
* **publish:** add tag field to source section ([79261a7](https://github.com/tkolleh/roda.lua/commit/79261a7b304d44e8dbe2c7bb50f705486151fa83))
* **publish:** restore --lua-version 5.4 flag for lx upload ([0080da5](https://github.com/tkolleh/roda.lua/commit/0080da50530ed06f74eda8923cb1dbb46ed0c4ea))
* **publish:** revert to template URL and remove --lua-version flag ([a8eb448](https://github.com/tkolleh/roda.lua/commit/a8eb448a57758e4be07a441878e3085f81f429a9))
* **publish:** upgrade Lux to v0.25.3 and use --lua-version 5.1 ([01e94d1](https://github.com/tkolleh/roda.lua/commit/01e94d14e287e3ff11834d0eb11e40909f728d3a))
* **publish:** use single-line detailed description ([dfcea81](https://github.com/tkolleh/roda.lua/commit/dfcea81df00b70cd0a109ceb3c1cc61de68676ae))

## 1.0.0 (2026-03-02)


### Features

* **ansi:** add ANSI escape code utilities module ([91881e2](https://github.com/tkolleh/roda.lua/commit/91881e2091f4ffa5edc192f0d47d5f7badeefc75))
* **core:** add main roda module with Spinner class ([0d9d151](https://github.com/tkolleh/roda.lua/commit/0d9d151a100d357540300e7b161257ba39f79a0d))
* **spinners:** add 16 spinner frame definitions ([97c18d6](https://github.com/tkolleh/roda.lua/commit/97c18d6eaac7579664279d758f43e1cdb343f6cc))
* **symbols:** add terminal state symbols module ([1eb5986](https://github.com/tkolleh/roda.lua/commit/1eb5986c12ce86e3892e2eb9eb789e5179555879))


### Bug Fixes

* **ci:** format code and add luafilesystem test dependency ([9e4fbd4](https://github.com/tkolleh/roda.lua/commit/9e4fbd46bce4809cd771b4d39063435c4ae05f46))
* **ci:** pin Lux to v0.18.8 per official docs recommendation ([69ebdd2](https://github.com/tkolleh/roda.lua/commit/69ebdd2ab93d5f65f5ad1f3162224e87460c52bb))
* **ci:** simplify test matrix to Lua 5.4 and fix lint warnings ([b091821](https://github.com/tkolleh/roda.lua/commit/b091821f809db746bbbd0a28e242e7f5f027027f))
* **ci:** update Lux action to latest and fix fmt check ([137be7f](https://github.com/tkolleh/roda.lua/commit/137be7fd15f5077753cc2563bf812a2af09e47e8))
* **ci:** use ubuntu-only for tests due to macOS Lux path bug ([7fcaf53](https://github.com/tkolleh/roda.lua/commit/7fcaf531f74235d150238918da89de6fc09def4d))
* **core:** preserve false value for color option ([76f1f23](https://github.com/tkolleh/roda.lua/commit/76f1f231ee94438a5a0e757e33aea74798776893))
* **deps:** move luafilesystem to runtime dependencies ([b849ee8](https://github.com/tkolleh/roda.lua/commit/b849ee856463a18b18bf435a4d1f15253045ca72))
