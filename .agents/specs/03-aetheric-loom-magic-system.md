# 03 — Magic Synthesis (*The Aetheric Loom*) & Spell IP Warfare

## 1. The Aetheric Loom (Touch-First Circuit Graph)

Magic creation replaces static skill shops. Players weave directed mana circuits on a radial/hex touch board:

$$\text{SpellCircuit} = [\text{Core Element(s)}] \to [\text{Vessel}] \to [\text{Logic Gate(s) / Catalyst(s)}] \to [\text{Optional Loop}]$$

### Front-Loaded Progression (No Year-2 Lockout)
| Act Unlock | Loom Capacity | Unlocked Nodes |
| :--- | :--- | :--- |
| **Act I (Episode 1)** | **4 Nodes** | `1 Core Element` + `1 Vessel` + `1 Catalyst/Logic Gate` (Catalysts unlocked **immediately on Day 1/Ep 1**) |
| **Act II–III** | **6 Nodes** | **Elemental Fusions** (`2 Core Elements`), `Splitter` fork node, `2` Logic Gates |
| **Act IV–V** | **9 Nodes** | **Mythic Elements**, `Feedback Loop` (double-pass amplification), `Trojan Kill-Switch` |

- **Live 2.5D Dry-Fire Preview:** Every Loom edit updates an inline `SubViewport` 2.5D mannequin arena. Tapping **DRY FIRE** plays the exact projectile arc, 2.5D construct spawn, Timeline shift, and Stress recoil before committing.

---

## 2. Elemental Verbs (2.5D Spatial & Timeline Physics)

Zero generic color swaps—every Element owns a distinct mechanical verb:

| Tier | Element | Mechanical Verb (2.5D Space / Timeline) |
| :--- | :--- | :--- |
| **Core (5)** | **Fire** | Leaves **Burning Tile** (`1` turn); applies *Ember* stacks; accelerates DoT ticks on Timeline. |
| **Core (5)** | **Water** | Applies *Soaked*; conducts `Lightning` & healing across all *Soaked* units on a row. |
| **Core (5)** | **Earth** | Spawns **2.5D Stone Pillar** (`HP = 25% caster MaxHP`); blocks melee & creates crash wall for `Wind`. |
| **Core (5)** | **Wind** | Displaces targets between `Vanguard`/`Vault` rows AND pushes CTB Timeline markers (`Timeline Collision = Crash + BREAK`). |
| **Core (5)** | **Aether** | Pure metamagic routing (`COPY`, `INVERT`, `BRIDGE`); bypasses elemental resistance checks. |
| **Fusion (6)** | **Ice** (`Water+Wind`), **Magma** (`Fire+Earth`), **Lightning** (`Fire+Wind`), **Metal** (`Earth+Aether`), **Poison** (`Water+Earth`), **Gale** (`Wind+Aether`) | **Ice** (+AV Freeze), **Magma** (melts `Guard`), **Lightning** (chains *Soaked*), **Metal** (Reflect Ward), **Poison** (stacking %HP Decay), **Gale** (multi-target row pull). |
| **Mythic (5)** | **Gravity**, **Void**, **Mirage**, **Plasma**, **Chaos** | **Gravity** (%MaxHP + heavy push), **Void** (0 dmg, instant **BREAK** + HP cost), **Mirage** (1-turn Evasion / 200% vuln next), **Plasma** (pierces all Wards), **Chaos** (random Mythic + high Stress). |

---

## 3. Vessels (6) & Logic Gates / Catalysts (6)

- **Vessels (Shape & Delivery):**
  1. `Bolt` — Fast single-target projectile (`0` base Channel).
  2. `Spear` — Pierces `40% Guard`, triggers **BREAK** on Physical/Pierce weak points (`0` base Channel).
  3. `Zone` — Hits entire target Row (`Vanguard` or `Vault`) (`0` base Channel, higher MP).
  4. `Pillar` — Heavy single-target + spawns/enhances 2.5D terrain (`1` base Channel Turn).
  5. `Ward` — Grants Barrier/Buff to self or Row (`0` base Channel).
  6. `Sigil` — Places 2.5D ground trap triggering when an enemy enters/attacks (`0` base Channel).
- **Logic Gates & Catalysts (Modifiers):**
  1. `Echo` — Re-casts circuit immediately at `50%` power.
  2. `Leech` — Restores `15%` of damage dealt as HP.
  3. `Shift` — Swaps target between `Vanguard` and `Vault`.
  4. `Condensation` — Halves MP cost (`0.5×`), adds `+1` Channel Turn.
  5. `ConditionGate` — Conditional trigger (`IF TARGET SOAKED`, `ON BREAK`, `IF ALLY <50% HP`) granting `+40%` power when satisfied.
  6. `TrojanKillSwitch` — Hidden dormant node; if an enemy casts a Patented version of this spell, Examiner triggers instant **Auto-Break** for `0 MP`.

---

## 4. Unified Complexity, Channeling & Aetheric Stress Math

```text
Complexity        = ElementCost + FusionCost + VesselCost + Sum(GateCosts) + (LoopCount * 15)
MP_Cost           = round(BaseMP * VesselMult * GateMult * LawMod)
Channel_Turns     = BaseVesselChannel + OverchargeChannel + LoopCount   // NEVER erased to 0 by Speed!
Aetheric_Stress   = (Complexity / Caster.LoomCapacity) * 100.0
```

| Stress Band | State | Gameplay Effect |
| :--- | :--- | :--- |
| **`0% – 100%`** | **Certified** | Stable execution; `0` recoil; **eligible for Clearinghouse Patenting**. |
| **`101% – 150%`** | **Overclocked** | Legal to weave and cast! Gains **`+25%` to `+60%` Circuit Power** (`(Stress - 100) * 1.2%`), **plus** a deterministic, Eye-Pulse-visible **Recoil Vector** (e.g., `12%` caster HP burn, self-push to Vault, or `+15 AV` self-delay). |
| **`> 150%`** | **Uncompilable** | Blocked in Loom until `LoomCapacity` increases (unless mutated live in combat). |

### Live Field Fracture-Mutation
When an **Overclocked** (`101–150%`) spell lands a **Boss BREAK** or triggers a **3-Element Chain Reaction**, it has a deterministic chance to **Fracture-Mutate** into a save-unique **Anomaly Spell**—gaining a permanent bonus node (exceeding normal Loom limits) and prompting the player to name it.

---

## 5. Spell IP Warfare State Machine

Every crafted `SpellCircuit` carries an `ip_status` that directly reshapes the economy and enemy AI:

| `ip_status` | Requirements | Economic / World Effect | Combat Consequence |
| :--- | :--- | :--- | :--- |
| **PATENTED** | `Stress <= 100%` (Certified) | Pays **Passive Act Royalties** (`BaseValue * NationDemand * BubbleMult`, `3×` if Bubble Element). | **Injected into Enemy Pool:** Rival Nations & Act Bosses license and **cast your spell back at you** (unless armed with `TrojanKillSwitch`, which grants you an instant `Auto-Break`). |
| **OPEN_SOURCE_LEAK** | Any `Stress <= 150%` | Crashes target Nation's commodity/spell monopoly (`-40%` regional prices); visibly upgrades 2.5D hub districts; adds **`+20` Audit Heat**. | Triggers **Audit Choir Hit-Squad** ambushes in Waygates; wins Rebel/Agent leverage. |
| **BLACK_BOOK** | Default / Proprietary | Zero royalties; small concealment upkeep in Foundry. | **Zero Enemy Counter-Data:** Bosses cannot pre-adapt to or copy Black-Book circuits. |
