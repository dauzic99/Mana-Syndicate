# 06 — Godot 4.x 2.5D Mobile-First Architecture & Pure-Core Schemas

## 1. Godot 4.x Mobile Rendering & Thermal Specification

| Setting | Baseline Value | Rationale |
| :--- | :--- | :--- |
| **Renderer** | `Compatibility (GLES3)` *(primary)* / `Mobile` *(optional high-tier)* | Maximum Android/iOS GPU compatibility, low thermal throttling |
| **Frame Rate** | `30 FPS` default (`Engine.max_fps = 30`) + `physics/common/physics_interpolation = true` + **`60 FPS` Toggle** | Cuts battery drain & heat in half with zero 30/60Hz movement stutter |
| **Base Viewport** | `1280 × 720` (`16:9` Landscape), `stretch/mode = canvas_items`, `aspect = expand` | Crisp UI scaling across phones, tablets, and Steam Deck / PC |
| **Safe Areas** | Query `DisplayServer.get_display_safe_area()` on root HUD `MarginContainer` | Prevents notches, punch-holes, and gesture bars from clipping controls |
| **2.5D Lighting** | `WorldEnvironment` (runtime sky/ambient/fog tint per `active_law_id`) + 1 unshadowed `DirectionalLight3D` + `Decal`/`Sprite3D` blob shadows | Supports 12 dynamic Law tints on `GLES3` with zero per-frame shadow-pass or lightmap VRAM bloat |
| **2.5D Spatial Contract** | `Camera3D` `PERSPECTIVE` (`FOV 35°`, `-25°` pitch), `+X` right / `-Z` into screen, `Sprite3D.pixel_size = 0.03125`, `BILLBOARD_FIXED_Y`, `TEXTURE_FILTER_NEAREST`, `ALPHA_CUT_DISCARD` | Crisp pixel art with zero transparent Z-sorting artifacts or ambiguity |
| **`SubViewport` Budget** | Loom mannequin bay: `own_world_3d = true`, `640×360`, `MSAA_DISABLED`, pause background Foundry viewport; `UPDATE_ONCE` (idle) <-> `UPDATE_WHEN_VISIBLE` (Dry-Fire) | Zero dual-3D mobile GPU bottleneck when Loom is idle |

---

## 2. Landscape 16:9 Dual-Thumb UI Ergonomics

- **Left-Thumb Arc:** Virtual movement stick (diorama exploration), Loom node palette, Party/Row selector.
- **Right-Thumb Arc:** Primary action (`DRY FIRE`, `CAST`, `1-Tap Tactical Signal`), Confirm/Interact, **`LENS`** hold-button (`0.38s` / `<= 14px` slop).
- **Top-Center Strip:** Slim **CTB Turn Timeline** + `1× / 2×` speed toggle + Act/Heat/Gold compact pill.
- **Touch Constraints:** Minimum **`80 × 80` virtual px** at `1280×720` (`~48dp` physical on 6" phones); **zero hover tooltips** anywhere; `2`-tap maximum depth for any combat action.

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

# SpellCircuit (Resource) — Linear V1 Slots (No Splitter Forks)
var circuit_id: StringName
var custom_name: String
var core_elements: Array[StringName]     # Max 2 (auto-resolves Fusion/Mythic)
var vessel_id: StringName               # &"bolt" | &"spear" | &"zone" | &"pillar" | &"ward" | &"sigil"
var logic_gates: Array[StringName]      # Canonical LogicGateId, max 1 of each
var loop_count: int
var chrono_target_mode: StringName      # &"row" | &"timeline" (locked in Loom for Wind)
var ip_status: StringName               # &"black_book" | &"patented" | &"open_source_leak"
var trojan_armed: bool
var trojan_consumed: bool
var mutation_tag: StringName
# Stress computed dynamically: circuit.get_stress_for(caster.loom_complexity_cap)

# ContractorData (Resource)
var contractor_id: StringName
var display_name: String
var is_signature_agent: bool
var origin_element: StringName
var row: StringName                     # &"vanguard" | &"vault"
var max_hp: int
var current_hp: int
var max_mp: int
var current_mp: int
var power: int
var guard: int
var speed: int
var loom_complexity_cap: int            # >= 1
var grimoire_slots: int                 # 2..4
var potential_grade: StringName         # &"D" | &"C" | &"B" | &"A" | &"S"
var doctrine_ai: StringName             # &"primer" | &"detonator" | &"breaker" | &"bastion" | &"opportunist" | &"martyr"
var aetheric_body: StringName
var bond_tier: StringName               # &"contracted" | &"trusted" | &"loyal"
var contract_cut_pct: float
var status: StringName                  # &"idle" | &"active" | &"trauma" | &"suspended" | &"subcontract" | &"liquidated"
var imprinted_circuits: Array[Resource] # Array[SpellCircuit]
```
- Additional pure-core classes: `SaveRunState` (wraps `schema_version`, `HarmonicDriftSeed`, `active_state`, `act_index`, `episode_index`, `difficulty_mode`, `gold`, `credit_line_debt`, `audit_heat`, `saturation_by_region`, `market_state`, `nation_standings`, `patents`, `party_roster`, `brokerage_pool`, `crafted_circuits`, `active_subcontracts`, `active_battle_state`, `active_raid_state`, `active_auction_state`, and all 6 `rng_states`), `MarketState`, `NationStanding`, `TimelineBattleState`, and `PatentRecord`.

---

## 4. Autoloads, Scene Tree & Offline Storage

- **Minimal Autoloads (`scripts/systems/`):**
  1. `RunStateBus` — Owns active `SaveRunState` and emits typed state-transition signals.
  2. `SaveManager` — Versioned JSON local saves (`user://saves/slot_X.json` with `schema_version` + `sha256` check; async `WorkerThreadPool` write `.tmp` -> `.bak` -> `rename` + synchronous `NOTIFICATION_APPLICATION_PAUSED` flush) before animations on every turn, trade, bid, and room change. **Zero `.res` RCE risk and zero Go/PostgreSQL server in V1.**
  3. `AudioHaptics` — SFX/BGM + mobile `Input.vibrate_handheld()` feedback for Loom snaps and Breaks.
- **2.5D Diorama & Battle Scene Contract:**
  - `BattleArena3D (Node3D)` -> `Camera3D` + `WorldEnvironment` + `DirectionalLight3D` + `VanguardRow (Node3D)` + `VaultRow (Node3D)` + `CombatantEntity (CharacterBody3D -> Visuals/AnimatedSprite3D)`.
- **Future Store Hook:** Clean offline boundary allows a future `"Free Act I Demo -> One-Time Full Unlock"` via native StoreKit 2 / Google Play Billing without touching core gameplay.

---

## 5. Phased GUT Test Matrix (`tests/` — M1 / M2 / M3)

Before building 2.5D scenes, verify the pure-core simulation via headless GUT in 3 staged cutlines:

| Cutline | Test Suite | Verified Invariants |
| :--- | :--- | :--- |
| **M1 (Act I Core)** | `tests/test_harmonic_drift.gd` | `SHA-256` 6-stream determinism across 100 seeds; `heresy_element != bubble_element`; Act I anti-brick guarantees. |
| **M1 (Act I Core)** | `tests/test_aetheric_loom.gd` | `5` Core Elements, `4` Vessels (`Bolt`, `Spear`, `Zone`, `Pillar`), `4` Gates (`echo`, `leech`, `shift`, `condensation`), `MP_Cost >= 1`, `ChannelAV = 75 * turns`, dynamic Stress (`<=100`, `(100,150]`, `>150`), Patent/Leak/Black-Book math. |
| **M1 (Act I Core)** | `tests/test_timeline_combat.gd` | Physical + Magic damage (`Guard >= 0`, `max(1, round)`), `Speed >= -50`, Collision (`<= 5.0 AV`) + diminishing Break push + 1 drop/enemy, 4 Doctrines, JSON `SaveManager` resume. |
| **M2 (Act II–III)** | `tests/test_economy_waygates.gd` | `6` Fusions, Saturation yield decay + escalating `Leyline Purge`, Turn-Based Auction (`+50%` jump-bid, Round 5 sealed, tie-break), Credit Line shortfall borrow + `<= 50%` squad cut, `Bond` Loyalty override. |
| **M3 (Act IV–V)** | `tests/test_endgame_laws.gd` | `5` Mythics, `Feedback Loop`, 1-time `trojan_kill_switch`, all `12` Global Laws (`LAW_08` `0.4×–2.5×`, `LAW_11` pre-cast), Hardcore Margin Call. |
