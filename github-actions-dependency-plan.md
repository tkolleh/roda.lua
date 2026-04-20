# GitHub Actions Dependency Plan: Tests → Release Please → Publish

## Project Context
**Repository:** roda.lua (pure Lua terminal spinner library and CLI)
**Location:** `/Users/tkolleh/ws/roda.lua/main.dependabot`
**Key Files:** `.github/workflows/tests.yml`, `.github/workflows/release-please.yml`, `.github/workflows/publish.yml`

## Current State Analysis (Pre-Implementation)

### Current Workflows
1. **Tests** (`tests.yml`):
   - Triggers: `pull_request`, `push` to `main`
   - Jobs: `test` (Lua 5.4), `lint` (formatting & linting)
   - No downstream dependencies

2. **Release Please** (`release-please.yml`):
   - Triggers: `push` to `main` (with paths-ignore), `workflow_dispatch`
   - Creates releases and tags based on conventional commits
   - No dependency on Tests workflow

3. **Publish to LuaRocks** (`publish.yml`):
   - Triggers: `push` to tags `v*.*.*`, `workflow_dispatch`
   - No dependency on Tests or Release Please workflows

### Current Problem
- Release Please runs BEFORE Tests completes (race condition)
- Publish runs on ANY tag push, even if tests failed
- No guarantee that released code passed tests

## Goal
Establish strict dependency chain:
```
Tests → Release Please → Publish to LuaRocks
```

Where:
1. **Tests must pass** before Release Please runs
2. **Release Please must create the tag** (automated release) before Publish runs
3. **Commit must be on main branch** (prevents publishing from feature branches)

## Implementation Plan

### Task 1: No changes to `tests.yml`
**Purpose:** Eliminated. The `workflow_run` pattern on the downstream workflow (Release Please) watches for Tests completion — no changes needed to the upstream Tests workflow.

**Decision:** Removed `workflow_call` trigger from the plan. Using `workflow_run` (event-based) instead of `workflow_call` (reusable). The `workflow_run` trigger on Release Please references Tests by name and requires no modification to Tests.

### Task 2: Update `release-please.yml`
**Purpose:** Make Release Please dependent on Tests success, with path filtering re-implemented as a job step.

**Changes:**
1. Replace `push` + `paths-ignore` trigger with `workflow_run` from Tests
2. Add `if` condition requiring Tests success (or manual dispatch)
3. Add checkout step (with `fetch-depth: 2` and `ref` pointing to the triggering SHA)
4. Add `check_changes` step to re-implement `paths-ignore` filtering via `git diff`
5. Make Release Please step conditional on `check_changes` not skipping
6. Keep `workflow_dispatch` for emergency use

**Full updated trigger and job:**
```yaml
on:
  workflow_run:
    workflows: ["Tests"]
    types: [completed]
    branches: [main]
  workflow_dispatch:

jobs:
  release-please:
    name: Release Please
    runs-on: ubuntu-24.04
    if: ${{ github.event.workflow_run.conclusion == 'success' || github.event_name == 'workflow_dispatch' }}
    outputs:
      release_created: ${{ steps.release.outputs.release_created }}
      tag_name: ${{ steps.release.outputs.tag_name }}
    steps:
      - name: Checkout repository
        uses: actions/checkout@de0fac2e4500dabe0009e67214ff5f5447ce83dd # v6.0.2
        with:
          ref: ${{ github.event.workflow_run.head_sha || github.sha }}
          fetch-depth: 2

      - name: Check for relevant changes
        id: check_changes
        if: github.event_name == 'workflow_run'
        run: |
          CHANGED=$(git diff --name-only HEAD^1 HEAD 2>/dev/null || ...)
          # Filters out: *.md, assets/, demo/, spec/, .gitignore, .luacheckrc, lefthook.yml
          # Sets skip_release=true if only irrelevant files changed

      - name: Release Please
        if: ${{ !env.ACT && steps.check_changes.outputs.skip_release != 'true' }}
        uses: googleapis/release-please-action@...
        id: release
        with:
          token: ${{ secrets.PAT }}
```

**Location:** `.github/workflows/release-please.yml`

### Task 3: Update `publish.yml` - Add verification chain
**Purpose:** Ensure only tags created by Release Please (after Tests pass) can be published.

**Changes:**
1. Keep existing `push: tags: v*.*.*` and `workflow_dispatch` triggers (no `workflow_run`)
2. Add `permissions: contents: read, actions: read` for GitHub API calls
3. Add `verify-chain` job (skipped on `workflow_dispatch`) with 2 checks:
   - Commit is on main branch
   - Release was created by Release Please (GitHub Release exists for the tag)
4. Add condition to publish job requiring verify-chain success (or dispatch)

**Full updated workflow:**
```yaml
on:
  push:
    tags:
      - "v*.*.*"
  workflow_dispatch:

permissions:
  contents: read
  actions: read

jobs:
  verify-chain:
    runs-on: ubuntu-24.04
    if: github.event_name != 'workflow_dispatch'
    steps:
      - name: Check commit is on main branch
        uses: actions/github-script@60bee431bba7e65b608b8aa309be0eb0252f5e79 # v7.0.1
        with:
          script: |
            const { data: branches } = await github.rest.repos.listBranchesForHeadCommit({...});
            const isOnMain = branches.some(b => b.name === 'main');
            if (!isOnMain) { core.setFailed(...); return; }

      - name: Verify Release Please created this tag
        uses: actions/github-script@60bee431bba7e65b608b8aa309be0eb0252f5e79 # v7.0.1
        with:
          script: |
            // Checks that a GitHub Release exists for the tag
            // Only Release Please creates releases, so this blocks manual tags

  publish:
    needs: verify-chain
    if: |
      always() &&
      (needs.verify-chain.result == 'success' || github.event_name == 'workflow_dispatch')
    runs-on: ubuntu-24.04
    environment: luarocks-publish
    # ... rest of existing steps unchanged
```

**Location:** `.github/workflows/publish.yml`

## Workflow Dependency Graph (Post-Implementation)

```
PUSH to main
    │
    ▼
┌─────────────────────────┐
│    Tests Workflow       │
│  ├─ test job            │
│  └─ lint job            │
│  (both must pass)       │
└──────────┬──────────────┘
           │ workflow_run (completed + success)
           ▼
┌─────────────────────────────────────────┐
│  Release Please Workflow                │
│  (only if Tests concluded 'success')    │
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ check_changes (path filter)         ││
│  │ ├─ Skips if only doc/test changes   ││
│  └─ Only runs on workflow_run trigger   ││
│              │                          │
│              ▼                          │
│  ┌─────────────────────────────────────┐│
│  │ release-please-action               ││
│  │ (only if relevant changes detected)  ││
│  └─────────────────────────────────────┘│
│              │                          │
│              ▼ creates tag v*            │
│  ┌─────────────────────────────────────┐│
│  │ build-release (5 platforms)         ││
│  │ (only if release_created)           ││
│  └─────────────────────────────────────┘│
└──────────┬──────────────────────────────┘
           │ creates tag v*
           ▼
┌─────────────────────────┐
│  TAG PUSH (v*.*.*)      │
└──────────┬──────────────┘
           │
           ▼
┌─────────────────────────────────────────┐
│  Publish to LuaRocks Workflow           │
│                                         │
│  ┌─────────────────────────────────────┐│
│  │ verify-chain job (tag push only)    ││
│  │ ├─ ✓ Commit on main?               ││
│  │ └─ ✓ Release from Release Please?  ││
│  └─────────────────────────────────────┘│
│              │                          │
│              ▼ needs: verify-chain      │
│  ┌─────────────────────────────────────┐│
│  │ publish job                         ││
│  │ (upload to LuaRocks)                ││
│  └─────────────────────────────────────┘│
└─────────────────────────────────────────┘
```

## Verification Scenarios

| Scenario | Outcome |
|----------|---------|
| Normal release path | ✅ Tests → Release Please → Tag → Verify → Publish |
| Tests fail on main | ❌ Release Please blocked (workflow_run conclusion check) |
| Doc/test-only push to main | ❌ Release Please runs but `check_changes` skips (path filter) |
| Manual tag on feature branch | ❌ Publish blocked (commit not on main) |
| Manual tag on main without Release Please | ❌ Publish blocked (no GitHub Release for tag) |
| Manual dispatch of Release Please | ✅ Runs release-please-action (no path filter, no Tests dependency) |
| Manual dispatch of Publish | ✅ Bypasses all checks (emergency use) |

## Implementation Notes

### GitHub Actions Best Practices Used
1. **`workflow_run` for cross-workflow dependencies** — Release Please watches Tests completion; no changes needed to Tests
2. **Path filtering as a job step** — Re-implements `paths-ignore` using git diff in the Release Please workflow
3. **Pinned action versions** — All actions use SHA pins
4. **Minimal permissions** — Publish workflow has `contents: read, actions: read`
5. **Conditional execution** — Uses `if:` conditions to prevent unnecessary runs
6. **Preserves manual triggers** — Keeps `workflow_dispatch` for emergency use
7. **Idempotent design** — `workflow_run` only triggers on `completed` status
8. **No duplicate triggers** — Publish uses tag push only (no `workflow_run`), eliminating deduplication concerns

### Design Decisions (from grilling session)
1. **`workflow_run` only** — Removed `workflow_call` from tests.yml; not needed for `workflow_run`
2. **Path filtering re-implemented in job** — `git diff` step in release-please replaces `paths-ignore`
3. **No Tests-passed check in verify-chain** — Redundant since Release Please already requires Tests success
4. **Tag push only for publish** — Removed `workflow_run` trigger from publish.yml to avoid duplicate runs
5. **Strict tag blocking** — Manual tags without Release Please releases are rejected
6. **verify-chain skipped on dispatch** — Entire job skipped via `if: github.event_name != 'workflow_dispatch'`

### Performance Considerations
- `check_changes` step adds ~5s for git diff on release-please workflow
- `verify-chain` job makes 2 GitHub API calls (~1s delay) on publish workflow
- Release Please runs on every successful Tests run, but `check_changes` skips doc/test-only changes (~10s total overhead)
- No `workflow_run` overhead on publish — triggered only by tag push

### Security Considerations
- `workflow_run` runs in base repository context with elevated permissions
- Already appropriate for Release Please (needs write permissions)
- Publish uses environment secrets (`LUX_API_KEY`) with required reviewers
- No `workflow_dispatch` bypass for verify-chain — only publish job can be dispatched manually

### Edge Cases Handled
1. **Tagged branches**: Manual tags on feature branches blocked (commit not on main)
2. **Direct tag pushes**: Without Release Please release, blocked (no GitHub Release)
3. **Manual overrides**: `workflow_dispatch` bypasses all checks
4. **Doc/test-only pushes**: `check_changes` step skips Release Please
5. **workflow_dispatch for Release Please**: Runs without Tests dependency or path filter

## Pre-Implementation Validation
1. Run `just check` to ensure linting and formatting pass
2. Run `just test-unit` to ensure existing tests pass
3. Review file changes for YAML syntax correctness

## Post-Implementation Testing
1. Push a commit to main to verify Tests → Release Please chain
2. Create a manual tag to verify Publish blocking
3. Use `workflow_dispatch` to test manual override

## Files to Modify
1. `.github/workflows/release-please.yml` — Switch to `workflow_run`, add path filtering, add success condition
2. `.github/workflows/publish.yml` — Add `verify-chain` job with commit-on-main + RP-release checks, add permissions

## Task Checklist
- [x] ~~Update `tests.yml` with `workflow_call` trigger~~ (Eliminated — not needed)
- [x] Update `release-please.yml` with `workflow_run` trigger, success condition, and path filtering
- [x] Update `publish.yml` with `verify-chain` job (commit-on-main + RP release check only)
- [ ] Run `just check` to validate changes
- [ ] Run `just test-unit` to ensure no regressions
- [ ] Commit changes with appropriate message

## Created
**Date:** 2026-04-19 19:17 UTC  
**Author:** Agent (Staff Software Engineer)  
**Context:** User requested strict dependency chain for GitHub Actions workflows

---
*This plan can be implemented by any agent with knowledge of GitHub Actions and YAML.*