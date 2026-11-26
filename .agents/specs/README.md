# Mana-Syndicate — Rebuilt Systemic Technical Baseline (`.agents/specs/`)

> **Authoritative Baseline:** This directory supersedes the legacy RPG Maker MV [prd.md](../../prd.md) (preserved as archive) and defines the rebuilt, mobile-first **Godot 4.x 2.5D** systemic specification for *The Mana Syndicate*.

## Locked Architectural & Design Pillars

| Pillar | Locked Decision |
| :--- | :--- |
| **Platform & Orientation** | **Mobile-First (Android / iOS) + PC**, **Landscape (16:9) Classic JRPG** with dual-thumb arc controls, `≥48dp` tap targets, zero hover tooltips, notch/safe-area awareness, `30 FPS` default (`60 FPS` toggle), and atomic auto-save after every action. |
| **Engine & Architecture** | **Godot 4.x 2.5D** (`Compatibility` / `GLES3` renderer), pure-core `RefCounted` / `Resource` domain layer (`scripts/domain/`), decoupled `Sprite3D` / `SubViewport` visuals, **100% offline-first V1** (zero Go/PostgreSQL backend or IAP server). |
| **Lexicon & Tone** | **Corporate-Occult International English** (`Examiner`, `Registrar #`, `Uncompiled Lens`, `Doctrine`, `Aetheric Body`, `Brokerage Pool`, `Audit Choir`, `Clearinghouse`, `Formula Zero`). |
| **World & Story Spine** | ***The Patented Sky*** — Ex-Patent Examiner commanding a Mobile Ley-Rail Foundry across **5 Continental Regions** (**5 Episodic Acts**). Magic is software; the Syndicate owns the compiler. |
| **Core Gameplay Identity** | **The Aetheric Loom** (touch-first spell circuit weaving, live 2.5D dry-fire preview, **Aetheric Stress** overclocking, **Field Fracture-Mutation**, party spell imprinting, and **Patent / Trojan / Open-Source Leak / Black-Book** IP warfare). |
| **Per-Save Replayability** | **The Harmonic Drift** — shareable Master Seed spinning a **3-Ring Cosmology** (Origin Loom Architecture, Bubble & Heresy Elements, Global Physical Law Mutator) + visible 2.5D skybox/Ley-Spire lighting shift. |

---

## Specification Index

| File | Scope |
| :--- | :--- |
| [01-game-loop-and-flows.md](./01-game-loop-and-flows.md) | Master state machine, 5 Continental Acts, 3-beat mobile session loop (5–10 min), atomic OS-kill auto-save contract, difficulty modes |
| [02-harmonic-drift-roulette.md](./02-harmonic-drift-roulette.md) | Deterministic Master Seed sub-streams, 3-Ring Harmonic Drift cosmology, 12 Global Physical Law mutators, anti-brick invariants |
| [03-aetheric-loom-magic-system.md](./03-aetheric-loom-magic-system.md) | `SpellCircuit` graph model, front-loaded Realm unlocks, 2.5D/Timeline elemental verbs, unified Complexity/Channel/Stress math, IP Warfare |
| [04-combat-timeline-and-doctrines.md](./04-combat-timeline-and-doctrines.md) | 4 Core Stats, Physical + Magic damage formulas, CTB Timeline & Collision Breaks, 2-tier roster, 3-axis Contractor schema, Lens Pulse |
| [05-economy-exchange-and-waygates.md](./05-economy-exchange-and-waygates.md) | 3 Merged Hubs (Foundry, Exchange, Black Ledger), 0-cost Waygates capped by Aetheric Saturation & Heat, Turn-Based Auctions, 4 Nations |
| [06-godot-25d-mobile-architecture.md](./06-godot-25d-mobile-architecture.md) | Godot 4.x mobile thermal/rendering spec, 16:9 dual-thumb UI map, typed `Resource`/`RefCounted` schemas, Autoloads, GUT test matrix |
