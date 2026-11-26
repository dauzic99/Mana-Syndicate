# PRD Status (`docs/prd/`)

> **Status: Rebuilt & Locked into `.agents/specs/`**
> The original [prd.md](../../prd.md) (legacy RPG Maker MV draft) is preserved in the repository root as a historical archive. All authoritative systemic rules, formulas, state machines, and Godot 4.x 2.5D mobile specifications now live in [../../.agents/specs/README.md](../../.agents/specs/README.md).

## Locked Architectural & Technical Decisions
1. **Engine & Renderer:** **Godot 4.x 2.5D** using `Compatibility (GLES3)` (primary mobile) with `30 FPS` default / `60 FPS` toggle, baked lightmaps, `Sprite3D` (`TEXTURE_FILTER_NEAREST`, `ALPHA_CUT_OPAQUE_PREPASS`), and throttled `SubViewport`s.
2. **Platform & Orientation:** **Mobile-First (Android / iOS) + PC**, **Landscape (16:9) Classic JRPG** with dual-thumb arc controls, `≥48dp` tap targets, notch/safe-area insets, zero hover tooltips, and atomic turn-by-turn auto-saves.
3. **Storage & Backend Scope:** **100% Offline-First V1** (`user://saves/` atomic local saves; zero Go/PostgreSQL server or IAP backend bloat).
4. **Lexicon & Tone:** **Corporate-Occult International English** (`Examiner`, `Registrar #`, `Uncompiled Lens`, `Doctrine`, `Aetheric Body`, `Brokerage Pool`, `Clearinghouse`).
5. **World & Core Mechanics (*The Patented Sky*):**
   - **5 Continental Acts** (5–10 min commuter beats) aboard a Mobile Ley-Rail Foundry.
   - **The Aetheric Loom** (front-loaded Act I Ep 1 spell circuit weaving, Aetheric Stress overclocking, Field Fracture-Mutation, and Patent/Trojan/Leak/Black-Book IP warfare).
   - **The Harmonic Drift** (shareable Master Seed spinning a 3-Ring Elemental Cosmology + 12 Global Physical Law mutators).
