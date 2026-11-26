# Mana-Syndicate — Knowledge Graph Summary

- **MCP Project ID**: `Users-dauzic-Documents-Code-Mana-Syndicate`
- **Current Phase**: Systemic Baseline Locked (`.agents/specs/` + 39-skill kit ready; pre-code)
- **Primary Stack**: Godot 4.x 2.5D / Typed GDScript / GUT / `gdtoolkit` / Elephant-Goldfish Model (EGM)

## Bootstrap Structure
- **Root Contracts**: `GOLDEN_STANDARD.md`, `AGENTS.md`, `.gitignore`
- **Verification Harness**: `scripts/verify-godot.sh`
- **PRD & EGM Design Docs**: `docs/prd/README.md`, `docs/designs/README.md`, `docs/GLOSSARY.md`
- **Knowledge Vault**: `.agents/vault/INDEX.md`
- **Vendored & Native Skills**: `.agents/skills/` (39 total: 15 engineering/anti-slop + 2 custom native + 22 curated Godot/JRPG/polish skills from `awesome-gamedev-agent-skills`)

## Maintenance Protocol
1. Run `detect_changes` before refactoring any `.gd` script once code exists.
2. Re-index with `index_repository(repo_path="/Users/dauzic/Documents/Code/Mana-Syndicate", mode="full")` after major PRD milestones and update this summary with core entry points, autoloads, and high fan-in domain classes.
