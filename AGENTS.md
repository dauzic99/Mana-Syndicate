# Mana-Syndicate — Agent Entry Manual

Read [GOLDEN_STANDARD.md](./GOLDEN_STANDARD.md), [.agents/vault/INDEX.md](./.agents/vault/INDEX.md), [Production Roadmap & Checklists](./.agents/vault/02-Workflows/game-dev-production-roadmap.md), [.agents/memory/GRAPH_SUMMARY.md](./.agents/memory/GRAPH_SUMMARY.md), and [docs/designs/README.md](./docs/designs/README.md) before modifying code or designing a system.

## 1. Project Identity & Stack
- **Project**: `Mana-Syndicate` (Godot 4.x 2.5D)
- **Language & Testing**: Strictly Typed GDScript (`class_name`, explicit types) + **GUT** (Godot Unit Test) + `gdtoolkit` (`gdlint` / `gdformat`)
- **Design Workflow**: **Elephant-Goldfish Model (EGM)** — Brainstorm (`concepts_brief.md`) -> Draft (`design_draft.md`) -> Cold Goldfish Review -> Resolve -> TDD Implementation
- **Current Status**: Pre-PRD Golden Workspace Bootstrapped (awaiting PRD in `docs/prd/`)

## 2. Core Commands
- `./scripts/verify-godot.sh` — Run all active verification gates (workspace integrity, Godot 3 anti-bug static scan, `gdformat --check`, `gdlint`, `godot --headless --quit`, headless GUT)
- `godot --headless --path . --quit` — Verify project & GDScript compilation headlessly
- `godot --headless --path . -s addons/gut/gut_cmdl.gd -gdir=res://tests -gexit` — Run isolated GUT suite
- `gdformat --check scripts/ && gdlint scripts/` — Check GDScript formatting and lint rules

## 3. PRD-to-Code EGM Workflow
1. Drop the PRD into `docs/prd/` and lock domain terms in `docs/GLOSSARY.md`.
2. **Elephant**: Create `docs/designs/<feature>/concepts_brief.md` and `design_draft.md` (zero game code yet).
3. **Goldfish**: Run cold zero-history review (`egm` plugin or isolated `research` subagent) to expose edge cases and unstated assumptions.
4. **Resolve & Build**: Lock `design_approved.md`, then implement in small TDD vertical slices (`tests/` -> `scripts/domain/` -> `scenes/`) and verify via `./scripts/verify-godot.sh`.

## 4. Non-Negotiable Godot 4.x 2.5D Rules
1. **No Godot 3 Syntax**: Use `@export`, `@onready`, `await`, `sig.emit()`, `sig.connect()`, `velocity = ...; move_and_slide()`.
2. **Strict Typing & 300-Line Ceiling**: Every `.gd` script uses explicit types, `as` casts, and stays under 250-300 lines.
3. **Pure-Core First**: Keep mana/combat/syndicate math in pure `RefCounted` / `Resource` classes under `scripts/domain/` so GUT runs without booting viewports.
4. **Scene Safety & `.uid` Retention**: Never hand-corrupt complex `.tscn` blocks; always commit `*.uid` and `*.import` files.
5. **2.5D Visual Decoupling**: Separate `CharacterBody3D` physics from `Sprite3D`/`SubViewport` visuals; throttle `SubViewport` updates (`UPDATE_WHEN_VISIBLE`).
6. **Lifecycle Guards**: Call down, signal up; guard `await` with `is_instance_valid()`; defer physics-callback mutations.
7. **Subtree Contracts**: Every major `scripts/*/` folder maintains a 3-section `README.md` (`Interfaces`, `Invariants`, `Side Effects`).

<!-- antislop:start -->
## antislop
For UI, copy, people, or code comments work, read `.agents/skills/antislop/SKILL.md` (core) and then the skill for the task:
- UI / visual: `.agents/skills/antislop-ui/SKILL.md`
- Copy & text: `.agents/skills/antislop-copywriting/SKILL.md`
- People / accessibility: `.agents/skills/antislop-human/SKILL.md`
- Code comments: `.agents/skills/antislop-code/SKILL.md`
<!-- antislop:end -->
