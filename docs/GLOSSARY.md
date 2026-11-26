# Mana-Syndicate — Domain Glossary

Canonical Corporate-Occult International English terminology for code, `Resource` schemas, signals, and EGM design specs (`domain-modeling` standard).

| Term | Definition | Code Type / Location | Invariants |
| :--- | :--- | :--- | :--- |
| **Examiner** | Disgraced former Patent Examiner (protagonist) commanding the Mobile Ley-Rail Foundry. | `SaveRunState` / `ContractorData` | `0 HP` triggers Bailout (`Standard`) or Margin Call (`Hardcore`). |
| **Registrar #** | Bureaucratic ID prefix for Syndicate executives, auditors, and regional bosses (e.g., `Registrar #0001`). | `String` | Displayed on dossiers and boss intros, never truncating compact mobile rows. |
| **Uncompiled Lens** | Stolen Registry Relic exposing enemy intents, Break icons, Trojan status, and `PotentialGrade` via `Hold-to-Scan` (`0.38s` / `LENS` button). | Combat/UI Overlay | Zero hover tooltips; `0` Gold cost. |
| **Harmonic Drift** | Per-save 3-Ring Elemental Roulette spun from a shareable `MasterSeed`. | `HarmonicDriftSeed` (`Resource`) | `heresy_element != bubble_element`; deterministic across OS/devices. |
| **Bubble Element** | Save-seeded element hoarded by the Syndicate (`+200%` buy cost, `3×` Patent Royalties). | `StringName` on `HarmonicDriftSeed` | Exactly 1 of 5 Core Elements per save. |
| **Heresy Element** | Save-seeded outlawed element (contraband-only; `0%` boss counter-protocols; adds Audit Heat). | `StringName` on `HarmonicDriftSeed` | Cannot be publicly Patented; `!= bubble_element`. |
| **Aetheric Loom** | Touch-first directed spell circuit board (`Core -> Vessel -> Logic Gates -> Optional Loop`). | `SpellCircuit` (`Resource`) | Front-loaded in Act I Ep 1; includes live 2.5D `Dry Fire` preview. |
| **Aetheric Stress** | `(Complexity / max(1, loom_complexity_cap)) * 100.0`. `<=100.0%` Certified; `(100.0%, 150.0%]` Overclocked; `>150.0%` Uncompilable. | Computed dynamically per caster | Overclocked spells show deterministic Recoil Vector (HP recoil floors at `1 HP`). |
| **IP Disposition** | World-shaping choice per crafted spell: `patented`, `open_source_leak`, or `black_book`. | `StringName` (`ip_status`) | `patented` requires `Stress <= 100.0%`, `Complexity >= 35`, and injects into enemy pool. |
| **Trojan Kill-Switch** | Hidden dormant gate wired into a Patented spell; grants 1-time `0 MP` Force BREAK if an enemy casts it, then voids royalties. | `trojan_armed` / `trojan_consumed` | 1-time trigger per patented blueprint (`+30` Audit Heat on trip). |
| **Doctrine** | Autonomous combat AI policy (`primer`, `detonator`, `breaker`, `bastion`, `opportunist`, `martyr`). | `doctrine_ai: StringName` | Independent of `bond_tier`; `Loyal` never overwrites `doctrine_ai`. |
| **Aetheric Body** | Contractor hardware quirk modifying imprinted Examiner `SpellCircuit`s. | `aetheric_body: StringName` | Modifies circuit behavior (e.g. ignores Stress recoil, `+1` Chain hop). |
| **Brokerage Pool** | Replenishing Tier-2 freelancer pool (`30` active listings) used for squads & Async Sub-Contracts. | `Array[ContractorData]` | Never hits permanent empty-roster soft-lock. |
| **Signature Agent** | Tier-1 named cross-nation specialist (`8–12` total) with 3-Episode arcs & Signature Catalysts. | `is_signature_agent: bool` | Cannot be permanently Liquidated. |
| **Aetheric Saturation** | Regional Waygate farming cap (`0–50%` = 100% yield, `51–85%` = 50%, `86–100%` = Audit Choir Liquidators). | `Dictionary` (`region -> float`) | Prevents infinite Day-1/Act-I farming without calendar penalties. |
| **Clearinghouse Auction** | Turn-based (5-round) end-of-Act bidding war against 4 Nation cartels. | `AuctionEngine` (`RefCounted`) | Zero real-time countdown timers (safe for mobile interruptions). |
| **Formula Zero** | Universal royalty-free spell co-authored with Valen, split into 7 Sovereign Patent Shards. | Act V Quest/Item State | Core narrative & endgame ideological catalyst. |
| **2.5D Spatial Contract** | Locked projection (`PERSPECTIVE` `FOV 35°`, `-25°` pitch), `+X` right / `-Z` into screen, `pixel_size = 0.03125`, `BILLBOARD_FIXED_Y`, `ALPHA_CUT_DISCARD`. | `BattleArena3D` / `CombatantEntity` | Mandatory baseline before building any `.tscn` diorama. |
