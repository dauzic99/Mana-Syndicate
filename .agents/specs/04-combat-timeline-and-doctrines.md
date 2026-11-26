# 04 — Combat Engine, CTB Timeline & Contractor Doctrines

## 1. Four Core Combat Stats (Mobile-Legible)

Arbitrary economic stat tie-ins (e.g., DEF = mining clicks) are removed. Every combatant uses **4 clean stats** plus two metadata fields:

| Stat / Field | Role |
| :--- | :--- |
| **`HP` (`max_hp`)** | Survivability pool; determines Trauma/Overkill threshold. |
| **`Power` (`power`)** | Unified offensive scaling for both Physical strikes and Aetheric Loom circuits. |
| **`Guard` (`guard`)** | Unified Physical + Magic damage mitigation. |
| **`Speed` (`speed`)** | CTB Turn Timeline velocity (`ActionValue` calculation). **Never** reduces `Channel_Turns` to `0`. |
| **`LoomCapacity`** | Examiner & Contractor circuit ceiling before `Aetheric_Stress` enters `Overclocked`. |
| **`PotentialGrade`** | `D`, `C`, `B`, `A`, `S` (replaces raw `1.85x` floats on mobile UI; maps to growth multipliers `0.85×`–`2.20×`). |

---

## 2. Explicit Damage, Mitigation & MP Formulas

Both Physical and Magic formulas are explicitly defined (fixing the missing Physical DEF bug):

```text
PhysicalDamage = (Attacker.Power * SkillMult)
                 * (100.0 / (100.0 + Target.Guard * (1.0 - ArmorPierce)))
                 * RowMod * BreakMod * ElementMod

MagicDamage    = (Attacker.Power * CircuitPower * StressBonus)
                 * (100.0 / (100.0 + Target.Guard * 0.85))
                 * BreakMod * ElementMod * LawMod

TurnMPRegen    = 4 + ReactionBonus   // Capped in combat; zero out-of-combat heal/regen stall
```
- `BreakMod`: `2.0` (`2.5` under `LAW_05 Volatile Resonance`) when target is in **BREAK** state; otherwise `1.0`.
- `RowMod`: `1.0` standard; `0.75` if ranged strike hits protected `Vault` behind an active `Vanguard` or `Earth Pillar` (unless `Spear` / `Plasma` / `Zone`).

---

## 3. CTB Turn Timeline, Channeling & Collision Breaks

- **Action Value (`AV`) Formula:** `ActionValue = BaseDelay / (1.0 + Speed / 100.0)`.
- **Visible Top-Center Timeline:** Shows the next `8` unit turns, including **Channeling Telegraph Markers**.
- **Channeling & BREAK Rules:**
  - Heavy circuits (`Pillar`, `Condensation`, `Loop`) place the caster into **Channeling** for `Channel_Turns`.
  - Hitting a Channeling target with a **Counter-Element**, `Spear`, `Void`, or a **Timeline Collision** triggers **BREAK**:
    1. Cancels the channeled spell immediately.
    2. Pushes the target's Timeline marker **`+40` AV**.
    3. Applies **`2.0×` Vulnerability** until the target's next completed turn.
    4. Drops `1` **Logic Gate Shard** or **Catalyst Fragment** on elite/boss Breaks.
- **Timeline Collision:** Using `Wind` (`Chrono-Vector` / `Gale`) to shove an enemy's AV marker directly onto an adjacent enemy's AV marker deals collision damage and triggers **BREAK** on both.

---

## 4. Vanguard & Vault 2.5D Rows

- **Vanguard (Front Row):** Intercepts 100% of single-target melee attacks. Vulnerable to `Zone` sweeps and `Shift` displacement.
- **Vault (Back Row):** Protected from melee targeting while at least 1 ally or `Earth Pillar` stands in Vanguard.
- **2.5D Constructs:** `Earth` Pillars occupy a Vanguard slot, absorb melee hits, and deal bonus **Wall-Slam** damage when `Wind` shoves an enemy backward.

---

## 5. Two-Tier Roster & 3-Axis Contractor Schema

Resolving the story-vs-permadeath conflict with **2 clean tiers**:

| Tier | Roster Rule | Permanence |
| :--- | :--- | :--- |
| **Tier 1: Signature Agents (8–12)** | Named cross-nation specialists (e.g., *Varek, Dr. Silas, Zafira, Oros*). 3-Episode personal arcs unlock **Unique Signature Catalysts**. | **Cannot permanently die** (suffer Trauma / Audit Suspension only). |
| **Tier 2: Brokerage Pool (Procedural)** | Continuously replenished freelancer pool (`30` active listings, refreshed each Episode). Imprint Examiner's custom `SpellCircuit`s into their **2–4 Grimoire Slots**. | **Trauma** by default; **Voluntary Liquidation** (*Extract Relic Node*) or automatic on Hardcore Audit. |

### Clean 3-Axis Contractor Schema (No Single-ID Overload)
Every party member has **3 independent typed fields**:

1. **`doctrine_ai` (6 Always-Useful Deterministic AI Policies):**
   - `PRIMER`: Prioritizes applying elemental states (*Soaked*, *Ember*, *Earth Pillar*).
   - `DETONATOR`: Targets primed enemies to trigger elemental chains (`Lightning` on *Soaked*, etc.).
   - `BREAKER`: Holds high-`AV` / `Spear` / counter-element casts for **Channeling** enemies; uses basic attack otherwise (never stands AFK).
   - `BASTION`: Guards `Vanguard`, casts `Ward`, intercepts attacks aimed at the Examiner.
   - `OPPORTUNIST`: Targets lowest-HP or `Broken` enemies for kill-secures (`+15%` Gold cut).
   - `MARTYR`: Prioritizes healing/shields; sacrifices own `HP` to cast when `MP == 0`.
2. **`aetheric_body` (Hardware Quirk Modifying YOUR Imprinted Spells):**
   - Examples: *Overclock Sink* (ignores `100%` of Overclocked Stress recoil), *Chain Conductor* (`+1` echo hop on `Water`/`Lightning`), *Heavy Frame* (`-1` Channel Turn on `Pillar`/`Earth`), *Volatile Conduit* (`+20%` crit on `Fire`).
3. **`bond_tier` (`Contracted` -> `Trusted` -> `Loyal`):**
   - Reaching **`Loyal`** reduces Gold cut to **`0%`** and unlocks **Manual Override Toggle** (full JRPG manual control if desired) **without** overwriting `doctrine_ai`.

---

## 6. Mobile Controls: Tactical Signal & Hold-to-Scan Lens Pulse

- **1-Tap Tactical Signal (1 Free Use / Round):** Direct all autonomous Contractors in one tap: **`FOCUS TARGET`**, **`HOLD FOR BREAK`**, or **`COVER EXAMINER`**.
- **Hold-to-Scan (*Uncompiled Lens Pulse*):** Holding a finger for `0.25s` on any 2.5D enemy or ally triggers a crisp corporate-cyan shader pulse showing **1 Break Icon**, **1 Next Intent**, **Active Trojan Status**, and **Elemental Affinities**—zero hover tooltips or screen clutter.
- **`1× / 2×` Combat Speed Toggle:** Located in the top-right thumb zone for snappy mobile pacing.
