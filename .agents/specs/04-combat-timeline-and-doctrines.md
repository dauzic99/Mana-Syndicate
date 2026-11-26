# 04 — Combat Engine, CTB Timeline & Contractor Doctrines

## 1. Four Core Combat Stats (Mobile-Legible)

Arbitrary economic stat tie-ins (e.g., DEF = mining clicks) are removed. Every combatant uses **4 clean stats** plus two metadata fields:

| Stat / Field | Role |
| :--- | :--- |
| **`HP` (`max_hp`)** | Survivability pool; determines Trauma/Overkill threshold. |
| **`Power` (`power`)** | Unified offensive scaling for both Physical strikes and Aetheric Loom circuits. |
| **`Guard` (`guard`)** | Unified Physical + Magic damage mitigation. |
| **`Speed` (`speed`)** | CTB Turn Timeline velocity (`ActionValue` calculation). **Never** reduces `Channel_Turns` to `0`. |
| **`loom_complexity_cap`** | Examiner & Contractor Complexity ceiling before `Aetheric_Stress` enters `Overclocked`. |
| **`max_mp` / `current_mp`** | Mana resource pool for `SpellCircuit` casting (`TurnMPRegen` capped at `12`). |
| **`PotentialGrade`** | `D`, `C`, `B`, `A`, `S` (replaces raw `1.85x` floats on mobile UI; maps to growth multipliers `0.85×`–`2.20×`). |

---

## 2. Explicit Damage, Mitigation & MP Formulas

Both Physical and Magic formulas are explicitly defined (fixing the missing Physical DEF bug):

```text
EffectiveGuard = max(0.0, Target.guard * (1.0 - clamp(ArmorPierce, 0.0, 1.0)))

PhysicalDamage = max(1, round((Attacker.power * SkillMult)
                 * (100.0 / (100.0 + EffectiveGuard))
                 * RowMod * BreakMod * ElementMod * LawMod * CritMod))

MagicDamage    = 0 if Void else max(1, round((Attacker.power * CircuitPower * StressBonus)
                 * (100.0 / (100.0 + EffectiveGuard))
                 * RowMod * BreakMod * ElementMod * LawMod * CritMod))

TurnMPRegen    = min(12, 4 + ReactionBonus)   // Zero out-of-combat heal/regen stall
```
- `ArmorPierce`: `0.15` base for magic (`0.40` for `Spear`, `0.0` standard melee).
- `BreakMod`: `2.0` (`2.5` under `LAW_05 Volatile Resonance`) when target is in **BREAK** state; otherwise `1.0`.
- `RowMod`: `1.0` standard; `0.75` if ranged strike hits protected `Vault` behind an active `Vanguard` or `Earth Pillar` (unless `Spear` / `Plasma` / `Zone`).
- `CritMod`: `1.5` on critical hit, otherwise `1.0`.

---

## 3. CTB Turn Timeline, Channeling & Collision Breaks

- **Action Value (`AV`) Formula:** `ActionValue = 100.0 / (1.0 + max(-50.0, Speed) / 100.0)`.
- **Visible Top-Center Timeline:** Shows the next `8` unit turns, including **Channeling Telegraph Markers** (`ChannelAV = Channel_Turns * 75.0`, strictly independent of `Speed`).
- **Two BREAK Types:**
  - **Channel-Interrupt BREAK:** Hitting a Channeling target with a **Counter-Element** or `Spear`.
  - **Force BREAK:** `Void`, 1-time `trojan_kill_switch`, or **Timeline Collision** (works on any enemy, even if not Channeling).
  - **BREAK Effects:**
    1. Cancels any channeled spell immediately.
    2. Pushes the target's Timeline marker with diminishing returns (`+40 -> +20 -> +0` AV until target completes a turn).
    3. Applies **`2.0×` Vulnerability** (`2.5×` under `LAW_05`) until the target's next completed turn.
    4. Drops `1` **Logic Gate Shard** or **Catalyst Fragment** on elite/boss Breaks (hard cap `1` drop per enemy per battle).
- **Timeline Collision:** Using `Wind` (`Chrono-Vector` / `Gale`) to shove/pull an enemy's AV marker across or within **`<= 5.0` AV** of another enemy's marker deals collision damage and triggers **Force BREAK** on both.

---

## 4. Vanguard & Vault 2.5D Rows

- **Vanguard (Front Row):** Intercepts 100% of single-target melee attacks. Vulnerable to `Zone` sweeps and `Shift` displacement.
- **Vault (Back Row):** Protected from melee targeting while at least 1 ally or `Earth Pillar` stands in Vanguard.
- **2.5D Constructs:** `Earth` Pillars occupy a Vanguard slot, absorb melee hits, and deal bonus **Wall-Slam** damage when `Wind` shoves an enemy backward.

---

## 5. Two-Tier Roster & 3-Axis Contractor Schema

Resolving the story-vs-permadeath conflict with **2 clean tiers** and a locked **Party Size of `4`** (`Examiner + up to 3 Contractors`; combined squad `contract_cut_pct` capped at `<= 50%`):

| Tier | Roster Rule | Permanence & Statuses |
| :--- | :--- | :--- |
| **Tier 1: Signature Agents (8–12)** | Named cross-nation specialists (e.g., *Varek, Dr. Silas, Zafira, Oros*). 3-Episode personal arcs unlock **Unique Signature Catalysts**. | **Cannot permanently die** (`idle`, `active`, `trauma`, `suspended`, `subcontract`). |
| **Tier 2: Brokerage Pool (Procedural)** | Continuously replenished freelancer pool (`30` active listings, refreshed each Episode). Imprint Examiner's custom `SpellCircuit`s into their **2–4 Grimoire Slots**. | **Trauma** by default; **Voluntary Liquidation** (*Extract Relic Node*) or automatic on Hardcore Audit (`liquidated`). |

### Clean 3-Axis Contractor Schema (No Single-ID Overload)
Every party member has **3 independent typed fields**:

1. **`doctrine_ai` (6 Always-Useful Deterministic AI Policies):**
   - `PRIMER`: Prioritizes applying elemental states (*Soaked*, *Ember*, *Earth Pillar*).
   - `DETONATOR`: Targets primed enemies to trigger elemental chains (`Lightning` on *Soaked*, etc.).
   - `BREAKER`: Holds high-`AV` / `Spear` / counter-element casts for **Channeling** enemies; uses basic attack otherwise (never stands AFK).
   - `BASTION`: Guards `Vanguard`, casts `Ward`, intercepts attacks aimed at the Examiner.
   - `OPPORTUNIST`: Targets lowest-HP or `Broken` enemies for kill-secures (`+15%` Gold cut).
   - `MARTYR`: Prioritizes healing/shields; sacrifices own `HP` (`2% MaxHP per 1 MP` deficit; cannot cast if `HP <= cost`) to cast when `MP == 0` (resolves before `LAW_11`).
2. **`aetheric_body` (Hardware Quirk Modifying YOUR Imprinted Spells):**
   - Examples: *Overclock Sink* (ignores `100%` of Overclocked Stress recoil), *Chain Conductor* (`+1` echo hop on `Water`/`Lightning`, `depth <= 1`), *Heavy Frame* (`-1` Channel Turn on `Pillar`/`Earth` when `BaseChannel >= 1`, floored at `0`), *Volatile Conduit* (`+20%` crit on `Fire`).
3. **`bond_tier` (`Contracted` -> `Trusted` -> `Loyal`):**
   - Reaching **`Loyal`** reduces Gold cut to **`0%`** and unlocks **Manual Override Toggle** (full JRPG manual control if desired) **without** overwriting `doctrine_ai`.

---

## 6. Mobile Controls: Tactical Signal & Hold-to-Scan Lens Pulse

- **1-Tap Tactical Signal (1 Free Use / Round):** Direct all autonomous Contractors in one tap: **`FOCUS TARGET`**, **`HOLD FOR BREAK`**, or **`COVER EXAMINER`**.
- **Hold-to-Scan (*Uncompiled Lens Pulse*):** Holding a finger for `0.38s` (`<= 14px` slop) on any `>= 80×80` virtual px target OR holding the Right-Thumb **`LENS`** button triggers a crisp corporate-cyan shader pulse showing **1 Break Icon**, **1 Next Intent**, **Active Trojan Status**, and **Elemental Affinities**—zero hover tooltips or screen clutter.
- **`1× / 2×` Combat Speed Toggle:** Located in the top-right thumb zone for snappy mobile pacing.
