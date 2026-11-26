# Mana-Syndicate — Domain Glossary

Canonical Corporate-Occult International English terminology for code, `Resource` schemas, signals, and EGM design specs (`domain-modeling` standard).

| Term | Definition | Code Type / Location | Invariants |
| :--- | :--- | :--- | :--- |
| **Examiner** | Disgraced former Patent Examiner (protagonist) commanding the Mobile Ley-Rail Foundry. | `SaveRunState` / `ContractorData` | `0 HP` triggers Bailout (`Standard`) or Margin Call (`Hardcore`). |
| **Registrar #** | Bureaucratic ID prefix for Syndicate executives, auditors, and regional bosses (e.g., `Registrar #0001`). | `String` | Displayed on dossiers and boss intros, never truncating compact mobile rows. |
| **Uncompiled Lens** | Stolen Registry Relic exposing enemy intents, Break icons, Trojan status, and `PotentialGrade` via `Hold-to-Scan` (`0.25s`). | Combat/UI Overlay | Zero hover tooltips; `0` Gold cost. |
| **Harmonic Drift** | Per-save 3-Ring Elemental Roulette spun from a shareable `MasterSeed`. | `HarmonicDriftSeed` (`Resource`) | `heresy_element != bubble_element`; deterministic across OS/devices. |
| **Bubble Element** | Save-seeded element hoarded by the Syndicate (`+200%` buy cost, `3×` Patent Royalties). | `StringName` on `HarmonicDriftSeed` | Exactly 1 of 5 Core Elements per save. |
| **Heresy Element** | Save-seeded outlawed element (contraband-only; `0%` boss counter-protocols; adds Audit Heat). | `StringName` on `HarmonicDriftSeed` | Cannot be publicly Patented; `!= bubble_element`. |
| **Aetheric Loom** | Touch-first directed spell circuit board (`Core -> Vessel -> Logic Gates -> Optional Loop`). | `SpellCircuit` (`Resource`) | Front-loaded in Act I Ep 1; includes live 2.5D `Dry Fire` preview. |
| **Aetheric Stress** | `(Complexity / LoomCapacity) * 100`. `0–100%` Certified; `101–150%` Overclocked; `>150%` Uncompilable. | `float` on `SpellCircuit` | Overclocked spells always show deterministic Recoil Vector. |
| **IP Disposition** | World-shaping choice per crafted spell: `PATENTED`, `OPEN_SOURCE_LEAK`, or `BLACK_BOOK`. | `StringName` (`ip_status`) | `PATENTED` requires `Stress <= 100%` and injects spell into enemy pool. |
| **Trojan Kill-Switch** | Hidden dormant gate wired into a Patented spell; grants instant `0 MP` Auto-Break if an enemy casts it. | `trojan_armed: bool` | Consumed/triggered against enemy casts of that patented blueprint. |
| **Doctrine** | Autonomous combat AI policy (`primer`, `detonator`, `breaker`, `bastion`, `opportunist`, `martyr`). | `doctrine_ai: StringName` | Independent of `bond_tier`; `Loyal` never overwrites `doctrine_ai`. |
| **Aetheric Body** | Contractor hardware quirk modifying imprinted Examiner `SpellCircuit`s. | `aetheric_body: StringName` | Modifies circuit behavior (e.g. ignores Stress recoil, `+1` Chain hop). |
| **Brokerage Pool** | Replenishing Tier-2 freelancer pool (`30` active listings) used for squads & Async Sub-Contracts. | `Array[ContractorData]` | Never hits permanent empty-roster soft-lock. |
| **Signature Agent** | Tier-1 named cross-nation specialist (`8–12` total) with 3-Episode arcs & Signature Catalysts. | `is_signature_agent: bool` | Cannot be permanently Liquidated. |
| **Aetheric Saturation** | Regional Waygate farming cap (`0–50%` = 100% yield, `51–85%` = 50%, `86–100%` = Audit Choir Liquidators). | `Dictionary` (`region -> float`) | Prevents infinite Day-1/Act-I farming without calendar penalties. |
| **Clearinghouse Auction** | Turn-based (5-round) end-of-Act bidding war against 4 Nation cartels. | `AuctionEngine` (`RefCounted`) | Zero real-time countdown timers (safe for mobile interruptions). |
| **Formula Zero** | Universal royalty-free spell co-authored with Valen, split into 7 Sovereign Patent Shards. | Act V Quest/Item State | Core narrative & endgame ideological catalyst. |
