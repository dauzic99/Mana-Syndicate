# 07 — Balance Tables & Canonical V1 Constants

Single source of truth for all numeric constants, multipliers, and enum mappings required by `scripts/domain/` and Milestone 1–3 GUT tests.

---

## 1. Aetheric Loom Constants

```gdscript
const LOOM_NODE_SLOTS_BY_ACT: Dictionary = {
    1: 4, # 1 Core + 1 Vessel + 2 Gate/Catalyst slots
    2: 6, # 2 Cores (Fusion) + 1 Vessel + 3 Gate/Catalyst slots
    3: 6,
    4: 9, # Mythic + Feedback Loop + TrojanKillSwitch
    5: 9,
}
const BASE_LOOM_COMPLEXITY_CAP: int = 60 # Scales +15 per Act tier up to 150
const BASE_MP: int = 10
const LOOP_COMPLEXITY_COST: int = 15
const LOOP_POWER_BONUS: float = 0.45   # +45% power per Feedback Loop
```

| Category | Canonical ID (`StringName`) | `Complexity` Cost | `MP` Mult | `BaseChannel` | `CircuitPower` / Effect |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Core Element** | `&"fire"`, `&"water"`, `&"earth"`, `&"wind"`, `&"aether"` | `15` | `1.0×` | `0` | Applies Elemental Verb (`03:§2`) |
| **Fusion Element** | `&"ice"`, `&"magma"`, `&"lightning"`, `&"metal"`, `&"poison"`, `&"gale"` | `30` | `1.25×` | `0` | Replaces single Core cost (`2` Core slots) |
| **Mythic Element** | `&"gravity"`, `&"void"`, `&"mirage"`, `&"plasma"`, `&"chaos"` | `45` | `1.6×` | `0` | Replaces Core cost; `Void` deals `0` dmg + Force BREAK |
| **Vessel** | `&"bolt"` | `10` | `1.0×` | `0` | `1.00` (Single target) |
| **Vessel** | `&"spear"` | `15` | `1.2×` | `0` | `1.15` (`0.40` ArmorPierce + Channel BREAK) |
| **Vessel** | `&"zone"` | `20` | `1.5×` | `0` | `0.85` (Full Row; ignores Vanguard cover) |
| **Vessel** | `&"pillar"` | `20` | `1.4×` | `1` | `1.35` (Spawns 2.5D Construct `25% MaxHP`, `3` turns, max `2`/side) |
| **Vessel** | `&"ward"` | `15` | `1.2×` | `0` | `0.00` (Grants `Power * 1.1` Barrier to self/Row) |
| **Vessel** | `&"sigil"` | `15` | `1.1×` | `0` | `1.10` (2.5D ground trap) |
| **Logic Gate** | `&"echo"` | `15` | `1.4×` | `0` | Re-casts at `50%` power (`depth <= 1`) |
| **Logic Gate** | `&"leech"` | `10` | `1.2×` | `0` | Heals `15%` of damage dealt |
| **Logic Gate** | `&"shift"` | `10` | `1.15×` | `0` | Swaps target between `Vanguard` & `Vault` |
| **Logic Gate** | `&"condensation"` | `15` | `0.5×` | `+1` | Halves MP cost, adds `+1` Channel Turn |
| **Logic Gate** | `&"condition_gate"` | `15` | `1.1×` | `0` | `+40%` power if condition met |
| **Logic Gate** | `&"trojan_kill_switch"` | `20` | `1.0×` | `0` | Act IV+; 1-time `0 MP` Force BREAK on enemy Patented cast |

- **Duplicate Gate Rule:** A circuit may contain at most `1` copy of each `LogicGateId`.
- **MP Floor:** `MP_Cost = max(1, roundi(BASE_MP * VesselMult * FusionOrMythicMult * Product(GateMults) * LawMod))`.

---

## 2. Elemental Affinity Matrix (`ElementMod`)

- **Core Counter Ring (`1.5×` Counter / `0.75×` Resist):** `Fire > Wind > Earth > Water > Fire`.
- **Aether:** `1.0×` vs all targets (bypasses elemental resistance).
- **Heresy Element Advantage:** If `Spell.core_element == Drift.heresy_element` and target is a Syndicate Auditor / Act Boss, `ElementMod = 1.25×` (`0%` enemy resistance).
- **Fusion / Mythic:** Inherits `max(ElementMod)` of constituent elements (`Void` always deals `0` HP damage).

---

## 3. CTB Timeline, Combat & Roster Constants

| Constant | Value | Rule |
| :--- | :--- | :--- |
| `PARTY_SIZE` | `4` | `1` Examiner + up to `3` Contractors |
| `BASE_DELAY` | `100.0` | `ActionValue = BASE_DELAY / (1.0 + max(-50.0, Speed) / 100.0)` |
| `FIXED_CHANNEL_AV` | `75.0` | `ChannelAV = Channel_Turns * FIXED_CHANNEL_AV` (Speed-independent) |
| `COLLISION_AV_EPSILON` | `5.0` | Shoving/pulling across or within `<= 5.0 AV` of another enemy triggers Collision |
| `BREAK_PUSH_DIMINISHING` | `[40.0, 20.0, 0.0]` | Consecutive Break AV pushes before target completes a turn |
| `BREAK_DROP_CAP` | `1` | Max `1` Shard/Fragment drop per enemy per battle |
| `BASE_MAGIC_PIERCE` | `0.15` | Default `ArmorPierce` for spells (`0.40` for `Spear`) |
| `BASE_CRIT_MULT` | `1.5` | Applied when `CritMod` procs (`1.0` otherwise) |
| `WALL_SLAM_MULT` | `0.35` | Bonus `Attacker.Power * 0.35` damage when `Wind` slams enemy into `Earth Pillar` |
| `TURN_MP_REGEN_BASE` | `4` | `TurnMPRegen = mini(12, 4 + ReactionBonus)` |
| `MARTYR_HP_PER_MP_PCT` | `0.02` | `2% MaxHP` sacrificed per `1 MP` deficit (cannot cast if `current_hp <= cost`) |
| `MAX_SQUAD_CUT_PCT` | `0.50` | Combined squad `contract_cut_pct` hard-capped at `50%` |

---

## 4. Four-Nation `PrimaryElement`, Economy & Audit Constants

| Nation ID (`StringName`) | `PrimaryElement` |
| :--- | :--- |
| `&"ironclad_forges"` | `&"fire"` |
| `&"canopy_sanatoriums"` | `&"water"` |
| `&"glass_dune_freeholds"` | `&"wind"` |
| `&"basalt_vaults"` | `&"earth"` |

*(Non-elemental / `&"aether"` lots use `NationInterest = 1.0`.)*

| System | V1 Formula / Constant |
| :--- | :--- |
| **Audit Heat (`0–100`)** | `>= 40`: `+25%` Exchange tariff; `>= 70`: Hit-Squad Ambush; `>= 90`: Legal Exchange lockout. `-10` decay per Episode; Laundering costs `150G` per `-20` Heat. |
| **Waygate Saturation (`0–100%`)** | `+20%` per Raid battle, `+10%` per extraction. Resets on Episode/Act advance. |
| **Leyline Purge** | Cost `= 200G * (2 ** purges_this_episode)`, max `1` per Episode, adds `+15` Audit Heat. |
| **Patents** | Max `1` new Patent per Act (`5` active max). Filing fee `= 150G * act_index`. Min `Complexity >= 35`. `BaseValue = 100G * act_index * (1.0 + Complexity / 100.0)`. |
| **Bailout & Credit Line** | `BailoutThreshold = 150G * act_index`. `CreditLineCap = 3 * BailoutThreshold`. Auto-borrows shortfall when `liquid_gold < required_fee`; repays `20%` of net post-cut payouts (`>= 1G` floor). |
