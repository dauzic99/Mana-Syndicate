# Goldfish Cold-Review Deficiency Report — Mana-Syndicate Systemic Baseline (`01`–`06` + `GLOSSARY.md`)

> **Review Mode:** Zero-History Cold Audit (EGM Goldfish Protocol)  
> **Total Findings:** **30** (**12 P0**, **13 P1**, **5 P2**) — **All 30 Resolved** across `.agents/specs/01`–`07`, `docs/GLOSSARY.md`, and `06` M1/M2/M3 cutlines.

---

## P0 — Critical (Broken Math, Soft-Locks, Exploits, Unbuildable Contracts)

1. **[P0] Overclocked Stress Formula Contradicts Range, Has Float Gap & Div-by-Zero** — `03-aetheric-loom-magic-system.md:§4`, `04-combat-timeline-and-doctrines.md:§2`
   - **Defect**: Three math breaks in one block: (a) `Aetheric_Stress = (Complexity / Caster.LoomCapacity) * 100.0` has no `LoomCapacity >= 1` guard (`0` causes `INF`/`NaN`). (b) Stress bands define `0%–100%` Certified and `101%–150%` Overclocked, leaving `(100.0, 101.0)` undefined on `float` values (e.g., `Complexity = 121, LoomCapacity = 120` -> `100.83%`). (c) Stated bonus `+25% to +60%` contradicts formula `(Stress - 100) * 1.2%`: at `Stress = 101%`, formula yields **`+1.2%`**, not `+25%`. Furthermore, `MagicDamage` multiplies by `StressBonus` without specifying `1.0 + bonus`, risking `0.60×` damage reduction.
   - **Fix Direction**: Enforce `max(1, Caster.LoomCapacity)`, define half-open bands (`<= 100.0` Certified, `(100.0, 150.0]` Overclocked, `> 150.0` Uncompilable), and lock `StressBonus = 1.0` if `<= 100.0` else `1.25 + ((Stress - 100.0) / 50.0) * 0.35`.

2. **[P0] Damage Formulas Allow Div-by-Zero/Healing and Omit Core Modifiers** — `04-combat-timeline-and-doctrines.md:§2`, `03-aetheric-loom-magic-system.md:§2,§3`
   - **Defect**: (a) `100.0 / (100.0 + Target.Guard * (1.0 - ArmorPierce))` divides by zero (`INF`) if `Magma` melts `Guard` to `-100` (or `ArmorPierce > 1.0` with negative Guard), and outputs negative damage (healing) below `-100`. (b) `MagicDamage` omits `ArmorPierce` (making `Spear`'s `40%` Guard pierce a no-op on spells) and omits `RowMod` (making the `RowMod` note's `Spear`/`Plasma`/`Zone` exceptions dead rules). (c) `PhysicalDamage` omits `LawMod` (breaking `LAW_06` `+25%` damage and `LAW_12` `+35%` basic attacks). (d) Neither formula has a `CritMod` term despite `Volatile Conduit` granting `+20% crit on Fire` (`04:§5`), nor a `max(1, round(...))` floor.
   - **Fix Direction**: Clamp `effective_guard = max(0.0, Target.Guard * (1.0 - clamp(ArmorPierce, 0.0, 1.0)))`, include `RowMod`, `ArmorPierce` (default `0.15` for base magic, `0.40` for `Spear`), `LawMod`, and `CritMod` in both formulas, and clamp non-`Void` damage to `max(1, round(raw))`.

3. **[P0] CTB Timeline Collision Is Mathematically Unreachable & Enables Infinite Stunlock/Shard Farming** — `04-combat-timeline-and-doctrines.md:§3`, `02-harmonic-drift-roulette.md:§2`
   - **Defect**: (a) `ActionValue = BaseDelay / (1.0 + Speed / 100.0)` divides by zero/negative if `Speed <= -100` (e.g., stacked Ice/Chill slows). (b) Timeline Collision requires shoving an enemy's float AV "directly onto" an adjacent enemy's float AV. Counterexample (`BaseDelay = 100`): Enemy A (`Speed = 20`, `AV = 83.33`) and Enemy B (`Speed = 50`, `AV = 66.67`) pushed `+25` by `Chrono-Vector` moves B to `91.67 != 83.33`, jumping cleanly past A with zero collision. (c) Collision triggers `BREAK` (`+40 AV` push + `2.0×` vuln + `1` Shard drop on elites/bosses) with no channeling requirement and no per-fight drop cap -> infinite stunlock + infinite Shard/Catalyst farming in one battle.
   - **Fix Direction**: Clamp `Speed >= -50` (floor denom at `0.5`); define Timeline Collision as crossing or landing within `<= 5.0` AV of another enemy's AV during a push/pull; add diminishing `+AV` push (`+40 -> +20 -> +0` until next completed turn), and cap Break loot drops to `1` per enemy per battle.

4. **[P0] Negative Commodity Prices (`LAW_08`) & Risk-Free Short-Selling Infinite Gold Exploit** — `02-harmonic-drift-roulette.md:§3,§4`, `03-aetheric-loom-magic-system.md:§5`, `05-economy-exchange-and-waygates.md:§1`
   - **Defect**: (a) `LAW_08 Frozen Ledger` swings commodity prices `±150%`. A `-150%` swing turns price `P = 100G` into **`-50G`** (buying pays the player infinite Gold). (b) `The Exchange` allows short-selling commodities (`05:§1`, `02:§3`) with zero margin/collateral cap, zero borrow fee, and zero lockout against player-caused crashes: player can short-sell maximum volume immediately before choosing `OPEN_SOURCE_LEAK` (`-40%` regional prices, `03:§5`), guaranteeing deterministic risk-free infinite Gold.
   - **Fix Direction**: Replace `±150%` with multiplicative bounds (`0.4×` to `2.5×`, hard floor `>= 10%` of base price); cut short-selling in V1.

5. **[P0] Uncapped Patent Spam & `TrojanKillSwitch` Auto-Break Boss Exploit** — `03-aetheric-loom-magic-system.md:§3,§5`, `01-game-loop-and-flows.md:§2`
   - **Defect**: Patenting (`Stress <= 100%`) has no slot cap, no filing fee, and no deduplication rule. A player can weave 50 identical cheap 1-node `BubbleElement + Bolt` circuits, Patent all 50 for `50 × 3.0×` Act Royalties, and simultaneously dilute the enemy AI pool with weak 1-node Bolts. Worse, in Act IV–V, arming Patented spells with `TrojanKillSwitch` causes Act V bosses (which explicitly deploy your most-used Patented spells, `01:§2`) to trigger instant `0 MP` Auto-Breaks against themselves repeatedly.
   - **Fix Direction**: Cap active Patents (`1/Act`, max `5` total), require filing fee + `Complexity >= 35`, define `TrojanKillSwitch` as **1-time trigger per spell blueprint** (permanently voids that spell's Patent royalties + adds `+30` Audit Heat once tripped), and ensure enemy AI licenses only the top-3 highest-Complexity Patented circuits.

6. **[P0] Waygate Saturation Bypassed by Infinite `0%` Ep 1–2 Bounties & Unpriced Purge** — `05-economy-exchange-and-waygates.md:§2,§5`
   - **Defect**: `05:§5` keeps Episode 1–2 Brokerage bounties permanently at `0%` Saturation (`100%` yield, `0` Audit Heat), recreating the exact infinite Day-1 Gold/XP/Bond-tier grind that Saturation was designed to eliminate. Additionally, `Leyline Purge` (`05:§2`) resets Saturation for a fee with no formula or per-Episode escalation: if `PurgeFee < GoldPer50PctSaturation`, players buy Purges infinitely in Act I.
   - **Fix Direction**: Cap `0%` Safe Baseline Contracts to trigger **only when liquid Gold `< BailoutThreshold`**, strip XP/Bond/Fracture rewards from emergency contracts (Gold-only floor), and make `Leyline Purge` scale exponentially per Episode (`200G * 2^purges_this_episode`, hard cap `1/Episode`, `+15` Audit Heat).

7. **[P0] Master State Machine Breaks Atomic Resume, Episode Loop & Act Boss Transitions** — `01-game-loop-and-flows.md:§1,§3,§4`
   - **Defect**: (a) `TITLE --> FOUNDRY_HUB : Continue` contradicts `01:§4` (which requires resuming directly into the exact `TIMELINE_COMBAT` turn, `DIORAMA_RAID` room, or `CLEARINGHOUSE_AUCTION` round). (b) `IP_DISPOSITION` is only reachable after `CLEARINGHOUSE_AUCTION` and unconditionally enters `ACT_SETTLEMENT` ("Advance to Next Continental Act"), leaving **no Episode loop** for the 4–5 Episodes per Act (`01:§3`), **no edge** from `CLEARINGHOUSE_AUCTION` to `TIMELINE_COMBAT` for the Act Boss, and **no state** for Black Ledger Registry Heists (`01:§3`, `05:§1`). (c) `GAME_OVER` and `EPILOGUE` are terminal traps with no return edge to `TITLE`.
   - **Fix Direction**: Route `TITLE -> RESUME_ROUTER -> {FOUNDRY_HUB | DIORAMA_RAID | TIMELINE_COMBAT | CLEARINGHOUSE_AUCTION | IP_DISPOSITION}`; separate `EPISODE_SETTLEMENT` (`ep < max_ep -> FOUNDRY_HUB`) from `ACT_SETTLEMENT`; add explicit `AUCTION -> TIMELINE_COMBAT (Boss) -> IP_DISPOSITION`, `FOUNDRY_HUB -> BLACK_LEDGER_HEIST -> TIMELINE_COMBAT`, and `{GAME_OVER, EPILOGUE} -> TITLE` transitions.

8. **[P0] `SaveRunState` Cannot Resume Mid-Combat/Mid-Auction & `.res` Save Format Risks RCE/Corruption** — `06-godot-25d-mobile-architecture.md:§3,§4`, `01-game-loop-and-flows.md:§4`, `02-harmonic-drift-roulette.md:§1`
   - **Defect**: (a) `SaveRunState` (`06:§3`) omits `active_state`, `episode_index`, `difficulty_mode`, `credit_line_debt`, `party_roster`, `brokerage_pool`, `crafted_circuits`, `active_subcontracts`, `active_battle_state`, `active_raid_state`, `active_auction_state`, `rng_states` (including missing `combat_rng`), and `schema_version`—making atomic OS-kill resume impossible as specified. (b) `SaveManager` (`06:§4`) writes `user://saves/slot_X.res` via `ResourceSaver`: Godot `.res` files allow arbitrary GDScript execution on load (RCE if shared) and break silently when `Resource` properties change across patches.
   - **Fix Direction**: Serialize saves to versioned JSON (`user://saves/slot_X.json` with `schema_version: int`, `sha256` integrity hash, atomic `.tmp` + `.bak` + `rename`), and embed `active_state`, `TimelineBattleState` snapshot, and all 6 RNG `uint64` states (`origin`, `market`, `law`, `brokerage`, `leyline`, `combat`).

9. **[P0] Missing `max_mp`/`current_mp` on `ContractorData` & Shared `SpellCircuit.stress_pct` Corruption** — `06-godot-25d-mobile-architecture.md:§3`, `03-aetheric-loom-magic-system.md:§4`, `04-combat-timeline-and-doctrines.md:§2,§5`
   - **Defect**: (a) `ContractorData` (`06:§3`) has no `max_mp` or `current_mp` (nor `current_hp`, `origin_element`, `row`, `grimoire_slots`, `xp`/`level`), breaking `MP_Cost`, `TurnMPRegen`, `MARTYR` (`MP == 0`), and `LAW_11` (`0 MP`). (b) `stress_pct: float` is stored directly on `SpellCircuit`, yet `Aetheric_Stress = (Complexity / Caster.LoomCapacity) * 100.0` is caster-dependent! If Examiner (`LoomCapacity = 100`) crafts a `Complexity = 100` (`100%` Certified) spell and imprints it onto a Contractor (`loom_capacity = 60`), effective stress is **`166.7%` (Uncompilable)**, and mutating `stress_pct` on the shared `Resource` corrupts every other unit holding that circuit.
   - **Fix Direction**: Add `max_mp`, `current_mp`, `current_hp`, `origin_element`, `row`, `grimoire_slots` to `ContractorData`; remove cached `stress_pct` from `SpellCircuit` and compute `circuit.get_stress_for(caster.loom_complexity_cap)` purely at query/imprint time.

10. **[P0] Bankruptcy Soft-Lock (`1G–499G`) & `>100%` Combined Squad Cut + Debt Spiral** — `05-economy-exchange-and-waygates.md:§5`, `04-combat-timeline-and-doctrines.md:§5`, `02-harmonic-drift-roulette.md:§5`
    - **Defect**: (a) `Syndicate Credit Line` (`05:§5`) only triggers "if liquid Gold hits `0G`"—a player with `50G` facing a `500G` mandatory fee or Infirmary bailout is soft-locked; it also has no debt cap. (b) Party size is undefined (`04`), and every Contractor takes `contract_cut_pct` (`OPPORTUNIST` adds `+15%`). A 4-contractor squad averaging `25%` cut (`100%` total) plus `20%` Credit Line repayment (`120%` deduction) leaves the player with `<= 0G` net income forever.
    - **Fix Direction**: Trigger Credit Line whenever `liquid_gold < required_fee` (auto-borrowing only the shortfall, capped at `3×` Act base fee); lock party size explicitly (`Examiner + 3 Contractors = 4`); cap total squad cut strictly at `<= 50%` and deduct `20%` Credit Line repayment from net post-cut earnings (`>= 1G` floor).

11. **[P0] `SpellCircuit` Data Schema Cannot Represent Forked `Splitter` Graphs or Multi-Element Fusions** — `06-godot-25d-mobile-architecture.md:§3`, `03-aetheric-loom-magic-system.md:§1`
    - **Defect**: `03:§1` defines a directed graph with Act II–III `Splitter` forks and `2 Core Elements` fusions, yet `06:§3` defines `SpellCircuit` as a flat linear record (`core_element`, `fusion_element`, single `vessel_id`, flat `logic_gates: Array[StringName]`). A single `vessel_id` and flat gate list cannot encode which branch of a `Splitter` owns which Vessel or Gate, nor distinguish `fusion_element` as 2nd input element vs derived Fusion ID.
    - **Fix Direction**: Cut `Splitter` from V1 and lock linear slots: `core_elements: Array[StringName]` (max 2, auto-resolving Fusion/Mythic), `vessel_id`, `logic_gates: Array[StringName]`, `loop_count`.

12. **[P0] `LoomCapacity` Overloaded as Both Node Count (`4/6/9`) and Complexity Budget** — `03-aetheric-loom-magic-system.md:§1,§4`, `04-combat-timeline-and-doctrines.md:§1`, `06-godot-25d-mobile-architecture.md:§3`
    - **Defect**: `03:§1` defines `Loom Capacity` as Act-unlocked node slots (`4`, `6`, `9` Nodes—and Act I's `4 Nodes` row only lists `1 Core + 1 Vessel + 1 Gate = 3` nodes!). Meanwhile `03:§4`, `04:§1`, and `06:§3` use `LoomCapacity` as a per-character Complexity denominator (`LoopCount * 15` alone would produce `375%` Stress if divided by `4`).
    - **Fix Direction**: Split into `loom_node_slots: int` (`4 / 6 / 9`, fixing Act I to `1 Core + 1 Vessel + 2 Gate/Catalyst slots`) and `loom_complexity_cap: int` (per-unit stat, `60` base scaling to `150`).

---

## P1 — High (Cross-Spec Contradictions, Missing Constants, Hardware Traps)

13. **[P1] Auction 5-Round Math Cannot Reach `MaxBid`, Undefined Tie-Break & Missing `Nation.PrimaryElement`** — `05-economy-exchange-and-waygates.md:§3,§4`
    - **Defect**: (a) Under `LAW_06` (`-35%` starting bid = `650`), 5 rounds of max `+25%` increments reach only `650 * 1.25^5 = 1983.6` (`47%` below `MaxBid = 3780`). (b) Turn order within a round and tie-breaking when 2+ Cartels remain at Round 5 are undefined. (c) `Nation.PrimaryElement` is never mapped for the 4 Nations, and `Lot.Element` is undefined for non-elemental lots.
    - **Fix Direction**: Allow `+50%` jump-bids + Round 5 sealed final bid, tie-break by highest remaining `MaxBid - CurrentBid` then `leyline_rng`, and publish the 4-Nation `PrimaryElement` table (`&""` = `1.0`).

14. **[P1] Zero-MP, Negative Channel, & Infinite Echo Recursion Exploits in Spell Synthesis** — `03-aetheric-loom-magic-system.md:§3,§4`, `04-combat-timeline-and-doctrines.md:§5`, `02-harmonic-drift-roulette.md:§2,§4`
    - **Defect**: (a) `MP_Cost` has no `>= 1` clamp and no duplicate-gate ban. (b) `Heavy Frame` (`-1` Channel Turn) applied to `0`-channel `Earth Bolt` yields `-1` Channel Turns. (c) `Echo` + `Tidal Conduit` + `LAW_07` + `Chain Conductor` + `Feedback Loop` have no recursion guard.
    - **Fix Direction**: Enforce `max(1, round(...))` on `MP_Cost`, `max(0, ...)` on `Channel_Turns` (`Heavy Frame` applies only when `BaseChannel >= 1`), ban duplicate identical Logic Gates per circuit, and enforce recursion `depth <= 1`.

15. **[P1] Missing Core Numeric Tables Block GUT Implementation** — `03-aetheric-loom-magic-system.md:§4`, `04-combat-timeline-and-doctrines.md:§2,§3,§5`, `05-economy-exchange-and-waygates.md:§2`
    - **Defect**: Required constants (`ElementCost`, `VesselCost`, `GateCosts`, `BaseMP`, `ElementMod`, `BaseDelay`, `TurnMPRegen` cap, `Audit Heat` thresholds, `Saturation` gain, `Party Size`, etc.) are missing from `01`–`06`.
    - **Fix Direction**: Add `.agents/specs/07-balance-tables-and-constants.md`.

16. **[P1] Three Disjoint Logic Gate Vocabularies Across Specs** — `02-harmonic-drift-roulette.md:§2`, `03-aetheric-loom-magic-system.md:§2,§3`, `05-economy-exchange-and-waygates.md:§3`
    - **Defect**: `02:§2` (`IF`, `COPY`, `INVERT`, `BRIDGE`), `03:§3` (`Echo`, `Leech`, `Shift`, `Condensation`, `ConditionGate`, `TrojanKillSwitch`), and `05:§3` (`RECURSION`, `TIMELINE_SWAP`) conflict.
    - **Fix Direction**: Consolidate into canonical `LogicGateId` enum (`echo`, `leech`, `shift`, `condensation`, `condition_gate`, `trojan_kill_switch`) + `feedback_loop`.

17. **[P1] Cross-Spec Enum & Terminology Drift** — `06:§3`, `03:§5`, `04:§4,§5`, `05:§1,§4`, `02:§4`, `docs/GLOSSARY.md`
    - **Defect**: `OPEN_SOURCE_LEAK` vs `&"leaked"`; missing `suspended` and `subcontract` contractor statuses; `Vault` overloaded as Row + Vessel; undefined `Chill` stack in `LAW_08`; un-gated `TrojanKillSwitch` in `05:§1`.
    - **Fix Direction**: Reconcile all enums to `snake_case` `StringName`s across specs and `GLOSSARY.md`.

18. **[P1] Redundant/Conflicting Earth Pillar Rules Across Origin, Element & Vessel** — `02:§2`, `03:§2,§3`
    - **Defect**: `Earth` Element, `Pillar` Vessel, and `Tectonic Architect` Origin all redundantly spawn Pillars with contradictory lifespans (`25% MaxHP` vs `3` turns).
    - **Fix Direction**: `Earth` Element = Fortify / Guard shred + Wall-Slam amp; `Pillar` Vessel = 2.5D Construct (`25% MaxHP`, `3` turns, max `2`/side); `Tectonic Architect` = non-`Pillar` Earth Vessels spawn mini-Constructs (`15% MaxHP`) + Prism refraction.

19. **[P1] `LAW_11` Overdraft Alpha-Strike Exploit, `MARTYR` Conflict & Self-Damage Lethality Ambiguity** — `02:§2,§4`, `03:§4`, `04:§5`
    - **Defect**: `LAW_11` post-cast `+AV` allows `0 MP` 100-MP alpha strikes; `MARTYR` HP:MP ratio and priority vs `LAW_11` are missing; self-damage KO rules are undefined.
    - **Fix Direction**: Apply `LAW_11` delay **before execution** (breakable Channel, capped `<= MaxMP`), resolve `MARTYR` first (`2% MaxHP per 1 MP`), ban self-cost casts if `HP <= cost`, floor Overclock Recoil at `1 HP`.

20. **[P1] Godot 3 `BakedLightmap` Violation & `LightmapGI` Conflict with Dynamic 12-Law Tints on `GLES3`** — `06:§1,§4`, `02:§4`, `GOLDEN_STANDARD.md:§4.2`
    - **Defect**: `06:§4` names Godot 3's removed `BakedLightmap`; static `LightmapGI` clashes with 12 dynamic seed sky tints.
    - **Fix Direction**: Use `WorldEnvironment` (runtime tint per `active_law_id`) + 1 unshadowed `DirectionalLight3D` + `Decal`/`Sprite3D` blob shadows.

21. **[P1] Loom `SubViewport` Missing `own_world_3d`, Incompatible with `UPDATE_ONCE`, & Dual-3D Mobile Bottleneck** — `06:§1`, `03:§1`
    - **Defect**: Missing `own_world_3d = true`, `UPDATE_ONCE` freezes Dry-Fire playback, and dual 3D viewports double GPU bandwidth on low-tier Android.
    - **Fix Direction**: Pause background Foundry viewport (or reuse main 3D mannequin bay), enforce `own_world_3d = true`, `640×360`, `MSAA_DISABLED`, and toggle `UPDATE_ONCE` <-> `UPDATE_WHEN_VISIBLE` during Dry-Fire.

22. **[P1] Cross-Platform `MasterSeed` Determinism Lacks Hash Algorithm & Combat RNG Persistence** — `02:§1,§5`, `06:§3`
    - **Defect**: GDScript `hash()` is 32-bit and unsafe; `combat_rng` missing.
    - **Fix Direction**: Lock `SHA-256(master_seed.strip_edges().to_upper() + ":" + stream_name)` -> first 8 bytes little-endian `uint64`, ban `Dictionary` iteration in RNG loops, add `combat_rng`.

23. **[P1] Missing Locked 2.5D Coordinate & Camera Convention (Violates Golden Standard)** — `06:§1,§4`, `docs/GLOSSARY.md`, `GOLDEN_STANDARD.md:§4.5`
    - **Defect**: Projection, FOV, pitch, axes, `pixel_size`, billboard mode, and alpha cut are unspecified.
    - **Fix Direction**: Lock 6-line 2.5D Spatial Contract in `06:§1` & `GLOSSARY.md`.

24. **[P1] `Channel_Turns` vs Continuous CTB `ActionValue` Mapping & Non-Channeling BREAK Contradiction** — `03:§2,§4`, `04:§3`
    - **Defect**: `Channel_Turns` lacks AV mapping, and `Void`/`Trojan`/`Collision` Break non-channelers while `04:§3` restricts Break to Channelers.
    - **Fix Direction**: Lock `ChannelAV = Channel_Turns * 75.0` (independent of `Speed`); split `Channel-Interrupt BREAK` vs `Force BREAK`.

25. **[P1] Hardcore Audit Save-Scum & Roster-Wipe Edge Cases** — `01:§1,§4,§5`, `03:§4`, `05:§2`
    - **Defect**: Saving post-animation allows force-kill rerolling; Tactical Retreat works on Bosses/Liquidators; roster wipe can leave `0` Tier-2 contractors.
    - **Fix Direction**: Commit turn + `combat_rng` before animations; checkpoint Fracture-Mutation before modal; forbid Retreat on Bosses/Liquidators; allow solo Examiner and guarantee `>= 2` `0G`-upfront listings if squad `< 2`.

---

## P2 — Medium (Mobile UX Friction, Hardware Polish, Milestone 1 Scope Bloat)

26. **[P2] `30 FPS` Cap vs `60 Hz` Physics Ticks Causes 2.5D Movement Micro-Stutter** — `06:§1,§4` -> Enable `physics/common/physics_interpolation = true` (or `30 Hz` physics ticks).
27. **[P2] Synchronous Disk Auto-Save on Every `2×` Combat Turn Causes Mobile Flash Hitches** — `01:§4`, `04:§6`, `06:§4` -> Async `WorkerThreadPool` atomic write + synchronous `NOTIFICATION_APPLICATION_PAUSED` flush.
28. **[P2] `Hold-to-Scan` (`0.25s`) Tap-Collision, Input-Location Conflict & `48dp` Physical Sizing Error** — `04:§6`, `06:§1,§2` -> Unify `0.38s` (`<= 14px` slop) hold or Right-Thumb `LENS` button + `>= 80×80` virtual px minimum targets at `720p`.
29. **[P2] `Chrono-Vector` Violates `2`-Tap Combat Depth & Beat 1 Overloads `2–4 Min` Mobile Budget** — `02:§2`, `01:§3`, `06:§2` -> Lock `Chrono-Vector` mode in Loom; progressively unlock Beat 1 Hub tabs across Act I Ep 1–3.
30. **[P2] Unscoped Milestone 1 Cutline Bundles Act IV–V Systems & High-Cost Finance/Diorama Bloat** — `06:§5`, `02:§4`, `05:§1`, `03:§5` -> Partition `06:§5` into M1 (Act I Core Slice), M2 (Fusions/Exchange/Auctions), and M3 (Mythics/Trojans/12 Laws).

---

## Resolution Ledger

| Finding | Patched File(s) | V1 Design Decision / Fix Summary |
| :--- | :--- | :--- |
| **#1, #9, #12, #14, #16, #18** | `03`, `04`, `06`, `07`, `GLOSSARY.md` | Split `loom_node_slots` vs `loom_complexity_cap`; dynamic Stress (`<=100.0`, `(100.0, 150.0]`, `>150.0`); `MP_Cost >= 1`; canonical `LogicGateId`s; separated `Earth` vs `Pillar` vs `Tectonic Architect`. |
| **#2, #3, #19, #24** | `02`, `03`, `04`, `07` | Guard clamp `>= 0`; full modifiers in Physical & Magic formulas; `Speed >= -50`; Collision `<= 5.0 AV` + diminishing Break push + 1 drop/enemy; `ChannelAV = 75 * turns`; `LAW_11` pre-cast + `MARTYR` `2% HP/MP`. |
| **#4, #5, #6, #10, #13, #15** | `02`, `03`, `05`, `07` | **Cut short-selling in V1**; `LAW_08` `0.4×–2.5×`; Patent cap `1/Act` (max 5) + 1-time `TrojanKillSwitch`; Purge `200G * 2^n`; Credit Line shortfall borrow + `<=50%` squad cut; `+50%` jump-bid + sealed Round 5; full `07` balance tables. |
| **#7, #8, #22, #25, #27** | `01`, `02`, `06` | `RESUME_ROUTER`, `EPISODE_SETTLEMENT`, `BLACK_LEDGER_HEIST`; versioned JSON (`slot_X.json`) + `WorkerThreadPool` + `NOTIFICATION_APPLICATION_PAUSED`; `SHA-256` RNG streams (`+ combat_rng`); pre-animation commit. |
| **#11, #17, #20, #21, #23, #26, #28, #29, #30** | `01`–`06`, `GLOSSARY.md` | **Cut `Splitter` in V1**; `WorldEnvironment` replacing `BakedLightmap`/`LightmapGI`; locked 2.5D Spatial Contract; `own_world_3d` SubViewport; `>= 80×80` virtual px + `0.38s` Lens; `Chrono-Vector` locked in Loom; M1/M2/M3 GUT split. |
