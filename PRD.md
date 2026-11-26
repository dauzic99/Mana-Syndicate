# Product Requirements Document (PRD): *The Mana Syndicate*

| Field | Specification |
| --- | --- |
| **Product Title** | *The Mana Syndicate* (Working Title) |
| **Document Version** | 1.0 — Full Engineering & Design Specification |
| **Genre** | Economic Management RPG / Turn-Based Strategy |
| **Target Platforms** | PC (Steam / Desktop) & Mobile (Android / iOS) |
| **Client Engine** | RPG Maker MV (HTML5 / JavaScript / JSON Database) |
| **Mobile Wrapper** | Capacitor (Native Android/iOS Bridge & Play Store Billing) |
| **Backend Services** | Go Microservice + PostgreSQL (IAP Receipt Validation, Accounts, Cloud Saves) |
| **Dev Pipeline** | Google Antigravity IDE + `rpgm-mcp-pro-en` MCP Server |
| **Visual Aesthetic** | Corporate-Gothic Pixel Art (48×48px Grid) |

---

## 1. Product Vision & Objectives

### 1.1 Problem Statement & Opportunity

Traditional time-management RPGs create player anxiety by punishing side exploration with strict calendar penalties, while standard fantasy RPGs rely on static shops and predictable party dynamics. *The Mana Syndicate* solves both by pairing high-stakes quarterly exams and a volatile magical stock market with **0-time-cost Waygate grinding** and **autonomous AI mercenary management**.

### 1.2 Core Design Pillars

1. **Information Monopoly (The Eye of Origin):** Players do not guess stats, pay scouting fees, or rely on trial-and-error. Kael inherently reads hidden backend values (Potential multipliers, AI scripts, hidden contract clauses, and crafting stability). Mastery comes from exploiting transparent data.
2. **Portfolio Management (The Sifat System):** Party members are contracted, debt-ridden mercenaries rather than loyal friends. Each unit runs an autonomous behavioral AI (`Sifat`) and takes a cut of Gold. Victory depends on composing synergistic AI behaviors.
3. **A Ruthless Living Economy:** Static item stores are replaced by the monthly **Aetheric Clearinghouse** (Grand Auction), geopolitical market shocks, and short-term asset scalping.

### 1.3 Success Metrics (KPIs)

* **Onboarding Completion:** ≥ 75% of players complete Day 1–3 (Aetheric Audit, First Hire, First Crafted Spell).
* **Core Loop Validation:** ≥ 60% of players survive the Day 45 Q1 Mid-Term Boss (*Assessment Automaton*).
* **Retention (Mobile):** Day 1 ≥ 40%, Day 7 ≥ 18%, Day 30 ≥ 8%.
* **Economy Integrity:** 0% unauthorized IAP fulfillment via client-side patching/spoofing.
* **Runtime Performance:** Stable 60 FPS on mid-range mobile devices; < 100ms load time for the 30-unit recruitment board.

---

## 2. Narrative, Lore & World Specifications

### 2.1 Core Premise & Cast

* **The Setting:** The world runs on the **Mana Bubble**, an artificial economy controlled by the Syndicate of Sovereigns, who hoard high-tier magic and treat students as disposable "Liquidity."
* **Kael (Protagonist):** An orphan raised off-grid by exiled Sovereign **Aldous**. Intense physical conditioning without formal magic tutoring left his mana core blank yet extraordinarily dense, mutating into the **Eye of Origin**.
* **Valen (Narrative Catalyst):** Kael’s childhood friend and a "Linear Prodigy" who naturally awakened a Mythic element. Forcibly drafted by the Syndicate, Valen is trapped inside a **Suspended Mana Seal** in the Central Vault, acting as a living power battery for the Academy’s mana grid.
* **Player Objective (Hostile Takeover):** Infiltrate Aethelgard as a baseline student, exploit market volatility, accumulate extreme capital, bankrupt the Syndicate, shatter the Central Database, and free Valen.

### 2.2 The "NIP." Identification Protocol

To reinforce the cold, bureaucratic tone, every Academy instructor, registrar, and Syndicate executive must have `"NIP. "` (Nomor Induk Pegawai) prefixed to their ID in all dialogue headers, UI lists, and database logs (e.g., `Headmaster NIP. 00000001`, `Professor NIP. 19820344`).

### 2.3 Geopolitical Factions (The 4 Major Nations)

Aethelgard Institute of Commerce and Arcana serves as a neutral-zone stock exchange hosting embassies for four superpowers:

| Nation / Embassy | Primary Elements | Economic / Cultural Identity | Combat Archetype |
| --- | --- | --- | --- |
| **The Ironclad Principality** | Fire & Metal | Heavy industry, military contracting | Heavy Vanguards & Frontline Artillery |
| **Aethel-Flora Republic** | Water & Wood | Bureaucratic medical monopoly, healing tariffs | AoE Healers & Biological Saboteurs |
| **The Mirage Emirates** | Wind & Lightning | High-risk artifact smuggling rings | High-Speed Timeline Glass Cannons |
| **The Keystone Empire** | Earth & Defense | Central banking, sovereign vaults | Immovable Tanks & Damage Redirection |

---

## 3. Core Gameplay Systems & Functional Requirements

### FR-01: Calendar & 3-Year Fiscal Structure

* **Scope:** 3 in-game years = **12 Fiscal Quarters (Q1–Q12)**, exactly **90 Days per Quarter**.
* **Resource Currencies:**
* **Gold:** Contracts, auctions, potions, bribes, rent.
* **Day Tokens:** Macro time cost for mandatory classes, first-time zone mapping, and main story events.
* **Fatigue:** Night Market cost; taking illegal night actions halves Kael's Max HP for the following day.


* **Recurring Schedule:**
* **Days 1–28:** Lectures, Waygate grinding, market scalping, sub-contracting.
* **Day 28:** *The Grand Auction (Aetheric Clearinghouse)* — live bidding war against NPC cartels.
* **Day 30:** Rent due, Academy Stipend payout, Syndicate Tax Audit, Mercenary contract renewals.
* **Day 45:** *Mid-Terms* — Written Theory Exam + Mandatory Solo Boss Audit.
* **Day 90:** *Finals* — Mandatory Party Boss Fight. Failure triggers **Margin Call (Game Over)**.



### FR-02: Day 1 RNG Start (The Aetheric Audit)

* **Trigger:** Opening intake cutscene on Day 1.
* **Behavior:** A randomized check (1–100 roll mapped across 5 buckets) forces one **Standard Element** (`Fire`, `Water`, `Earth`, `Wind`, or `Neutral`) into Kael's blank core.
* **Starting Capital:** 500 Gold.
* **Acceptance Criteria:** The assigned element must persist in `$gameVariables` as `KAEL_ORIGIN_ELEMENT` so the Day 45 boss dynamically counters it.

### FR-03: The Eye of Origin (Passive UI Overlay)

* **Core Rule:** Always active at zero cost. Kael never pays weekly scouting or broker fees.
* **Functional Surfaces:**
1. **Recruitment Board:** Displays hidden `Potential` multiplier (`0.8x` Value Trap to `2.5x` Anomaly) and `Sifat` trait for every recruit.
2. **Combat HUD:** Exposes enemy AI scripts, elemental resistances, active Channeling cast timers, and exact Break weak points.
3. **Quest Board:** Flags hidden contract clauses (e.g., *Hidden Asset Detected: Unregistered Mythic Catalyst*) enabling player extortion or theft options.
4. **Aetheric Weaver:** Real-time structural stability gauge and Backlash warnings prior to confirming synthesis.



### FR-04: Character Attributes (Dual Combat & Economy Utility)

| Stat | Engine Mapping | Combat Function | Economic / World Function |
| --- | --- | --- | --- |
| **Vitality** | `MHP` | Max HP; determines Margin Call threshold | Stamina pool burned for Night Market database hacks |
| **Mana Purity** | `MMP` / `MAT` | Raw spell damage output | Unlocks higher-tier blueprints in the Aetheric Weaver |
| **Physique** | `DEF` | Physical damage mitigation | Increases raw ore/material extraction per click at Waygate nodes |
| **Resonance** | `MDF` | Magic & debuff resistance; MP regen scaling | Lowers Syndicate Auditor tax rate during Day 30 settlement |
| **Control** | `AGI` | Turn Timeline placement & Cast Delay reduction | Stabilizes Realm 3 Mythic crafting to prevent Backlash |
| **Potential** | Custom Float | Hidden growth multiplier (`0.8x`–`2.5x`) on level-up | Visible exclusively via Eye of Origin to evaluate mercenary ROI |

### FR-05: Portfolio Management & The Sifat AI Matrix

* **Party Capacity:** 4 Active slots (Kael + 3 Mercenaries), 2 Reserve slots.
* **Roster Pool:** 30 procedurally generated student recruits stored in the flat `mahasiswa` array.
* **Trait Modification:** Consuming a `Blank Grimoire` (1,000G) overrides a recruit's current Sifat.

#### Complete Sifat Specification (14 Traits)

| ID | Sifat | Category | Autonomous AI / Passive Behavior | Elemental Evolution Path |
| --- | --- | --- | --- | --- |
| 1 | **Aggressive** | Base AI | Targets lowest-HP enemy; casts highest DPS skill; ignores MP conservation | Standard |
| 2 | **Cautious** | Base AI | Prefers Back Row; casts Defend/Shield if self HP < 50% | Standard |
| 3 | **Greedy** | Base AI | Targets Boss/Elite to kill-steal; demands +15% Gold contract cut | Standard |
| 4 | **Calculative** | Base AI | Attacks only when an enemy is Channeling (triggers Break); passes turn to conserve MP | Standard |
| 5 | **Protective** | Base AI | Automatically casts Cover/Taunt whenever Kael is Channeling a spell | Standard |
| 6 | **Eccentric** | Base AI | Randomly picks between highest-cost skill and basic attack; ignores Row logic | Standard |
| 7 | **Melancholic** | Evolutionary | +10% MDF when any ally is below 50% HP | 80% Ice / Void |
| 8 | **Zestful** | Evolutionary | +5% Control (Speed) on successful hit | 80% Lightning / Wind |
| 9 | **Stoic** | Evolutionary | Immune to Fear, Panic, and Mind-Control debuffs | 80% Metal / Earth |
| 10 | **Obsessive** | Evolutionary | Locks onto a single enemy (highest HP/initial target) until eliminated | 80% Poison / Shadow |
| 11 | **Altruistic** | Evolutionary | Casts heal skills spending own HP if MP reaches 0 | 80% Light / Water |
| 12 | **Volatile** | Evolutionary | Damage output fluctuates dynamically by ±50% per cast | 80% Plasma / Chaos |
| 13 | **Cowardice** | Hidden Flaw | Permanently flees combat if Kael drops to 0 HP | None |
| 14 | **Loyal** | Earned (Flip) | Intercepts fatal blows aimed at Kael automatically; reduces contract cut to 0% | Retains Base |

### FR-06: Magic Synthesis (The Aetheric Weaver)

Spells are crafted rather than purchased, following the modular equation:


$$\text{Spell} = [\text{Element}] + [\text{Vessel}] + [\text{Catalyst}]$$

#### Realm Progression Tiers

* **Realm 1 (Initiate — Q1–Q4):** 1 Standard Element + 1 Base Vessel. No Catalysts.
* **Realm 2 (Acolyte — Q5–Q8):** 2 Standard Elements (Fusions: e.g., `Water + Wind = Ice`, `Fire + Earth = Magma`) or 1 Mutation Element + 1 Vessel + 1 Catalyst.
* **Realm 3 (Sovereign — Q9–Q12):** Mythic Elements + 1 Vessel + up to 2 Catalysts. High Instability / Control checks enforced.

#### Component Catalog

* **Standard Elements (5):** Fire, Water, Earth, Wind, Neutral.
* **Mutation Elements (6 + Fusions):** Ice, Lightning, Metal, Poison, Light, Shadow (+ Magma).
* **Mythic / Forbidden Elements (5):**
* **Gravity:** Deals % Max HP damage; inflicts severe caster Turn Delay.
* **Void:** Deals 0 damage; instantly shatters any enemy Channeling state; costs HP instead of MP.
* **Mirage:** Grants 100% Evasion for 1 turn; caster receives 200% damage on the following turn.
* **Plasma:** Pierces all shields/barriers; drains caster MP every active turn.
* **Chaos:** Applies a randomized Mythic effect; high Backlash instability.


* **Vessels (8):** `Bolt` (Single, low cost, fast), `Shield` (Damage reduction barrier), `Aura` (Single heal/buff), `Spear` (Pierces % of Physique/DEF), `Zone` (Enemy Front Row AoE), `Pillar` (Heavy single-target + minor enemy timeline pushback), `Sphere` (High-density AoE; requires high Control), `Sigil` (Ground trap triggering on enemy attack).
* **Catalysts (4):** `Echo` (Casts twice immediately, 2nd cast at 50% power), `Leech` (Restores 15% of damage dealt as HP), `Rotation` (Swaps target's Vanguard/Vault Row position), `Condensation` (Halves MP cost, doubles Cast Delay).

### FR-07: Combat Engine, Timeline & Liquidation

* **Row Formation:**
* **Vanguard (Front Row):** Absorbs 100% of incoming physical melee damage.
* **Vault (Back Row):** Protected from melee targeting; designated for casters/healers.


* **Timeline, Channeling & Breaks:**
* Turn order is plotted on a visible Timeline UI driven by `Control (AGI)`.
* Heavy/high-complexity spells enter a **Channeling** state, delaying execution across turns.
* Striking a Channeling enemy with a counter-element, `Void`, or weak-point Vessel (e.g., `Spear`) triggers **Break**: cancels the spell, skips the enemy's turn, and applies a 2x damage vulnerability window.


* **Liquidation (Trauma & Permadeath):**
* Kael at 0 HP → **Margin Call (Game Over)**.
* Mercenary at 0 HP → **Trauma** (Status = `2 / Hospitalized`, unusable until recovered).
* Mercenary receives lethal Overkill damage → **Liquidation (Permadeath)** (Status = `3`, permanently removed from active `mahasiswa` pool; drops an **Inheritance Grimoire** containing their learned skills).



#### Canonical Engine Formulas

All custom RPG Maker MV formula boxes and JS `eval` script calls **must strictly terminate with a semicolon (`;`)** to guarantee evaluation stability.

* **Raw Magic Damage:**
```javascript
((a.mat * SpellMultiplier) / (1 + (b.mdf / 100))) * TraitModifier;

```


* **Timeline Cast Delay (Backlash):**
```javascript
Math.max(0, (SpellComplexity - a.agi) / 10);

```


* **Grand Auction NPC Max Bid:**
```javascript
BaseItemValue * (1 + ((Quarter * NPCAggression) / 100));

```


* **Turn MP Regeneration:**
```javascript
(a.mdf * 0.05) + SifatBonus;

```



### FR-08: Exploration, Waygates & Quest Architecture

* **The Aetheric Waygate Network (0-Day Grinding):**
* First visit to a zone costs Day Token(s) to physically reach and map via Aldous's Grimoire backdoor codes.
* Once unlocked, teleporting from Kael's dorm to any unlocked Waygate costs **0 Day Tokens**.
* Enables indefinite same-day dungeon grinding bounded solely by HP/MP attrition and Mana Potion expenses.
* **Key Nodes:** *Node 1: The Slums* (Day 3 tutorial, early junk farming), *Node 2: Ironclad Mines* (defeat optional gate mini-boss, ore farming), *Node 3: Deep Vaults* (active Syndicate grid hack, top-tier catalyst farming).


* **Off-Book Contracts (Side Quests):**
1. **Market Scalping:** Time-limited 3-day market volatility spikes (e.g., `Slime Core` surging from 10G to 50G / +400% during an Alchemy seminar).
2. **Registry Infiltration (Night Market):** Consumes **Fatigue** (halves next-day Max HP) to hack Academy servers at night. Rewards **Institutional Leverage** (stolen Mid-Term keys, permanent tax reductions, `Void Fragments` valued at 5,000G).
3. **Portfolio Maintenance:** Unlockable personal quests for frequently deployed recruits (e.g., wiping out Mirage Emirates debt collectors) that permanently flip their Sifat to **Loyal**.


* **Mission Optimization Systems:**
* **Batch Contracts:** Accept up to 5 concurrent bounties targeting the same Waygate zone to resolve in one run.
* **Sub-Contracting (Async Dispatch):** Assign benched `mahasiswa` recruits to background low-tier contracts while Kael attends classes. Success resolves against `Sifat` compatibility (e.g., sending *Aggressive* to a stealth hack results in failure and `Hospitalized` status).



### FR-09: The Elite 4 (Year 2 Key NPCs)

Exclusive, 0%-cut allies tied to the 4 Embassies. Faction alignments create geopolitical friction (heavy alignment with one nation can lock out rival embassies).

| NPC | Nation | Role | Sifat | Signature "Eye" Perk | Recruitment Hack / Trial |
| --- | --- | --- | --- | --- | --- |
| **Varek** | Ironclad | Heavy Vanguard / Artillery | Calculative | *Unstoppable Force:* Immune to Row-Collapse & displacement | Hack Academy registry tables to erase his fabricated Syndicate debt |
| **Dr. Silas** | Aethel-Flora | AoE Healer / Saboteur | Obsessive | *Toxic Dividend:* Healing Kael bounces "Rot" (DEF-down) onto enemy Front Row | Map & host hidden decentralized Waygate server nodes for his forbidden library |
| **Zafira** | Mirage | Timeline Glass Cannon | Volatile | *Scalper's Agility:* 300% damage vs. Channeling enemies, then auto-retreats to Vault Row | Identify & outbid rival cartels at the Grand Auction; hand her the artifact |
| **Oros** | Keystone | Absolute Tank | Stoic | *Asset Freeze:* Drops speed to 0; redirects next 3 attacks on Kael to himself at 80% mitigation | Survive 10 rounds in the underground arena against Oros without attacking once |

### FR-10: Year 1 Progression, Exams & Boss Specifications

#### Q1 Walkthrough & Mid-Term Boss (Days 1–90)

* **Day 1:** Aetheric Audit (RNG Element) + 500G.
* **Day 2:** Recruitment Board tutorial (Eye of Origin reveals Greedy vs. High-Potential Value recruit).
* **Day 3:** Aetheric Weaver tutorial (`Neutral + Bolt = Arcane Dart`); Slums Waygate unlocked.
* **Days 4–27:** Waygate grinding, Batch Contracts, resource accumulation.
* **Day 28:** First Grand Auction (spectator/introductory exposure to high-tier pricing).
* **Day 30:** Rent, Stipend, Tax settlement.
* **Day 45 — Mid-Term Solo Boss: *The Assessment Automaton*** (Kael Solo — no Mercenaries):
* *Phase 1 (100%–51% HP — Elemental Audit):* Reads `KAEL_ORIGIN_ELEMENT` and shifts core to resist it; forces crafted secondary-element usage.
* *Phase 2 (50%–16% HP — Timeline Break):* Channels *Quarterly Liquidation* (2-turn lethal AoE); Eye of Origin warns *"Structural weak point: Piercing Force."* Requires `[Spear]` Vessel or `Void`/`Wind` Break.
* *Phase 3 (≤ 15% HP — Margin Call):* Arena drains 10% of Kael's Max MP per turn (DPS execution race).
* *Grading Outcomes:* **Grade A** (< 10 turns: +50% permanent Stipend), **Grade B** (11–20 turns: Standard), **Grade C** (survived with high potion/MP waste: Tax penalty), **Fail** (0 HP: Liquidation / Game Over).


* **Days 46–89:** Night Market hacking & Sub-Contracting unlocked.
* **Day 90 — Q1 Finals Boss: *The Debt Collector*** (Party Boss): Steals Gold directly from player inventory on hit; triggers instant-kill Liquidation if player Gold hits 0.

#### Q2–Q4 Year 1 Boss Roadmap

* **Q2 (Day 180) — *Ironclad Siege Golem*:** Ironclad–Mirage war spikes Iron Ore prices by 300%; boss features extreme DEF requiring `Spear` or `Magma` synthesis.
* **Q3 (Day 270) — *Syndicate Auditor*:** Inflicts *Mana Silence* on Standard Elements; tests Sifat auto-battle builds and Dr. Silas/Night Market progression.
* **Q4 (Day 360) — *The Dean of Admissions*:** Requires 100,000G capital milestone for Valen's seal prep. Phase 1 summons Liquidated zombie students; Phase 2 casts *Market Crash* (-50% all party stats unless Broken via `Void`).

---

## 4. Technical Architecture & Engineering Specifications

### 4.1 RPG Maker MV Client & Flat `mahasiswa` Data Architecture

To guarantee fast UI rendering across desktop and mobile without relational overhead, the client avoids foreign key constraints and separate guild/membership join tables. All 30 background recruits reside in a single flat JSON/JavaScript structure loaded into `$gameSystem._mahasiswa`.

#### `mahasiswa` Array Record Schema

```json
{
  "actorId": 101,
  "name": "Reno",
  "level": 3,
  "sifatId": 4,
  "potential": 1.85,
  "contractCut": 0.15,
  "status": 0,
  "originElement": "Wind",
  "loyaltyQuestFlag": false
}

```

* **Status Enum:** `0 = Idle (Available/Bench)`, `1 = Hired (Active Party)`, `2 = Hospitalized (Trauma)`, `3 = Liquidated (Permadead)`.

#### Custom MV Plugin Suite (`js/plugins/`)

1. `MS_CoreCalendar.js` — Tracks `Current_Day`, `Current_Quarter`, Day Tokens, Fatigue HP debuffs, Stipend/Tax logic, and `"NIP. "` name formatting.
2. `MS_MahasiswaDB.js` — Initializes and persists the flat 30-unit `mahasiswa` array, renders the Eye of Origin Recruitment UI, handles Sub-Contracting dispatch timers, and processes Permadeath/Inheritance Grimoire drops.
3. `MS_SifatAI.js` — Overrides MV `Game_Actor.prototype.makeAutoBattleActions` to execute deterministic targeting and skill selection for all 14 Sifat IDs.
4. `MS_TimelineCombat.js` — Implements the Control-driven turn timeline, Channeling states, Break interrupts, and Vanguard/Vault row damage rules.
5. `MS_AethericWeaver.js` — Modular crafting scene combining Element + Vessel + Catalyst items into dynamically generated skills with real-time stability/Backlash previews.
6. `MS_EconomyWaygate.js` — Waygate 0-Day fast travel menu, Batch Contract tracker (max 5 active), volatile item price multipliers, and Day 28 Auction House bidding loop.
7. `MS_CapacitorIAP.js` — Client bridge communicating with native StoreKit / Google Play Billing and forwarding `PurchaseToken` payloads to the Go backend.

### 4.2 Mobile Deployment & Go/PostgreSQL Security Backend

Because RPG Maker MV projects wrapped in Capacitor expose client-side HTML5/JS assets, **all In-App Purchases (IAP) and premium balances must be server-authoritative**.

```text
[Mobile Client (MV + Capacitor)]
       │ 1. Initiate Purchase
       ▼
[Google Play / App Store] ──► 2. Returns Encrypted PurchaseToken
       │
       ▼ 3. POST /api/v1/iap/verify (JWT + PurchaseToken + IdempotencyKey)
[Go Backend Microservice]
       │ 4. Server-to-Server Receipt Verification
       ▼
[Google Play Developer API / Apple App Store Server API]
       │ 5. Validated Receipt Confirmation
       ▼
[PostgreSQL Master Ledger] ──► 6. Atomic Transaction (Log Receipt + Credit Account)
       │
       ▼ 7. Signed Entitlement Response
[Mobile Client] ──► Unlocks Asset / Syncs Cloud Save

```

#### Core PostgreSQL Tables (Backend Only)

* `users` (`id`, `auth_provider_id`, `created_at`, `last_login`)
* `iap_transactions` (`id`, `user_id`, `platform`, `product_id`, `purchase_token` UNIQUE, `status`, `verified_at`)
* `player_ledgers` (`user_id`, `premium_currency_balance`, `unlocked_entitlements` JSONB, `updated_at`)
* `cloud_saves` (`user_id`, `slot_id`, `save_payload` JSONB/BYTEA, `checksum`, `updated_at`)

### 4.3 AI-Assisted Development Pipeline (Antigravity + MCP)

* **IDE:** Google Antigravity IDE.
* **MCP Server:** `rpgm-mcp-pro-en` configured via `~/.gemini/config/mcp_config.json` with `RPGMAKER_PROJECT_PATH` pointing directly to the MV project folder.
* **Agent Capabilities:** Direct JSON generation/editing (`Actors.json`, `Items.json`, `Skills.json`, `Enemies.json`), map grid/event verification, automated MV plugin writing and registration in `js/plugins.js`, and automated battle simulation testing.

---

## 5. UI / UX & Art Asset Specifications

### 5.1 Art Direction & Formatting Standards

* **Character Sprites:** Standard RPG Maker MV 48×48px per frame, 3-column × 4-row walking grids. Tailored corporate-gothic trench coats, muted slate/charcoal/black palettes, sharp metallic trims. Produced in **Aseprite** or **Pyxel Edit**.
* **Tilesets & Maps:** 48×48px tile grid built in MV Editor or **Tiled** (imported via plugin). Enforce architectural symmetry, cold marble floors, iron-wrought auction galleries, and glowing mana conduits resembling structured network cabling.

### 5.2 Core UI Screens Required

1. **Overworld HUD:** Displays `Quarter / Day`, `Gold`, `Day Tokens`, `Fatigue Warning`, and a `Waygate` shortcut icon.
2. **Recruitment Board (`mahasiswa`):** Split-pane list showing standard info on the left and the glowing **Eye of Origin Overlay** (`Potential`, `Sifat`, `Contract Cut %`, `Status`) on the right.
3. **Aetheric Weaver Matrix:** 3-slot modular assembler (`Element` + `Vessel` + `Catalyst`) with live MP Cost, Cast Delay, and Stability/Backlash readout.
4. **Aetheric Clearinghouse (Auction UI):** Live countdown timer, item card, rival nation bid ticker, and quick-increment bid buttons.
5. **Night Market Terminal:** Command-line/dossier aesthetic showing available database hacks, exact Max HP Fatigue cost, and Institutional Leverage rewards.
6. **Sub-Contracting Board:** Drag-or-assign interface pairing idle `mahasiswa` units with background missions and displaying Sifat risk warnings.
7. **Battle HUD:** Horizontal top-edge Turn Timeline bar with Channeling/Break icons, Vanguard/Vault row indicators, and Eye of Origin enemy script tooltip.

---

## 6. Non-Functional Requirements, Edge Cases & Risk Mitigation

| Area | Requirement / Edge Case | Mitigation Strategy |
| --- | --- | --- |
| **Formula Stability** | Missing semicolons in MV custom formulas cause silent `0`-damage bugs. | Enforce automated ESLint / pre-commit check guaranteeing `;` termination on every MV eval string. |
| **Soft-Lock Prevention** | Player runs out of Gold on Day 30 (Rent) or before Q1 Finals (*Debt Collector*). | Provide an emergency **Syndicate Predatory Loan** (high interest) and preserve 0-Day Slums Waygate access so players can always farm recovery Gold. |
| **RNG Balance (Day 1)** | Unfavorable starting element (e.g., Water/Support) slows early clearing. | Guarantee at least 1 low-cut *Aggressive* DPS recruit appears on Day 2's initial `mahasiswa` board roll. |
| **IAP Replay Attacks** | User re-submits a valid `PurchaseToken` to claim rewards twice. | Enforce `UNIQUE` database constraint on `purchase_token` in PostgreSQL inside an atomic SQL transaction. |
| **Offline Mobile Play** | Player loses internet while commuting. | Core single-player gameplay runs 100% offline via local storage; IAP purchases and Cloud Save sync require active connectivity to the Go API. |

---

## 7. Phased Development Roadmap

| Phase | Target Deliverable | Key Engineering & Content Milestones |
| --- | --- | --- |
| **Phase 0: Setup** | Workspace & Pipeline | Initialize RPG Maker MV project; connect `rpgm-mcp-pro-en` to Antigravity; establish corporate-gothic 48×48 sprite/tileset templates. |
| **Phase 1: Vertical Slice** | Playable Days 1–14 | Implement `MS_CoreCalendar`, Day 1 Audit RNG, `mahasiswa` array, Eye of Origin UI, Realm 1 Aetheric Weaver, and Slums Waygate 0-Day loop. |
| **Phase 2: Q1 Complete** | Full Quarter 1 Loop | Build `MS_SifatAI` (all 14 traits), `MS_TimelineCombat` (Rows, Channeling, Breaks), Grand Auction, Night Market, Batch/Sub-Contracts, Day 45 *Assessment Automaton*, and Day 90 *Debt Collector*. |
| **Phase 3: Full Campaign** | Years 1–3 Content | Implement 4 Nation Embassies, Elite 4 Key NPCs & recruitment hacks, Realm 2 & 3 Magic/Catalysts, Q2–Q12 Bosses, and Central Vault Valen climax. |
| **Phase 4: Mobile & Launch** | Store Release | Wrap MV client in Capacitor; deploy Go + PostgreSQL IAP validation & cloud save service; execute end-to-end balance audits and Play Store/Steam certification. |

Would you like to immediately generate the **starter `js/plugins/` technical specification and code scaffolding** for Phase 1 so you can hand it directly to your Antigravity MCP agent?