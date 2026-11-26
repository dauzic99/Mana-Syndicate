# 01 — Master Game Loop, Continental Acts & Mobile Session Flows

## 1. Master Game State Machine

Every playable session transitions deterministically through explicit top-level states managed by `RunStateBus`:

```mermaid
stateDiagram-v2
    [*] --> BOOT
    BOOT --> TITLE : Load Settings & Save Index
    TITLE --> DRIFT_ROULETTE : New Run (Generate/Enter Master Seed)
    TITLE --> RESUME_ROUTER : Continue (Atomic Resume)
    RESUME_ROUTER --> FOUNDRY_HUB : Saved in Hub
    RESUME_ROUTER --> DIORAMA_RAID : Saved in Raid Room
    RESUME_ROUTER --> TIMELINE_COMBAT : Saved Mid-Turn
    RESUME_ROUTER --> CLEARINGHOUSE_AUCTION : Saved in Auction Round
    RESUME_ROUTER --> IP_DISPOSITION : Saved at IP Choice
    DRIFT_ROULETTE --> FOUNDRY_HUB : Lock 3-Ring Cosmology (Act I Start)

    FOUNDRY_HUB --> DIORAMA_RAID : Deploy to Regional Waygate
    FOUNDRY_HUB --> BLACK_LEDGER_HEIST : Launch Black Ledger Heist
    FOUNDRY_HUB --> CLEARINGHOUSE_AUCTION : Trigger End-of-Act Auction
    DIORAMA_RAID --> TIMELINE_COMBAT : Encounter / Liquidator Ambush
    BLACK_LEDGER_HEIST --> TIMELINE_COMBAT : Security Engagement
    TIMELINE_COMBAT --> DIORAMA_RAID : Victory / Tactical Retreat (Non-Boss, Non-Liquidator)
    TIMELINE_COMBAT --> FOUNDRY_HUB : Examiner KO -> Bailout (Standard)
    TIMELINE_COMBAT --> GAME_OVER : Examiner KO (Hardcore Audit)

    DIORAMA_RAID --> FOUNDRY_HUB : 0-Cost Ley-Gate Extraction
    DIORAMA_RAID --> EPISODE_SETTLEMENT : Episode Beat Cleared
    CLEARINGHOUSE_AUCTION --> TIMELINE_COMBAT : Act Patent Boss
    TIMELINE_COMBAT --> IP_DISPOSITION : Act Boss / Heist Climax Resolved
    IP_DISPOSITION --> EPISODE_SETTLEMENT : Ep < MaxEp (Standard Beat)
    IP_DISPOSITION --> ACT_SETTLEMENT : Final Act Episode Resolved
    EPISODE_SETTLEMENT --> FOUNDRY_HUB : Advance Episode (Decay Heat / Reset Saturation)
    ACT_SETTLEMENT --> FOUNDRY_HUB : Advance to Next Continental Act
    ACT_SETTLEMENT --> EPILOGUE : Act V World-Ledger Climax Resolved
    GAME_OVER --> TITLE : Archive Seed & Return
    EPILOGUE --> TITLE : New Seed+ / Return
```

---

## 2. Five Continental Acts (Replacing the 1,080-Day Calendar)

The 1,080-day school calendar is eliminated. A full campaign spans **5 Episodic Acts** aboard the Examiner's **Mobile Ley-Rail Foundry**, engineered for zero filler days and 5–10 minute commuter beats.

| Act | Region / Nation | Core Systemic Focus | Act Climax |
| :--- | :--- | :--- | :--- |
| **Act I** | **The Brass Meridian** *(Free-Port Hub)* | Origin Loom onboarding, 4-node Spell Weaving unlocked in Episode 1, Brokerage hiring, first Patent/Leak choice | Turn-Based Clearinghouse Auction + **Audit Bailiff** |
| **Act II** | **The Ironclad Forges** *(Weaponized IP)* | Factory spell-leases, Armor-Pierce & Earth Pillar terrain warfare, 6-node Loom & Elemental Fusions | Forge Union Heist + **Ironclad Siege Sovereign** |
| **Act III** | **The Canopy Sanatoriums** *(Subscription Bio-Magic)* | Foreclosure Rot crisis, moral clash between profiting on cure scarcity vs. open-source Leaks, Water/Poison chains | Quarantine Raid + **Chief Actuary of Bio-Tariffs** |
| **Act IV** | **The Glass-Dune Freeholds & Basalt Vaults** *(Mirage & Keystone)* | 9-node Loom, Feedback Loops, Mythic Elements, Trojan Kill-Switches, Black-Ledger Catalyst smuggling, Vault security | Dual Heist + **Sovereign Vault Guarantor** |
| **Act V** | **The World-Ledger Core** *(Harmonic Convergence)* | All 4 Nations react to your Patent/Leak ledger; bosses deploy counter-builds to your most-used **Patented** spells | **The Central Compiler** + 7 Shards of *Formula Zero* Finale |

---

## 3. The 3-Beat Mobile Session Loop (5–10 Minutes Per Beat)

Each Act consists of **4–5 Episodes**. Every Episode breaks into three self-contained mobile beats:

1. **Beat 1 — Market Pulse & Foundry Prep (2–4 min):**
   - **Progressive Act I Tab Unlock** (prevents onboarding overload): `Ep 1: Loom + Raid`, `Ep 2: Brokerage + Sub-Contracts`, `Ep 3+: Exchange + Black Ledger`.
   - Inspect the **Continental Ticker** (driven by the save's *Harmonic Drift* + prior Patent/Leak ripples).
   - Craft, overclock, or imprint 1 `SpellCircuit` in the **Aetheric Loom** and test-fire on the live 2.5D mannequin.
   - Assign benched Brokerage contractors to **Async Sub-Contracts** (resolved on Beat completion).
2. **Beat 2 — 2.5D Diorama Raid (5–8 min):**
   - Traverse compact, richly lit **3–5 screen 2.5D dioramas** (elevated brass catwalks, glowing ley-conduits, zero filler corridors).
   - Use custom spells as field tools (e.g., Earth Pillars bridge gaps, Wind clears miasma).
   - **0-Cost Ley-Gate Extraction** is available between rooms so players can bank loot and exit before stepping off a train.
3. **Beat 3 — Set-Piece Climax & IP Disposition (6–10 min):**
   - Resolve a **Turn-Based Clearinghouse Auction**, a **Black Ledger Registry Heist**, or an **Act Patent Boss**.
   - Make a binding **IP Disposition** decision on your flagship spell (*Patent*, *Open-Source Leak*, or *Black-Book*) that updates regional prices, Audit Heat, and enemy loadouts.

---

## 4. Mobile OS-Kill Auto-Save Contract

Android and iOS aggressively terminate backgrounded apps. **Manual-only saving is forbidden.**

- **Atomic Checkpoint Triggers:** Commit `SaveRunState` (versioned JSON via `WorkerThreadPool` temp file + `.bak` rotation + rename, plus synchronous flush on `NOTIFICATION_APPLICATION_PAUSED`) **before** playing animations:
  1. Every resolved **turn** in `TIMELINE_COMBAT` (committed **before** combat animations play, preserving exact `combat_rng`, Timeline Action Values, HP/MP, and active 2.5D constructs).
  2. Immediately upon **Fracture-Mutation** trigger (before opening the player naming modal).
  3. Every **room transition**, chest/node interaction, or Ley-Gate extraction in `DIORAMA_RAID`.
  4. Every **spell commit/imprint** in the Aetheric Loom, and every **market trade**, **sub-contract dispatch**, or **auction round bid**.
- **Anti-Cheese & Roster Floor Invariants:**
  - **Tactical Retreat** is forbidden during **Act Bosses** and **Audit Choir Liquidator Ambushes**.
  - Solo Examiner deployment is always permitted; if active non-Examiner squad `< 2`, Brokerage guarantees `>= 2` `0G`-upfront recruits.
- **Resume Invariant:** Relaunching after an OS kill routes through `RESUME_ROUTER` directly back into the exact turn, room, or auction round with zero lost progress.

---

## 5. Difficulty & Audit Modes

| Mode | 0 HP Examiner Rule | Contractor Overkill / Trauma KO | Economy & Audit Heat |
| :--- | :--- | :--- | :--- |
| **Standard Audit** *(Default)* | Emergency Ley-Gate Extraction + **Syndicate Bailout Fee** (`15%` liquid Gold, floored at `0G`) | **Trauma** (1 Episode recovery or Clinic Fee); **Liquidation** is strictly **voluntary** (*Extract Relic Node*) | Standard prices & Heat decay |
| **Hardcore Audit** *(Ironman)* | **Margin Call (Run Over / Archive Seed)** | **Automatic Liquidation (Permadeath)** on Overkill (`≤ -50% MaxHP`) or KO while Traumatized | `+25%` Audit Heat gain; higher Royalty rewards |
