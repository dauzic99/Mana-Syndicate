# EGM PRD-to-Code Playbook

Follow this exact sequence when the user drops the PRD for `Mana-Syndicate`.

## Phase 0: PRD Ingestion & Technical Lock
1. Save or read the PRD in `docs/prd/`.
2. Resolve the 5 open 2.5D technical questions listed in [docs/prd/README.md](../../../docs/prd/README.md) using `/grill-me` (1 question at a time + `(Recommended)` default).
3. Populate `docs/GLOSSARY.md` with canonical domain terms (Mana, Syndicate, Unit, Turn/Phase, etc.).

## Phase 1: Elephant — Brainstorm & Draft (Zero Game Code)
1. Break the PRD into vertical-slice milestones (e.g., `01-core-movement-camera`, `02-mana-economy`, `03-combat-loop`).
2. For each milestone, draft:
   - `docs/designs/<slug>/concepts_brief.md` (intent, scope, non-goals, key constraints)
   - `docs/designs/<slug>/design_draft.md` (pure-core classes, scene trees, signals, 2.5D coordinates, failure modes, GUT test list)
3. **Hard Rule**: Do not write `.gd` or `.tscn` files during Phase 1.

## Phase 2: Goldfish — Cold Zero-History Review
1. Run `egm-review` (official plugin) OR spawn a fresh isolated `research` subagent via `invoke_subagent` with **no brainstorming summary**.
2. Pass only `design_draft.md`, `docs/GLOSSARY.md`, `GOLDEN_STANDARD.md`, and relevant subtree `README.md` files.
3. Collect the flat deficiency report (missing edge cases, freed-node races, 2.5D sorting/billboard traps, untestable coupling).

## Phase 3: Resolve & Gate
1. Update `design_draft.md` to fix clear gaps.
2. Present any remaining architectural trade-offs to the user (1 question + `(Recommended)`).
3. Save `docs/designs/<slug>/design_approved.md` (or mark `Status: Approved`).

## Phase 4: Vertical-Slice TDD & Verification
1. Write failing GUT tests first in `tests/test_<slug>.gd`.
2. Implement the minimal typed GDScript in `scripts/domain/` and `scripts/components/` / `scripts/entities/` (under 250-300 lines/file).
3. Update the subtree `README.md` (`Interfaces / Invariants / Side Effects`).
4. Run `./scripts/verify-godot.sh` and fix all warnings/errors.
5. Run a 2-axis `code-review` (Standards + Spec) and persist milestone state via `claude-mem` `work_state_write`.
