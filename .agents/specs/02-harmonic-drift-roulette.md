# 02 — Per-Save Elemental Roulette (*The Harmonic Drift*)

## 1. Master Save Seed Architecture

Every New Game spins a shareable **Master Seed** (e.g., `MS-7F4A-9921`). To guarantee deterministic replayability without UI actions polluting world generation, `HarmonicDriftSeed` splits the Master Seed into **5 isolated `RandomNumberGenerator` sub-streams**:

| Sub-Stream | Deterministic Responsibility |
| :--- | :--- |
| `origin_rng` | Ring 1: Examiner's Origin Loom Architecture |
| `market_rng` | Ring 2: `BubbleElement`, `HeresyElement`, and baseline commodity curves |
| `law_rng` | Ring 3: Active Global Physical Law Mutator + 2.5D skybox/Ley-Spire palette |
| `brokerage_rng` | Initial 30-contractor Brokerage Pool (`PotentialGrade`, `Doctrine`, `AethericBody`, `OriginElement`) |
| `leyline_rng` | Regional Waygate elemental hazards, contraband tables, and Auction lot order |

---

## 2. Ring 1 — Origin Loom Architecture (5 Playstyle-Defining Builds)

Rolling your Origin Element at New Game permanently mutates the **structural rules of your Aetheric Loom** from Act I Episode 1:

| Origin Element | Loom Architecture Name | Structural Rule Mutation |
| :--- | :--- | :--- |
| **Fire** | *Pyro-Catalyst* | Unlocks **Blood-Burn Loops**: pay `10% MaxHP` to add `+1` free Feedback Loop on any Fire circuit without increasing MP cost. |
| **Water** | *Tidal Conduit* | Unlocks **Sympathetic Links**: spells hitting any *Soaked* unit echo at `50%` power to all other *Soaked* units on the same row. |
| **Earth** | *Tectonic Architect* | All Earth Vessels leave persistent **2.5D Constructs** (Stone Pillars / Crystal Prisms) on the arena for `3` turns to block melee or refract spells. |
| **Wind** | *Chrono-Vector* | Every Wind circuit may target **Row Position** OR **CTB Timeline Position** (`±25` Action Value push/pull). |
| **Aether** | *Blank Sovereign* | Starts with **`+2` Free Logic Gate Slots** (`IF`, `COPY`, `INVERT`) and `0` base element bias, enabling multi-element metamagic from Act I. |

---

## 3. Ring 2 — Syndicate Market Law (`Bubble` vs. `Heresy`)

Every save seed assigns **two opposing macro-economic elemental states** across the 5 Core Elements (`BubbleElement != HeresyElement` enforced):

1. **The Bubble Element (1 of 5):**
   - Hoarded by the Syndicate Clearinghouse for this save.
   - Catalyst & node purchase cost: **`+200%`**.
   - **Patented** spells of the Bubble Element pay **`3.0×` Quarterly/Act Royalties**.
   - Regional Bubble Crash events can be shorted on *The Exchange* for massive capital spikes.
2. **The Heresy Element (1 of 5):**
   - Outlawed by Syndicate Censors for this save; **removed from all legal shops and public Patenting**.
   - Obtainable only via **Black Ledger heists**, Waygate contraband nodes, and rogue Brokerage recruits.
   - **Tactical Payoff:** Syndicate Auditors and Act Bosses have **`0%` native resistance or counter-protocols** against the Heresy Element—making smuggled Heresy circuits lethal boss-breakers at the cost of Audit Heat when cast openly.

---

## 4. Ring 3 — Global Physical Law Mutators (12 World Rules)

Each save locks **1 Global Physical Law** that applies symmetrically to **both the player party and all enemies/bosses**, and visibly tints the 2.5D skybox & Ley-Spire shaders:

| ID | Law Name | Mechanical Rule Hook | 2.5D Visual Signature |
| :--- | :--- | :--- | :--- |
| `LAW_01` | **Inverted Conductivity** | `Earth` conducts `Lightning` across rows; `Water + Lightning` triggers *Healing Mist* instead of shock. | Amber-violet static haze |
| `LAW_02` | **Heavy Gravity Cycle** | `Channeling` spells gain `+60%` power and `+1` Channel Turn; Row displacement crash damage `×2.0`. | Low crimson horizon |
| `LAW_03` | **Aetheric Inflation** | Casting the same Element twice in a row doubles its MP cost for all combatants; alternating elements refunds `20%` MP. | Flickering gold ley-lines |
| `LAW_04` | **Sovereign Liquidity** | Forbidden Mythic Catalyst shards drop starting in Act I, but carrying `>1` Black-Book spell spawns roaming Liquidators. | Deep cobalt stormlight |
| `LAW_05` | **Volatile Resonance** | Overclocked (`101–150%` Stress) spells gain `+15%` extra power; Break vulnerability rises from `2.0×` to `2.5×`. | Cracked magenta sky-arcs |
| `LAW_06` | **Glass Economy** | All units take `+25%` damage; Clearinghouse Auction starting bids drop by `35%`. | Crisp pale-ivory glare |
| `LAW_07` | **Echoing Leylines** | First spell cast each battle by any unit automatically gains a free `50%` power `Echo`. | Twin-ring halo spires |
| `LAW_08` | **Frozen Ledger** | Commodity prices freeze for 2 Episodes at a time, then swing `±150%`; `Ice` and `Water` gain `+1` Chill stack. | Frost-blue aurora |
| `LAW_09` | **Blood Tariff** | All spells cost `20%` less MP but consume `5%` MaxHP on cast; `Leech` effectiveness `+50%`. | Rust-red smog |
| `LAW_10` | **Prism Refraction** | `Ward` and `Pillar` constructs reflect `30%` of single-target `Bolt` spells to an adjacent enemy. | Iridescent shard dust |
| `LAW_11` | **Overdraft Cascade** | Units may cast spells at `0 MP` by converting the deficit into `+ActionValue` Timeline delay (`1 MP = +2 AV`). | Dimmer tungsten glow |
| `LAW_12` | **Silent Meridian** | Basic attacks deal `+35%` damage; `Channeling` spells cannot be interrupted by non-`Void` / non-`Spear` hits. | Ash-grey overcast |

---

## 5. Anti-Brick Fairness Guardrails (GUT-Verified Invariants)

1. `HeresyElement != BubbleElement` is strictly enforced on seed initialization.
2. **Act I DPS/Breaker Guarantee:** `brokerage_rng` guarantees at least **2** Act I starting recruits with `ContractCut <= 15%` and complementary `Primer` / `Breaker` Doctrines.
3. **Counter-Element Path Guarantee:** Every Act's region provides at least one obtainable **non-Heresy** Catalyst or Vessel capable of triggering the Act Boss's **BREAK** weak point, regardless of which Origin or Heresy element was rolled.
4. **Seed Shareability:** Entering an identical `MasterSeed` string on any Mac, Windows, Android, or iOS build produces the exact same 3-Ring Cosmology and starting Brokerage Pool.
