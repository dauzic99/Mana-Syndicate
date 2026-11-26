# Coding Efficiency & Toolchain Setup (macOS)

Current local scan found `python3`, `pip3`, `uv`, and `brew` installed, while **Godot 4 CLI** and **`gdtoolkit`** are not yet installed. Run these when you are ready to compile and run headless tests.

## 1. Install Godot 4.x + CLI Access
```bash
brew install --cask godot
# Verify CLI symlink (or add Godot.app/Contents/MacOS/Godot to PATH)
godot --version
```

## 2. Install `gdtoolkit` (`gdlint` + `gdformat`)
```bash
uv tool install gdtoolkit
# Verify
gdlint --version && gdformat --version
```

## 3. Install GUT (Godot Unit Test)
Once `project.godot` exists:
- Install **GUT** from the Godot AssetLib inside the editor (or clone into `addons/gut/`).
- Verify headless test runner:
  ```bash
  godot --headless --path . -s addons/gut/gut_cmdl.gd -gdir=res://tests -gexit
  ```

## 4. Official Antigravity EGM Plugin
Install **Elephant-Goldfish Model** (`antigravity-plugins-official/plugin/egm`) from the Antigravity Marketplace card so `egm-brainstorm`, `egm-draft`, `egm-review`, `egm-resolve`, and `egm-bootstrap` are available natively alongside `.agents/skills/egm-workflow/SKILL.md`.

## 5. Editor, Headless Testing & Agent Efficiency Tips
- **Godot 4 Headless Import & Exit Codes**: Because `.godot/` is gitignored, run `godot --headless --path . --import` on fresh Mac/Windows clones before running tests so `class_name` types resolve. Godot exits `0` even on `SCRIPT ERROR` unless the runner explicitly calls `quit(1)`, so `./scripts/verify-godot.sh` uses `check_scripts_compile.gd` (or `tests/test_runner.gd` / GUT `-gexit`).
- **Godot Editor -> External Script Editor**: Enable **Use External Editor** if editing GDScript in your IDE, and enable **Editor Settings -> Network -> Language Server** (port `6005`) for live GDScript diagnostics.
- **AST Graph Refresh**: After adding or refactoring `.gd` scripts, run `codebase-memory-mcp` `index_repository(repo_path="/Users/dauzic/Documents/Code/Mana-Syndicate", mode="full")` and update `.agents/memory/GRAPH_SUMMARY.md`.
