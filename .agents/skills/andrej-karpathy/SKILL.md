---
name: andrej-karpathy
description: >-
  Andrej Karpathy's 4 Coding Laws for AI coding agents and first-principles engineering:
  Think Before Coding, Simplicity First, Surgical Changes, and Goal-Driven Verification.
  Use on coding, refactoring, architecture, and debugging tasks.
---

# Andrej Karpathy — 4 Coding Laws & First-Principles Engineering

Apply these four operational laws on every non-trivial implementation, refactor, or bug fix to prevent silent assumptions, speculative bloat, collateral edits, and unverified changes.

---

## Law 1: Think Before Coding
Don't assume. Don't hide confusion. Surface trade-offs before writing code.
- **State assumptions explicitly**: If a requirement has two plausible interpretations, stop and present both concisely (with a recommended default) rather than picking one silently.
- **Push back when warranted**: If a requested pattern contradicts an architectural invariant or creates an unnecessary bug risk, name the simpler or safer alternative clearly.
- **Check existing reality first**: Trace real types, callers, and contracts (`codebase-memory-mcp`) before assuming how a module behaves.

## Law 2: Simplicity First
Write the minimum code that solves the exact problem—nothing speculative.
- **Zero premature abstractions**: Do not invent helper factories, configuration flags, wrappers, or single-use abstractions for hypothetical future requirements.
- **Reuse before inventing**: Use existing repo helpers, standard library primitives, and already-installed packages first.
- **Compress complexity**: If a 200-line patch can be expressed cleanly in 40 lines without hurting readability, rewrite it down to the essence.

## Law 3: Surgical Changes
Touch ONLY what the task strictly asks you to change.
- **Respect adjacent code**: Never reformat, rename, reorder imports, or "improve" unrelated lines in files you touch.
- **Match local style**: Follow the surrounding module's conventions even if you'd personally format it differently.
- **Clean only your own mess**: Remove unused imports, variables, or helpers created by *your* diff—leave pre-existing dead code untouched unless asked to clean it up.

## Law 4: Goal-Driven Verification & First-Principles Inspection
Transform vague tasks into measurable, verifiable criteria and inspect real state before guessing.
- **Define the check up front**:
  - Adding validation/logic $\to$ write a failing test or assertion first, then make it pass.
  - Fixing a bug $\to$ write a test or reproduction check that fails on the bug, fix root cause, confirm pass.
  - Refactoring $\to$ run existing tests/builds before and after to prove zero behavior regression.
- **Inspect real data/shapes first**: When debugging ("why is X failing?"), inspect the exact payload, SQL schema, or state transitions from first principles before proposing fixes.
- **End with proof**: Run the stack's verification gate (`go build ./... && go test ./...` or `npx tsc --noEmit && npm run build`) and report only directly observed outcomes.
