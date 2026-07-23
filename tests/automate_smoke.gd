extends SceneTree

## Headless validation of the tick dispatcher, rule engine, and facade:
## apply order, converter limits, deficit reporting, inert unbound rules,
## and large-jump determinism.

func _init() -> void:
	call_deferred("_run")


func _fail(message: String) -> void:
	push_error(message)
	quit(1)


func _rules() -> Array:
	return [
		{"rule_id": "garden", "kind": "producer", "inputs": {}, "outputs": {"food": 2.0}},
		{"rule_id": "smelter", "kind": "converter", "inputs": {"ore": 2.0}, "outputs": {"ingot": 1.0}},
		{"rule_id": "henchman", "kind": "consumer", "inputs": {"food": 1.0}, "outputs": {}},
		{"rule_id": "keep", "kind": "upkeep", "inputs": {"gold": 5.0}, "outputs": {}}
	]


func _run() -> void:
	# Producers resolve before consumers: a same-tick harvest feeds the meal.
	var plan: Dictionary = AutomateRuleEngine.resolve_interval(
		_rules(),
		{"garden": 3, "henchman": 6},
		{"food": 0.0}
	)
	var stockpile: Dictionary = plan["stockpile"]
	if not is_equal_approx(float(stockpile.get("food", -1.0)), 0.0) or not plan["deficits"].is_empty():
		_fail("Producer output did not feed same-tick consumers: %s" % plan)
		return

	# Converters are limited to whole affordable conversions.
	plan = AutomateRuleEngine.resolve_interval(
		_rules(),
		{"smelter": 5},
		{"ore": 7.0}
	)
	stockpile = plan["stockpile"]
	if not is_equal_approx(float(stockpile.get("ingot", -1.0)), 3.0) \
			or not is_equal_approx(float(stockpile.get("ore", -1.0)), 1.0):
		_fail("Converter did not stop at affordable whole conversions: %s" % plan)
		return

	# Shortfalls clamp at zero and report deficits instead of going negative.
	plan = AutomateRuleEngine.resolve_interval(
		_rules(),
		{"henchman": 4, "keep": 1},
		{"food": 1.0, "gold": 2.0}
	)
	stockpile = plan["stockpile"]
	var deficits: Dictionary = plan["deficits"]
	if not is_equal_approx(float(stockpile.get("food", -1.0)), 0.0) \
			or not is_equal_approx(float(stockpile.get("gold", -1.0)), 0.0) \
			or not is_equal_approx(float(deficits.get("food", 0.0)), 3.0) \
			or not is_equal_approx(float(deficits.get("gold", 0.0)), 3.0):
		_fail("Consumer/upkeep shortfalls were not clamped and reported: %s" % plan)
		return

	# Idle rules (count 0 or unbound) contribute nothing.
	plan = AutomateRuleEngine.resolve_interval(_rules(), {}, {"food": 10.0, "ore": 10.0})
	if plan["stockpile"] != {"food": 10.0, "ore": 10.0} or not plan["applied"].is_empty():
		_fail("Unbound rules changed the stockpile: %s" % plan)
		return

	# AutomateRule resources resolve identically to dictionary rules.
	var garden_resource := AutomateRule.new()
	garden_resource.rule_id = "garden"
	garden_resource.kind = "producer"
	garden_resource.outputs = {"food": 2.0}
	plan = AutomateRuleEngine.resolve_interval([garden_resource], {"garden": 2}, {})
	if not is_equal_approx(float(plan["stockpile"].get("food", -1.0)), 4.0):
		_fail("AutomateRule resource did not resolve like a dictionary rule: %s" % plan)
		return

	# Dispatcher: one big advance matches the same number of single advances,
	# resolving the economy once per interval.
	var jump_result := _run_economy_through_dispatcher(5, 1)
	var stepped_result := _run_economy_through_dispatcher(1, 5)
	if jump_result != stepped_result:
		_fail("A 5-interval jump did not match five single advances: %s vs %s" % [jump_result, stepped_result])
		return

	# Facade exposes dispatcher construction, rule resolution, and the
	# foundation/user-story records.
	var facade: Node = load("res://addons/automate_godot/automate_godot.gd").new()
	root.add_child(facade)
	var facade_dispatcher: AutomateTickDispatcher = facade.create_tick_dispatcher()
	if facade_dispatcher == null:
		_fail("Facade did not create a tick dispatcher.")
		return
	plan = facade.resolve_interval(_rules(), {"garden": 1}, {})
	if not is_equal_approx(float(plan["stockpile"].get("food", -1.0)), 2.0):
		_fail("Facade rule resolution did not match the engine: %s" % plan)
		return
	var foundations: Dictionary = facade.get_foundations()
	if not foundations.has("calendar") or not foundations.has("crafting") \
			or facade.get_user_stories().is_empty():
		_fail("Facade foundation/user-story records are incomplete: %s" % foundations)
		return

	print("Automate smoke test passed.")
	quit(0)


func _run_economy_through_dispatcher(intervals_per_advance: int, advances: int) -> Dictionary:
	var dispatcher := AutomateTickDispatcher.new()
	var state := {"stockpile": {"food": 10.0, "ore": 7.0}}
	dispatcher.subscribe("economy", func(_interval: int) -> void:
		var plan: Dictionary = AutomateRuleEngine.resolve_interval(
			_rules(),
			{"garden": 1, "smelter": 1, "henchman": 3},
			state["stockpile"]
		)
		state["stockpile"] = plan["stockpile"]
	)
	for _advance in range(advances):
		dispatcher.advance(intervals_per_advance)
	state["intervals"] = dispatcher.intervals_elapsed_total
	return state
