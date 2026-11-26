# Godot 4.x 2.5D Architecture Blueprint

## 1. Target Directory Topology (Post-PRD)
Once the PRD is approved and `project.godot` is initialized, organize the repository cleanly:

```text
Mana-Syndicate/
├── project.godot
├── GOLDEN_STANDARD.md
├── AGENTS.md
├── docs/
│   ├── prd/                # Source PRD & locked technical decisions
│   ├── designs/            # EGM concepts_brief.md, design_draft.md, design_approved.md
│   └── GLOSSARY.md         # Canonical domain terms & invariants
├── scenes/
│   ├── world/              # 2.5D stages, arenas, lighting, camera rigs
│   ├── entities/           # Composed CharacterBody3D / Area3D entity scenes
│   └── ui/                 # HUD, menus, Control overlays
├── scripts/
│   ├── domain/             # Pure RefCounted / Resource simulation (0 SceneTree deps)
│   ├── components/         # Reusable child Node/Area3D components (Health, Hurtbox, StateMachine)
│   ├── entities/           # Entity body controllers & 2.5D visual adapters
│   ├── systems/            # Autoloads / managers (Audio, Save, Turn/Wave, Input)
│   ├── ui/                 # UI view scripts (bound via signals, no business math)
│   └── verify-godot.sh     # Headless verification harness
├── resources/              # Typed .tres data assets (units, spells, mana cards, palettes)
├── assets/                 # Sprites, textures, 3D meshes, audio, fonts (+ .import / .uid)
├── addons/gut/             # Godot Unit Test framework
└── tests/                  # Isolated GUT test suites (test_*.gd)
```

## 2. 2.5D Composition Pattern
Keep **Physics/Collision**, **Domain State**, and **2.5D Presentation** decoupled:

```text
EntityRoot (CharacterBody3D) [entity_body.gd — movement & collision only]
├── CollisionShape3D
├── Visuals (Node3D) [entity_visuals.gd — facing, flip, shader/animation triggers]
│   └── Sprite3D / AnimatedSprite3D  (or throttled SubViewport -> Sprite3D)
├── StateMachine (Node) [state_machine.gd]
├── HealthComponent (Node) [health_component.gd]
└── HurtboxComponent (Area3D) [hurtbox_component.gd]
```

## 3. Pure-Core Simulation Rule (`scripts/domain/`)
- Put mana pools, syndicate economy, damage/status math, deck/hand rules, and grid/lane coordinates into pure `RefCounted` or `Resource` classes.
- Never reference `get_tree()`, `Input`, or `SubViewport` inside `scripts/domain/`.
- Result: GUT tests instantiate and verify 100% of core mechanics headlessly in milliseconds.

## 4. Subtree Contract Template (`README.md`)
Each major `scripts/*/` folder must include a `README.md` with:
```markdown
# <Subtree Name>
## Interfaces
- `ClassName`: key methods, typed signals, exported properties
## Invariants
- Rules that must always hold
## Side Effects
- SceneTree mutations, autoload calls, or disk/network I/O
```
