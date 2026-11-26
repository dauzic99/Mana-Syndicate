---
name: egm-workflow
description: Elephant-Goldfish Model (EGM) spec-driven development workflow for Mana-Syndicate. Separates context-rich design (Elephant) from zero-history fresh-eyes critique (Goldfish) before writing Godot code.
---

# Elephant-Goldfish Model (EGM) Workflow

Adapted from Google's **Elephant-Goldfish Model (`google/elephant-goldfish-model` / `antigravity-plugins-official/plugin/egm`)** for `Mana-Syndicate` (Godot 4.x 2.5D).

> **Core Principle**: *Design is the new code.* Long chat sessions accumulate blind spots and unstated assumptions. Never jump straight from a prompt or PRD into writing 10 `.gd` files.

## 1. The Split-Brain Roles

| Role | Context | Responsibility | Output |
| :--- | :--- | :--- | :--- |
| **Elephant** | Full project history, PRD, vault, and design decisions | Brainstorm, surface trade-offs, draft rigorous specs | `concepts_brief.md` -> `design_draft.md` |
| **Goldfish** | **ZERO conversation history** (fresh stateless subagent) | Audit the spec cold against repo files & subtree contracts | Flat deficiency & risk report |
| **Human + Elephant** | Design draft + Goldfish report | Resolve trade-offs (1 question + `(Recommended)` default) | `design_approved.md` -> Code |

## 2. Four-Stage Execution Protocol

### Stage 1: Brainstorm (`egm-brainstorm`)
- Discuss the PRD feature or system in the main Elephant session.
- Use `grill-me` (1 high-leverage question at a time + `(Recommended)` default) to resolve ambiguities.
- Output `docs/designs/<feature>/concepts_brief.md` using the template in `docs/designs/README.md`.
- **Zero game code is written in Stage 1.**

### Stage 2: Draft (`egm-draft`)
- Translate `concepts_brief.md` into `docs/designs/<feature>/design_draft.md` covering:
  1. **Domain Model & `GLOSSARY.md` terms**
  2. **Pure-Core Simulation (`scripts/domain/`)** — `RefCounted` / `Resource` classes & invariants
  3. **Scene Tree & 2.5D Presentation** — Node hierarchy, axis lock, `Sprite3D`/`SubViewport` rules
  4. **Signals & Subtree Contracts** — Exact signal signatures, callers, and side effects
  5. **Failure Modes & Edge Cases** — Freed nodes, physics callbacks, invalid state transitions
  6. **GUT Verification Plan** — Concrete headless unit tests in `tests/`

### Stage 3: Cold Goldfish Review (`egm-review` / `egm-review-loop`)
- **If the official `egm` plugin is installed**, invoke its `egm-review` / `egm-review-loop` flow.
- **Otherwise (Antigravity native fallback)**: Spawn an isolated `research` subagent via `invoke_subagent` with:
  - **ZERO** brainstorming summary or persuasive framing.
  - **ONLY** the path to `docs/designs/<feature>/design_draft.md`, `docs/GLOSSARY.md`, `GOLDEN_STANDARD.md`, and relevant subtree `README.md` files.
  - Explicit prompt: *"You are a Goldfish reviewer with zero prior context. Audit this Godot 4 2.5D design draft cold. List every unstated assumption, Godot lifecycle trap, 2.5D coordinate/sorting risk, missing invariant, or untestable coupling. Do not flatter; output a flat numbered deficiency report."*

### Stage 4: Resolve & Implement (`egm-resolve`)
- Ingest the Goldfish report in the Elephant session.
- Fix clear spec gaps directly; escalate genuine design trade-offs to the user (1 decision at a time + `(Recommended)`).
- Save `docs/designs/<feature>/design_approved.md` (or mark `design_draft.md` `Status: Approved`), then implement in small TDD vertical slices verified by `./scripts/verify-godot.sh`.

## 3. Subtree Contract Rule (`egm-bootstrap`)
Every major code subtree (`scripts/domain/`, `scripts/components/`, `scripts/entities/`, `scripts/systems/`, `scripts/ui/`) MUST contain a concise `README.md` with three sections:
1. **Interfaces** — Public `class_name`s, methods, signals, and `Resource` schemas.
2. **Invariants** — Rules that must always hold (e.g., mana >= 0, pure-core has no `SceneTree` dependency).
3. **Side Effects** — Mutated autoloads, disk writes, signal emissions, or scene-tree mutations.
