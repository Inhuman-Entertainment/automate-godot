extends Resource
class_name AutomateRule

## One economy rule: converts a bound unit count into stockpile deltas per
## elapsed interval. Kinds resolve in AutomateRuleEngine.KIND_ORDER so a
## producer's output can feed a consumer within the same tick.
##
## - producer: adds `outputs` per unit; `inputs` ignored.
## - converter: consumes `inputs` and adds `outputs` per unit, limited to the
##   whole conversions the stockpile can afford.
## - consumer / upkeep: consumes `inputs` per unit, clamped at zero; any
##   shortfall is reported as a deficit rather than going negative.

@export var rule_id: String = ""
@export_enum("producer", "converter", "consumer", "upkeep") var kind: String = "producer"
## resource -> qty consumed per unit per interval.
@export var inputs: Dictionary = {}
## resource -> qty produced per unit per interval.
@export var outputs: Dictionary = {}
