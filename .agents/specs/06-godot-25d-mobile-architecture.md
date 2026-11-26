# 06 — Godot 4.x 2.5D Mobile-First Architecture & Pure-Core Schemas

## 1. Godot 4.x Mobile Rendering & Thermal Specification

| Setting | Baseline Value | Rationale |
| :--- | :--- | :--- |
| **Renderer** | `Compatibility (GLES3)` *(primary)* / `Mobile` *(optional high-tier)* | Maximum Android/iOS GPU compatibility, low thermal throttling |
| **Frame Rate** | `30 FPS` default (`Engine.max_fps = 30`) + **`60 FPS` Settings Toggle** | Cuts battery drain & heat in half for turn-based JRPG sessions |
| **Base Viewport** | `1280 × 720` (`16:9` Landscape), `stretch/mode = canvas_items`, `aspect = expand` | Crisp UI scaling across phones, tablets, and Steam Deck / PC |
| **Safe Areas** | Query `DisplayServer.get_display_safe_area()` on root HUD `MarginContainer` | Prevents notches, punch-holes, and gesture bars from clipping controls |
| **2.5D Lighting** | Baked `LightmapGI` + single directional light + blob shadows | Avoids expensive per-frame dynamic point-light shadow passes on mobile |
| **2.5D Sprites** | `Sprite3D` / `AnimatedSprite3D`, `TEXTURE_FILTER_NEAREST`, `ALPHA_CUT_OPAQUE_PREPASS` | Crisp pixel art with zero transparent Z-sorting artifacts |
| **`SubViewport` Budget** | `transparent_bg = true`, `UPDATE_WHEN_VISIBLE` or `UPDATE_ONCE` (Loom mannequin) | Zero wasted GPU renders when UI panels are closed |

---

## 2. Landscape 16:9 Dual-Thumb UI Ergonomics

- **Left-Thumb Arc:** Virtual movement stick (diorama exploration), Loom node palette, Party/Row selector.
- **Right-Thumb Arc:** Primary action (`DRY FIRE`, `CAST`, `1-Tap Tactical Signal`), Confirm/Interact, `Hold-to-Scan` Lens Pulse.
- **Top-Center Strip:** Slim **CTB Turn Timeline** + `1× / 2×` speed toggle + Act/Heat/Gold compact pill.
- **Touch Constraints:** Minimum **`48dp × 48dp`** tap targets; **zero hover tooltips** anywhere; `2`-tap maximum depth for any combat action.

---

## 3. Pure-Core `Resource` / `RefCounted` Schemas (`scripts/domain/`)

All schemas live in `scripts/domain/` with **zero `SceneTree` or `Node` dependencies** so GUT runs headlessly in milliseconds:

```gdscript
# HarmonicDriftSeed (Resource)
var master_seed: String
var origin_element: StringName          # &"fire" | &"water" | &"earth" | &"wind" | &"aether"
var bubble_element: StringName
var heresy_element: StringName          # Invariant: heresy_element != bubble_element
var active_law_id: StringName           # &"LAW_01" .. &"LAW_12"

# SpellCircuit (Resource)
var circuit_id: StringName
var custom_name: String
var core_element: StringName
var fusion_element: StringName          # &"" if single element
var vessel_id: StringName               # &"bolt" | &"spear" | &"zone" | &"pillar" | &"ward" | &"sigil"
var logic_gates: Array[StringName]
var loop_count: int
var stress_pct: float
var ip_status: StringName               # &"black_book" | &"patented" | &"leaked"
var trojan_armed: bool
var mutation_tag: StringName

# ContractorData (Resource)
var contractor_id: StringName
var display_name: String
var is_signature_agent: bool
var max_hp: int
var power: int
var guard: int
var speed: int
var loom_capacity: int
var potential_grade: StringName         # &"D" | &"C" | &"B" | &"A" | &"S"
var doctrine_ai: StringName             # &"primer" | &"detonator" | &"breaker" | &"bastion" | &"opportunist" | &"martyr"
var aetheric_body: StringName
var bond_tier: StringName               # &"contracted" | &"trusted" | &"loyal"
var contract_cut_pct: float
var status: StringName                  # &"idle" | &"active" | &"trauma" | &"liquidated"
var imprinted_circuits: Array[Resource] # Array[SpellCircuit]
```
- Additional pure-core classes: `SaveRunState` (wraps `HarmonicDriftSeed`, `act_index`, `gold`, `audit_heat`, `saturation_by_region`, `market_state`, `nation_standings`, `patents`), `MarketState`, `NationStanding`, `TimelineBattleState`, and `PatentRecord`.

---

## 4. Autoloads, Scene Tree & Offline Storage

- **Minimal Autoloads (`scripts/systems/`):**
  1. `RunStateBus` — Owns active `SaveRunState` and emits typed state-transition signals.
  2. `SaveManager` — Atomic local saves (`user://saves/slot_X.res` -> write `.tmp` -> rotate `.bak` -> rename) on every combat turn, trade, bid, and room change. **Zero Go/PostgreSQL server in V1.**
  3. `AudioHaptics` — SFX/BGM + mobile `Input.vibrate_handheld()` feedback for Loom snaps and Breaks.
- **2.5D Diorama & Battle Scene Contract:**
  - `BattleArena3D (Node3D)` -> `Camera3D` + `BakedLightmap` + `VanguardRow (Node3D)` + `VaultRow (Node3D)` + `CombatantEntity (CharacterBody3D -> Visuals/AnimatedSprite3D)`.
- **Future Store Hook:** Clean offline boundary allows a future `"Free Act I Demo -> One-Time Full Unlock"` via native StoreKit 2 / Google Play Billing without touching core gameplay.

---

## 5. Milestone 1 Vertical-Slice GUT Test Matrix (`tests/`)

Before building 2.5D scenes, verify the pure-core simulation via headless GUT:

| Test Suite | Verified Invariants |
| :--- | :--- |
| `tests/test_harmonic_drift.gd` | Same `MasterSeed` produces identical 3-Ring Cosmology; `heresy_element != bubble_element`; Act I anti-brick Brokerage & counter-element guarantees pass across 100 random seeds. |
| `tests/test_aetheric_loom.gd` | `Complexity`, `MP_Cost`, `Channel_Turns` (never `0` via Speed), `Aetheric_Stress` bands (`0–100` Certified, `101–150` Overclocked, `>150` Blocked), Patent/Trojan/Leak state transitions. |
| `tests/test_timeline_combat.gd` | Physical + Magic damage formulas, `ActionValue` ordering, **BREAK** cancellation + `+40 AV` push + `2.0×` vulnerability, Wind **Timeline Collision**, 3-axis `doctrine_ai` scoring, Loyal `0%` cut without AI overwrite. |
| `tests/test_economy_waygates.gd` | Saturation yield decay (`100% -> 50% -> 10%` + Liquidator trigger), Turn-Based Auction deterministic max-bid math, Emergency Credit Line anti-soft-lock. |
