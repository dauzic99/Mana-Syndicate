# Godot 4.x 2.5D AI Anti-Bug Shields

Concrete patterns to prevent the most common LLM mistakes in Godot 4.x 2.5D projects.

## Shield 1: Godot 4.x Syntax Purity (No Godot 3)
| Trap (Godot 3 — Forbidden) | Correct (Godot 4.x — Required) |
| :--- | :--- |
| `export(float) var speed = 5.0` | `@export var speed: float = 5.0` |
| `onready var visuals = $Visuals` | `@onready var visuals: Node3D = $Visuals as Node3D` |
| `velocity = move_and_slide(velocity)` | `velocity = desired_vel; move_and_slide()` |
| `emit_signal("mana_changed", amount)` | `mana_changed.emit(amount)` |
| `btn.connect("pressed", self, "_on_btn")` | `btn.pressed.connect(_on_btn)` |
| `yield(get_tree().create_timer(0.5), "timeout")` | `await get_tree().create_timer(0.5).timeout` |
| `scene.instance()` | `scene.instantiate()` |

## Shield 2: Strict Static Typing
```gdscript
class_name ManaPool
extends RefCounted

signal mana_changed(current: int, maximum: int)

var _current: int = 0
var _maximum: int = 10

func spend(amount: int) -> bool:
	if amount < 0 or amount > _current:
		return false
	_current -= amount
	mana_changed.emit(_current, _maximum)
	return true
```

## Shield 3: Lifecycle & Physics-Callback Safety
```gdscript
func _on_hit_flash() -> void:
	await get_tree().create_timer(0.15).timeout
	if not is_instance_valid(self):
		return
	_visuals.modulate = Color.WHITE

func _on_hurtbox_area_entered(area: Area3D) -> void:
	# Never mutate collision monitoring synchronously inside an area callback
	_hurtbox.set_deferred("monitoring", false)
```

## Shield 4: 2.5D `SubViewport` & `Sprite3D` Performance
- Set `SubViewport.transparent_bg = true`.
- Throttle `SubViewport.render_target_update_mode` to `SubViewport.UPDATE_WHEN_VISIBLE` (or `UPDATE_ONCE` for static portraits/cards).
- On `Sprite3D`, set `alpha_cut = SpriteBase3D.ALPHA_CUT_OPAQUE_PREPASS` (or `DISCARD`) so overlapping 2.5D sprites sort cleanly in 3D depth without semi-transparent z-fighting.
- For pixel art, set `texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST`.

## Shield 5: `.tscn` & `.uid` Safety
- Never hand-edit `ext_resource` IDs or `sub_resource` blocks in complex `.tscn` files.
- Always commit `*.uid` and `*.import` files to git so Godot 4.4+ references never break across machines.
