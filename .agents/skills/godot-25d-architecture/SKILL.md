---
name: godot-25d-architecture
description: Godot 4.x 2.5D architecture, typed GDScript, composition over inheritance, pure-core headless testability (GUT), SubViewport/Sprite3D performance, and scene-vs-script safety for Mana-Syndicate.
---

# Godot 4.x 2.5D Architecture & Engineering Skill

Use this skill for all GDScript, scene, resource, and 2.5D spatial/rendering work in `Mana-Syndicate`.

## 1. Engine & Syntax Purity (Godot 4.x Only)
- **Strictly Godot 4.x** — never emit Godot 3.x syntax:
  - Use `@export`, `@onready`, `@export_group`, `@export_range`.
  - Emit signals with `signal_name.emit(args)` and connect with `obj.signal_name.connect(callable)`.
  - Move `CharacterBody3D` via `velocity = ...; move_and_slide()` (no `move_and_slide(velocity)` argument).
  - Use `create_tween()`, `instantiate()` (not `.instance()`), `await` (not `yield()`), and `super()`.

## 2. 2.5D Composition Blueprint
- **Entities as Composed Scenes**: Root `CharacterBody3D` or `Node3D` with focused child components (`HealthComponent`, `HurtboxComponent`, `HitboxComponent`, `StateMachine`) instead of deep inheritance hierarchies or 500-line monolith scripts.
- **Decoupled Visual Layer**:
  - Keep physics/collision (`CharacterBody3D` + `CollisionShape3D`) separate from presentation (`Visuals` node).
  - For `Sprite3D` / `AnimatedSprite3D`: set explicit `billboard` mode (`BILLBOARD_ENABLED` or `BILLBOARD_FIXED_Y`), `texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST` (for pixel art), and `alpha_cut = SpriteBase3D.ALPHA_CUT_OPAQUE_PREPASS` (or `ALPHA_CUT_DISCARD`) to avoid transparent depth-sorting artifacts.
  - For `SubViewport` -> `Sprite3D` (2D rigs/shaders/UI in 3D): set `transparent_bg = true` and throttle `render_target_update_mode` (`UPDATE_WHEN_VISIBLE` or `UPDATE_ONCE` on demand) so off-screen or static entities do not burn frame budget.

## 3. Pure-Core Simulation Layer (`scripts/domain/`)
- Keep core game rules (mana economy, syndicate mechanics, combat math, turn/state transitions, grid/coordinate helpers) in **pure `RefCounted` or `Resource` classes** with zero `SceneTree` or `SubViewport` dependencies.
- Pure-core classes instantiate in microseconds under headless GUT (`godot --headless --path . -s addons/gut/gut_cmdl.gd`).

## 4. Scene-vs-Script Boundary & `.uid` Safety
- **Treat `.gd` and `.tres` schemas as code; treat `.tscn` as fragile editor-owned data.**
- Never hand-rewrite complex `.tscn` `ext_resource` / `sub_resource` blocks when a Godot Editor dock instruction or small script attachment is safer.
- **Godot 4.4+ `.uid` Files**: Never delete or `.gitignore` `*.uid` files—they are authoritative resource IDs.

## 5. Strict Static Typing & Lifecycle Safety
- Every script MUST declare `class_name` (when reusable) and `extends`.
- Type all variables, parameters, return types (`-> void`, `-> float`), and collections (`Array[CardData]`, `Dictionary`).
- Cast node lookups explicitly (`@onready var visuals: Node3D = $Visuals as Node3D`).
- **Signal Flow**: *Call down, signal up.* Parents call child methods; children emit signals upward.
- **Lifecycle Guards**: Check `is_instance_valid(target)` after `await` or timers; use `set_deferred()` / `call_deferred()` when mutating `monitoring`, `disabled`, or scene-tree parentage inside physics/collision callbacks.

## 6. Verification Loop
After any GDScript or scene edit, run:
```bash
./scripts/verify-godot.sh
```
This enforces static Godot 4 guards, `gdformat --check`, `gdlint`, `godot --headless --path . --quit`, and headless GUT tests.
