extends RefCounted
class_name AutomateRuleEngine

## Pure economy resolution, ported from automate-fvtt's rules core. Static and
## side-effect free: it touches no scene-tree or autoload state, so plans can
## be unit-tested headless and re-run deterministically. Callers resolve one
## interval per call (drive it from AutomateTickDispatcher) so large time
## jumps stay step-size independent.

## Apply order when several rules touch the same resource in one tick.
## Producers and converters create resources before consumers/upkeep spend
## them, so a tick can feed a downstream rule from an upstream rule's output.
const KIND_ORDER := ["producer", "converter", "consumer", "upkeep"]


## Resolve one interval. `rules` is an Array of AutomateRule (or Dictionaries
## with the same fields), `counts` maps rule_id -> bound unit count, and
## `stockpile` maps resource -> qty. Returns:
##   {"stockpile": Dictionary, "deficits": Dictionary, "applied": Array}
## Deficits report each consumer/upkeep shortfall instead of going negative.
static func resolve_interval(rules: Array, counts: Dictionary, stockpile: Dictionary) -> Dictionary:
	var working: Dictionary = stockpile.duplicate(true)
	var deficits: Dictionary = {}
	var applied: Array = []

	for kind in KIND_ORDER:
		for rule in rules:
			if str(_rule_field(rule, "kind", "producer")) != kind:
				continue
			var rule_id := str(_rule_field(rule, "rule_id", ""))
			var count := int(counts.get(rule_id, 0))
			if count <= 0:
				continue
			var inputs: Dictionary = _rule_field(rule, "inputs", {})
			var outputs: Dictionary = _rule_field(rule, "outputs", {})
			match kind:
				"producer":
					_add_scaled(working, outputs, count)
					applied.append({"rule_id": rule_id, "kind": kind, "units": count})
				"converter":
					var conversions := _affordable_conversions(working, inputs, count)
					if conversions > 0:
						_add_scaled(working, inputs, -conversions)
						_add_scaled(working, outputs, conversions)
					applied.append({"rule_id": rule_id, "kind": kind, "units": conversions})
				"consumer", "upkeep":
					for resource in inputs.keys():
						var need: float = float(inputs[resource]) * float(count)
						if need <= 0.0:
							continue
						var available: float = float(working.get(resource, 0.0))
						if available < need:
							deficits[resource] = float(deficits.get(resource, 0.0)) + (need - available)
						working[resource] = max(available - need, 0.0)
					applied.append({"rule_id": rule_id, "kind": kind, "units": count})

	return {"stockpile": working, "deficits": deficits, "applied": applied}


## Whole conversions the stockpile can afford, capped at the bound unit count.
static func _affordable_conversions(stockpile: Dictionary, inputs: Dictionary, count: int) -> int:
	var conversions := count
	for resource in inputs.keys():
		var per_unit: float = float(inputs[resource])
		if per_unit <= 0.0:
			continue
		var available: float = float(stockpile.get(resource, 0.0))
		conversions = min(conversions, int(floor(available / per_unit)))
	return max(conversions, 0)


static func _add_scaled(stockpile: Dictionary, amounts: Dictionary, factor: int) -> void:
	for resource in amounts.keys():
		var delta: float = float(amounts[resource]) * float(factor)
		stockpile[resource] = max(float(stockpile.get(resource, 0.0)) + delta, 0.0)


static func _rule_field(rule: Variant, field: String, fallback: Variant) -> Variant:
	if rule is Dictionary:
		return rule.get(field, fallback)
	return rule.get(field)
