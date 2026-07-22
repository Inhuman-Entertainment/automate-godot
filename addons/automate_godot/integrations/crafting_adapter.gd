extends RefCounted
class_name AutomateCraftingAdapter

const SELECTED_ADDON := {
	"name": "Godot-Systems",
	"repository": "https://github.com/noufbmdev/Godot-Systems",
	"license": "MIT",
	"role": "Architectural baseline for modular inventory, crafting, and time systems."
}


func get_selected_addon() -> Dictionary:
	return SELECTED_ADDON.duplicate(true)
