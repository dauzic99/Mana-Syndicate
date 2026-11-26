# EGM Design Registry (`docs/designs/`)

All non-trivial features and PRD milestones follow the **Elephant-Goldfish Model (EGM)** before implementation (`.agents/skills/egm-workflow/SKILL.md`).

## Active Design Specs
*None yet — awaiting PRD in `docs/prd/`.*

---

## Template 1: `docs/designs/<feature>/concepts_brief.md` (Elephant Brainstorm)
```markdown
# <Feature Name> — Concepts Brief
- **Status**: Draft | Reviewed
- **PRD Reference**: `<section>`
- **Goal**: <1-2 sentences>
- **Non-Goals**: <what is explicitly out of scope>
- **Key Constraints**: <2.5D axis, performance, pure-core testability>
- **Open Questions**: <resolved via /grill-me>
```

## Template 2: `docs/designs/<feature>/design_draft.md` (Elephant Spec)
```markdown
# <Feature Name> — Design Spec
- **Status**: Draft | In Goldfish Review | Approved

## 1. Domain Terms & Invariants
(Reference `docs/GLOSSARY.md`)

## 2. Pure-Core Simulation (`scripts/domain/`)
- Classes (`RefCounted` / `Resource`), public methods, exact types, zero `SceneTree` deps.

## 3. Scene Tree & 2.5D Presentation
- Exact node hierarchy (`CharacterBody3D`, `Sprite3D`, `SubViewport` update mode, `alpha_cut`, collision layers).

## 4. Signals & Subtree Contracts
- Exact signal signatures (`signal_name(arg: Type)`), emitters, and listeners.

## 5. Failure Modes & Edge Cases
- Freed-node guards, invalid inputs, physics callback deferrals.

## 6. GUT Verification Plan
- Exact test cases in `tests/test_<feature>.gd`.
```

## Template 3: Subtree Contract (`scripts/<subsystem>/README.md`)
```markdown
# <Subsystem Name>
## Interfaces
## Invariants
## Side Effects
```
