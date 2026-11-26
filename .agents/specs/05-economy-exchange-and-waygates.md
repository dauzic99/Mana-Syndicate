# 05 — Economy, Exchange, Waygates & Geopolitics

## 1. Three Merged Hubs (Replacing 10 Scattered Menus)

All non-combat management lives inside **3 clean, thumb-reachable Hubs** aboard the Mobile Ley-Rail Foundry:

| Hub | Consolidated Systems |
| :--- | :--- |
| **1. The Foundry** | **Aetheric Loom** (craft/overclock/dry-fire), **Party Grimoire Imprinting**, **Brokerage Hiring**, and **Async Sub-Contracts** (1-tap dispatch for benched contractors). |
| **2. The Exchange** | **Continental Commodity Ticker** (buy-low / sell-high catalysts & ores; no short-selling in V1), **Spell Patent Registry** (collect Act Royalties), and **Turn-Based Clearinghouse Auction**. |
| **3. The Black Ledger** | **Night Ops / Registry Heists**, **Heresy Element Contraband**, **Audit Heat Laundering**, and **`trojan_kill_switch`** kit assembly *(Unlocked Act IV)*. |

---

## 2. Zero-Exploit Waygates (Aetheric Saturation & Audit Heat)

Preserves **0-cost Waygate travel & instant extraction** for mobile commuters while **eliminating Day-3 infinite Gold/XP exploits**:

| Regional Saturation (`0–100%`) | Loot & Gold Yield | Threat Level |
| :--- | :--- | :--- |
| **`0% – 50%`** *(Fresh Leyline)* | **`100%`** Gold, Catalysts & XP | Standard regional patrols |
| **`51% – 85%`** *(Strained Leyline)* | **`50%`** yield; `+15` Audit Heat per fight | Escalated Syndicate patrols |
| **`86% – 100%`** *(Saturated Grid)* | **`10%`** normal loot; rare Contraband only | **Audit Choir Liquidator Ambush** (lethal elite hunter squad) |

- Saturation resets cleanly upon advancing to the next Episode/Act or paying an escalating **Leyline Purge** fee at *The Black Ledger* (`200G * 2^purges_this_episode`, hard cap `1/Episode`, adds `+15` Audit Heat).
- **Batch Contracts:** Accept up to `3` concurrent regional bounties to resolve in a single 3–5 screen diorama raid.

---

## 3. Turn-Based Clearinghouse Auction Engine

Replaces real-time countdown timers (which punish mobile players during phone calls or app switches) with **deterministic Bidding Rounds**:

- **Round Structure:** Each Lot runs up to `5` Bidding Rounds (`+10%`, `+25%`, `+50%` Jump-Bid, or `Pass` / `Withdraw`; Round 5 is a simultaneous **Sealed Final Bid**). Ties resolve by highest remaining `MaxBid - CurrentBid`, then deterministic `leyline_rng`.
- **Cartel AI Max Bid Formula:**
  ```text
  NationInterest = 1.35 if (Lot.Element == Nation.PrimaryElement) else 1.0  // Non-elemental/Aether = 1.0
  BubbleMult     = 1.60 if (Lot.Element == Drift.BubbleElement) else 1.0
  MaxBid         = round(Lot.BaseValue * NationInterest * BubbleMult * (1.0 + ActNumber * 0.15))
  ```
- **4-Nation `PrimaryElement` Mapping:** `ironclad_forges -> &"fire"`, `canopy_sanatoriums -> &"water"`, `glass_dune_freeholds -> &"wind"`, `basalt_vaults -> &"earth"`.
- **Auction Lots:** Exclusive Mythic Loom Nodes, Forbidden Logic Gates (`feedback_loop`, `shift`), **Sovereign Patent Shards** (*Formula Zero*), and Regional Monopoly Licenses.
- **Uncompiled Lens Advantage:** Holding on a Cartel bidder reveals their remaining **Reserve Ceiling** tier (`Low / Mid / Deep`) so you can bait rivals into overpaying.

---

## 4. Four-Nation Geopolitical Leverage & Hostility

Each of the 4 Nations tracks **Leverage (`0–100`)** and **Hostility (`0–100`)**:

| Nation | Magic Ideology | High Leverage (Patented Alliance) | High Disruption (Open-Source Leaks) |
| :--- | :--- | :--- | :--- |
| **Ironclad Forges** | Weaponized IP | Unlocks heavy `Spear`/`Pillar` Forge Vessels & military contracts | Crashes industrial weapon leases; spawns Forge Enforcer Audits |
| **Canopy Sanatoriums** | Subscription Bio-Magic | Unlocks `Leech`/Regen Catalysts & cheap Infirmary bailouts | Ends *Foreclosure Rot* tariffs in 2.5D hubs; triggers Bio-Actuary hit-squads |
| **Glass-Dune Freeholds** | Open-Source Piracy | Unlocks cracked `Echo`/`Shift` Gates & Heresy smuggling discounts | Unlocks black-market sanctuaries; rival Nations impose rail tariffs |
| **Basalt Vaults** | Gold-Standard Scarcity | Unlocks `Ward`/`Sigil` Vessels & higher Patent Royalty caps | Crashes Vault reserve prices; deploys Obsidian Guarantor squads |

---

## 5. Soft-Lock Prevention

- **Syndicate Credit Line:** Whenever `liquid_gold < required_fee` before an obligatory Act fee or Infirmary bailout, the player auto-draws only the shortfall on an emergency **Credit Line** (capped at `3×` Act `BailoutThreshold`, repaid automatically at `20%` of net post-cut Patent/Contract payouts, `>= 1G` floor).
- **Emergency Bailout Contracts:** Trigger **only** when `liquid_gold < BailoutThreshold` (`150G * Act`), paying a Gold-only floor at `0%` Saturation (`0` XP/Bond/Fracture rewards to prevent Act I grinding).
