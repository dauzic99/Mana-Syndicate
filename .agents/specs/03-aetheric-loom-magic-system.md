# 03 — Magic Synthesis (*The Aetheric Loom*) & Spell IP Warfare

## 1. The Aetheric Loom (Touch-First Circuit Graph)

Magic creation replaces static skill shops. Players weave directed mana circuits on a radial/hex touch board:

$$\text{SpellCircuit} = [\text{Core Element(s)}] \to [\text{Vessel}] \to [\text{Logic Gate(s) / Catalyst(s)}] \to [\text{Optional Loop}]$$

### Front-Loaded Progression (No Year-2 Lockout)
| Act Unlock | `loom_node_slots` | Unlocked Linear Slots (V1 — No `Splitter` Forks) |
| :--- | :--- | :--- |
| **Act I (Episode 1)** | **4 Slots** | `1 Core Element` + `1 Vessel` + `2 Gate/Catalyst slots` (Catalysts unlocked **immediately on Day 1/Ep 1**) |
| **Act II–III** | **6 Slots** | **Elemental Fusions** (`2 Core Elements`), `1 Vessel`, `3` Logic Gates/Catalysts |
| **Act IV–V** | **9 Slots** | **Mythic Elements**, `Feedback Loop` (double-pass amplification), `trojan_kill_switch` |

- **Live 2.5D Dry-Fire Preview:** Every Loom edit updates a throttled `SubViewport` mannequin bay (`own_world_3d = true`, `640×360`, pausing the background Foundry viewport). Tapping **DRY FIRE** switches to `UPDATE_WHEN_VISIBLE` and plays the exact projectile arc, 2.5D construct spawn, Timeline shift, and Stress recoil before returning to `UPDATE_ONCE`.

---

## 2. Elemental Verbs (2.5D Spatial & Timeline Physics)

Zero generic color swaps—every Element owns a distinct mechanical verb:

| Tier | Element | Mechanical Verb (2.5D Space / Timeline) |
| :--- | :--- | :--- |
| **Core (5)** | **Fire** | Leaves **Burning Tile** (`1` turn); applies *Ember* stacks; accelerates DoT ticks on Timeline. |
| **Core (5)** | **Water** | Applies *Soaked*; conducts `Lightning` & healing across all *Soaked* units on a row. |
| **Core (5)** | **Earth** | Applies *Fortify* / bonus Guard shred and amplifies `Wind` **Wall-Slam** damage (`+35%` Power). |
| **Core (5)** | **Wind** | Displaces targets between `Vanguard`/`Vault` rows OR pushes CTB Timeline markers (`Timeline Collision = Crash + Force BREAK`; mode locked in Loom). |
| **Core (5)** | **Aether** | Pure metamagic routing (`echo`, `shift`, `condition_gate`); bypasses elemental resistance checks (`1.0×`). |
| **Fusion (6)** | **Ice** (`Water+Wind`), **Magma** (`Fire+Earth`), **Lightning** (`Fire+Wind`), **Metal** (`Earth+Aether`), **Poison** (`Water+Earth`), **Gale** (`Wind+Aether`) | **Ice** (+AV Freeze), **Magma** (melts `Guard`), **Lightning** (chains *Soaked*), **Metal** (Reflect Ward), **Poison** (stacking %HP Decay), **Gale** (multi-target row pull). |
| **Mythic (5)** | **Gravity**, **Void**, **Mirage**, **Plasma**, **Chaos** | **Gravity** (%MaxHP + heavy push), **Void** (0 dmg, instant **BREAK** + HP cost), **Mirage** (1-turn Evasion / 200% vuln next), **Plasma** (pierces all Wards), **Chaos** (random Mythic + high Stress). |

---

## 3. Vessels (6) & Logic Gates / Catalysts (6)

- **Vessels (Shape & Delivery):**
  1. `Bolt` — Fast single-target projectile (`0` base Channel).
  2. `Spear` — Pierces `40% Guard`, triggers **BREAK** on Physical/Pierce weak points (`0` base Channel).
  3. `Zone` — Hits entire target Row (`Vanguard` or `Vault`) (`0` base Channel, higher MP).
  4. `Pillar` — Heavy single-target + spawns 2.5D Stone Pillar (`HP = 25% MaxHP`, `3` turns, max `2` per side, `1` base Channel Turn).
  5. `Ward` — Grants Barrier/Buff to self or Row (`0` base Channel).
  6. `Sigil` — Places 2.5D ground trap triggering when an enemy enters/attacks (`0` base Channel).
- **Canonical Logic Gates (`LogicGateId` — max `1` of each per circuit; recursion `depth <= 1`):**
  1. `echo` — Re-casts circuit immediately at `50%` power (never triggers nested `echo`/`Chain`).
  2. `leech` — Restores `15%` of damage dealt as HP.
  3. `shift` — Swaps target between `Vanguard` and `Vault`.
  4. `condensation` — Halves MP cost (`0.5×`), adds `+1` Channel Turn.
  5. `condition_gate` — Conditional trigger (`IF TARGET SOAKED`, `ON BREAK`, `IF ALLY <50% HP`) granting `+40%` power when satisfied.
  6. `trojan_kill_switch` — Act IV+ dormant node; **1-time trigger per patented blueprint**: grants Examiner instant `0 MP` **Force BREAK** when an enemy casts it, then voids that spell's Patent royalties and adds `+30` Audit Heat.

---

## 4. Unified Complexity, Channeling & Aetheric Stress Math

```text
Complexity        = ElementCost + VesselCost + Sum(GateCosts) + (LoopCount * 15)
MP_Cost           = max(1, roundi(BaseMP * VesselMult * ElementMult * Product(GateMults) * LawMod))
Channel_Turns     = max(0, BaseVesselChannel + OverchargeChannel + LoopCount) // NEVER erased by Speed!
Aetheric_Stress   = (Complexity / max(1, Caster.loom_complexity_cap)) * 100.0   // Computed dynamically per caster
```

| Stress Band | State | Gameplay Effect |
| :--- | :--- | :--- |
| **`<= 100.0%`** | **Certified** | Stable execution (`StressBonus = 1.0`); `0` recoil; **eligible for Clearinghouse Patenting**. |
| **`(100.0%, 150.0%]`** | **Overclocked** | Legal to weave and cast! `StressBonus = 1.25 + ((Stress - 100.0) / 50.0) * 0.35` (`1.25×`–`1.60×` power), **plus** a deterministic Lens-visible **Recoil Vector** (HP recoil floors at `1 HP`). |
| **`> 150.0%`** | **Uncompilable** | Blocked in Loom & Imprinting until `loom_complexity_cap` increases (unless mutated live in combat). |

### Live Field Fracture-Mutation
When an **Overclocked** (`101–150%`) spell lands a **Boss BREAK** or triggers a **3-Element Chain Reaction**, it has a deterministic chance to **Fracture-Mutate** into a save-unique **Anomaly Spell**—gaining a permanent bonus node (exceeding normal Loom limits) and prompting the player to name it.

---

## 5. Spell IP Warfare State Machine

Every crafted `SpellCircuit` carries an `ip_status` that directly reshapes the economy and enemy AI:

| `ip_status` (`StringName`) | Requirements | Economic / World Effect | Combat Consequence |
| :--- | :--- | :--- | :--- |
| **`&"patented"`** | `Stress <= 100.0%`, `Complexity >= 35`, `150G * Act` fee (max `1/Act`, `5` total) | Pays **Passive Act Royalties** (`BaseValue * NationDemand * BubbleMult`, `3×` if Bubble Element). | **Top-3 Highest-Complexity Pool:** Rival Nations & Act Bosses license and **cast your spell back at you** (unless armed with 1-time `trojan_kill_switch`). |
| **`&"open_source_leak"`** | Any `Stress <= 150.0%` | Crashes target Nation's commodity/spell monopoly (`-40%` regional prices); adds **`+20` Audit Heat**. | Triggers **Audit Choir Hit-Squad** ambushes in Waygates; wins Rebel/Agent leverage. |
| **`&"black_book"`** | Default / Proprietary | Zero royalties; small concealment upkeep in Foundry. | **Zero Enemy Counter-Data:** Bosses cannot pre-adapt to or copy Black-Book circuits. |
