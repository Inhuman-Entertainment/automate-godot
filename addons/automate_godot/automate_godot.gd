extends Node
class_name AutomateGodot

const CalendarAdapter = preload("res://addons/automate_godot/integrations/calendar_adapter.gd")
const CraftingAdapter = preload("res://addons/automate_godot/integrations/crafting_adapter.gd")

const ADDON_ID := "automate_godot"
const VERSION := "0.1.0"
const USER_STORIES: PackedStringArray = [
	"Automated crafting should run from shared time ticks.",
	"Calendar-aware crafting should support scheduled completion windows.",
	"Third-party addon integrations should fail safe when unavailable.",
	"Stockpiles and recipes should live behind a stable addon API."
]

var calendar_adapter: AutomateCalendarAdapter
var crafting_adapter: AutomateCraftingAdapter


func _ready() -> void:
	calendar_adapter = CalendarAdapter.new()
	crafting_adapter = CraftingAdapter.new()


func get_foundations() -> Dictionary:
	return {
		"calendar": calendar_adapter.get_selected_addon(),
		"crafting": crafting_adapter.get_selected_addon()
	}


func get_user_stories() -> PackedStringArray:
	return USER_STORIES.duplicate()


## Create a dispatcher for the host game's time unit. Games typically hold
## one and call advance() from their day/turn progression.
func create_tick_dispatcher() -> AutomateTickDispatcher:
	return AutomateTickDispatcher.new()


## Resolve one economy interval. See AutomateRuleEngine.resolve_interval.
func resolve_interval(rules: Array, counts: Dictionary, stockpile: Dictionary) -> Dictionary:
	return AutomateRuleEngine.resolve_interval(rules, counts, stockpile)
