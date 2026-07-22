extends RefCounted
class_name AutomateCalendarAdapter

const SELECTED_ADDON := {
	"name": "Godot4xCalendarButton",
	"repository": "https://github.com/untamedlabs/Godot4xCalendarButton",
	"license": "MIT",
	"role": "Calendar picker and editor-facing date UI foundation."
}


func get_selected_addon() -> Dictionary:
	return SELECTED_ADDON.duplicate(true)
