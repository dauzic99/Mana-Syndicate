# Mana-Syndicate — The Golden Standard Operational Manual

> **Portability Guarantee**: This document establishes the immutable Golden Standard for `Mana-Syndicate` (Godot 4.x 2.5D / Typed GDScript / GUT / `gdtoolkit` / Elephant-Goldfish Model). When this repository is cloned or opened on any machine, this manual governs every design spec, scene, and code change.

---

## 1. Pre-Flight Autonomous Router & Execution Contract

Before planning or editing any code, measure blast radius via `codebase-memory-mcp` and open every response or plan with:
```markdown
> [AUTO-ROUTER] Blast Radius: X files | Mode: <Fast-Path | Normal | /grill-me | /swarm | /boost | /teamwork> | Active Skills: <list>
```

| Scale & Shape | Mode | Execution Path |
| :--- | :--- | :--- |
| **<= 1 file** (tuning `@export`, typo, localized fix) | **Fast-Path** | 1 AST check via `codebase-memory-mcp` -> surgical diff (Karpathy Law 3) -> `./scripts/verify-godot.sh`. |
| **2-3 files** (single component, `Resource` schema, small UI panel) | **Normal** | Full AST trace -> Ponytail 5-Rung Ladder -> GUT test in `tests/` -> `./scripts/verify-godot.sh`. |
| **Ambiguous gameplay, 2.5D camera, or architectural choice** | **`/grill-me`** | Pause before coding; resolve 1 high-leverage decision at a time with `(Recommended)` first. |
| **>= 4 independent files/layers** (Domain + Scene + UI + Tests) | **`/swarm`** | Partition into non-overlapping tracks (`@domain`, `@scenes`, `@verifier`). |
| **Hard/deep bug** (physics jitter, Z-sorting glitch, freed-node race) | **`/boost`** | Enforce `diagnosing-bugs` loop (`reproduce -> isolate -> diagnose -> fix -> regression-test`). |
| **New gameplay system or PRD milestone (>10 files)** | **`/teamwork` + EGM** | Run **Elephant-Goldfish Model (EGM)** spec + cold review gate before writing `.gd` or `.tscn` files. |

---

## 2. Elephant-Goldfish Model (EGM) Spec-Driven Protocol

For any new gameplay system, PRD milestone, or cross-cutting refactor, follow `.agents/skills/egm-workflow/SKILL.md`:

1. **Elephant (Brainstorm & Draft — Zero Code)**:
   - Clarify intent via `grill-me` and capture `docs/designs/<feature>/concepts_brief.md`.
   - Draft `docs/designs/<feature>/design_draft.md` specifying pure-core `RefCounted`/`Resource` classes, scene trees, signals, 2.5D coordinate/sorting rules, failure modes, and GUT tests.
2. **Goldfish (Zero-History Cold Review)**:
   - Invoke the official `egm` plugin (`egm-review` / `egm-review-loop`) OR spawn a fresh isolated `research` subagent with **zero conversational history**—passing only `design_draft.md`, `docs/GLOSSARY.md`, `GOLDEN_STANDARD.md`, and relevant subtree `README.md` files.
   - Goldfish outputs a flat deficiency report probing edge cases, unstated assumptions, and Godot lifecycle traps.
3. **Resolve & Gate**:
   - Elephant resolves gaps, escalates genuine trade-offs (1 question + `(Recommended)`), locks `design_approved.md`, and **only then** begins TDD implementation.
4. **Subtree Contracts (`egm-bootstrap`)**:
   - Maintain a concise `README.md` in each major subsystem folder (`scripts/domain/`, `scripts/components/`, `scripts/entities/`, `scripts/systems/`, `scripts/ui/`) with exactly 3 sections: **Interfaces**, **Invariants**, and **Side Effects**.

---

## 3. Strict 5-Layer Tool Chain

Execute tools in this exact order before modifying any file:
1. **`claude-mem`**: Track multi-step milestones via `work_state_write` / `work_state_read` and search past decisions with `mem_search`.
2. **`codebase-memory-mcp`**: Run `detect_changes` -> `search_graph` / `trace_path` / `get_code_snippet` before reading full `.gd` files. Pass `StartLine` and `EndLine` to `read_file`.
3. **Project Vault (`.agents/vault/INDEX.md`)**: Read `INDEX.md` and open only the exact blueprint, playbook, or shield note needed.
4. **`context7`**: Query versioned Godot 4.x / GUT docs (`resolve-library-id` -> `query-docs`) before writing unfamiliar engine APIs. Never guess Godot 4 signatures from memory.
5. **Fallback Search**: Use grep/find only for `.tscn`, `.tres`, `project.godot`, Markdown docs, or exact string literals.

---

## 4. Mandatory Godot 4.x 2.5D AI Anti-Bug Shields

1. **Scene-vs-Script Boundary & `.uid` Shield**:
   - Never blindly hand-rewrite complex `.tscn` `ext_resource` / `sub_resource` blocks. Keep logic in typed `.gd` scripts and data in custom `.tres` `Resource` files; provide exact Inspector/Scene-dock steps when node trees change.
   - **Godot 4.4+ `.uid` Rule**: Never delete or `.gitignore` `*.uid` or `*.import` files.
2. **Godot 4.x Syntax Purity Shield**:
   - Strictly forbid Godot 3.x patterns (`yield()`, `export()`, `onready var`, `.instance()`, `move_and_slide(vel)`, `connect("sig", ...)`, `emit_signal("sig")`).
   - Always use Godot 4.x (`await`, `@export`, `@onready`, `.instantiate()`, `velocity = ...; move_and_slide()`, `sig.connect(callable)`, `sig.emit()`).
3. **Strict Static Typing Shield**:
   - Declare `class_name` (for reusable types) and `extends` at the top of every script.
   - Type every variable, parameter, return value (`-> void`, `-> float`), and collection (`Array[CardData]`). Cast node lookups explicitly (`$Visuals as Node3D`).
4. **Pure-Core Headless Testability Shield**:
   - Isolate game math, mana economy, syndicate rules, combat formulas, and state logic inside pure `RefCounted` / `Resource` scripts in `scripts/domain/` with zero `SceneTree` or `SubViewport` dependencies so GUT runs them headlessly in milliseconds.
5. **2.5D Coordinate & `SubViewport` Performance Shield**:
   - Lock the project's 2.5D movement/camera convention in `docs/prd/` and `docs/GLOSSARY.md` before coding entities.
   - Separate physics (`CharacterBody3D` + `CollisionShape3D`) from visuals (`Sprite3D` / `AnimatedSprite3D` / `SubViewport`).
   - Throttle any `SubViewport` used in 3D (`UPDATE_WHEN_VISIBLE` or `UPDATE_ONCE`), set `transparent_bg = true`, use `TEXTURE_FILTER_NEAREST` for pixel art, and set explicit `alpha_cut` on `Sprite3D` to prevent transparent depth-sorting artifacts.
6. **Signal Flow & Lifecycle Safety Shield**:
   - *Call down, signal up.* Parents invoke child methods; children emit typed signals upward.
   - Guard async/deferred code with `is_instance_valid(node)` after `await`, and use `set_deferred()` / `call_deferred()` inside `_physics_process` or `Area3D` collision callbacks.
7. **Typed `Resource` Data Purity & Zero-Fallback Shield**:
   - Store unit stats, spells, cards, and syndicate configs in typed `Resource` subclasses (`.tres`), never untyped mega-dictionaries or hardcoded mock arrays when data is missing.

---

## 5. Karpathy + Ponytail + Pocock Coding Laws & SOLID Budget

- **Karpathy Law 1 (Think Before Coding)**: State assumptions upfront; resolve ambiguities via `/grill-me` (1 question + `(Recommended)`).
- **Karpathy Law 2 + Ponytail `full` (5-Rung Simplicity Ladder)**: YAGNI -> existing repo helper -> GDScript/Godot 4 native -> installed addon -> shortest working diff. Mark intentional shortcuts with `# ponytail: <reason + ceiling>`.
- **Karpathy Law 3 (Surgical Diffs)**: Touch only lines required by the task; zero drive-by refactors.
- **Karpathy Law 4 + Pocock Discipline (`tdd`, `codebase-design`, `domain-modeling`, `diagnosing-bugs`, `code-review`)**: Deep modules, consistent `GLOSSARY.md` terminology, vertical-slice GUT tests in `tests/`, and 2-axis review (Standards + Spec).
- **SOLID & File Size Ceiling**: Keep every `.gd` script focused on one responsibility and under **250-300 lines**. Apply the Rule of Two (DRY): any helper or math duplicated twice moves to `scripts/domain/` or `scripts/components/`.
- **Zero Hardcoded Secrets & Isolated Tests**: Load secrets from `.env` / environment variables; keep all GUT test scripts inside `tests/` (never inside `scripts/` or `scenes/`).

---

## 6. Project Skill Whitelist (`.agents/skills/`)

Activate ONLY skills vendored in `.agents/skills/`:
- **Godot 2.5D & EGM (Native)**: `godot-25d-architecture`, `egm-workflow`
- **Godot 4 Engine & Testing (Tier 1)**: `godot-gdscript`, `godot-gdscript-headless-testing`, `godot-resources`, `godot-nodes-scenes`, `godot-signals-groups`, `godot-3d-essentials`, `godot-ui-control`
- **JRPG Systems, AI & Mobile UX (Tier 1)**: `rpg`, `roguelike`, `save-systems`, `ai-behavior-trees-utility-ai`, `game-ui-ux`
- **2.5D Shaders, Art, Narrative & Release (Tier 2)**: `godot-shaders`, `shader-programming`, `godot-animation`, `game-feel`, `camera-systems`, `create-game-assets`, `dialogue-systems`, `performance-optimization`, `godot-audio`, `godot-export`
- **Engineering & Design**: `andrej-karpathy`, `ponytail`, `ponytail-review`, `ponytail-debt`, `codebase-design`, `tdd`, `code-review`, `diagnosing-bugs`, `domain-modeling`, `grill-me`
- **Anti-Slop**: `antislop`, `antislop-code`, `antislop-copywriting`, `antislop-human`, `antislop-ui`

---

## 7. Multi-Tier Verification Gate (Mandatory Before Declaring Done)

Run `./scripts/verify-godot.sh` after any code or scene change:
1. **Workspace & Static Anti-Bug Guards**: Zero Godot 3 deprecated syntax; `.gd` scripts within 300-line ceiling.
2. **`gdtoolkit`**: `gdformat --check` and `gdlint` pass with zero errors.
3. **Godot Headless Import & Compile**: `godot --headless --path . --import` followed by `check_scripts_compile.gd` (explicit `quit(1)` on any compile failure).
4. **Headless GUT Suite**: `godot --headless --path . -s addons/gut/gut_cmdl.gd -gdir=res://tests -gexit` (or `tests/test_runner.gd`) passes all unit/integration tests.
