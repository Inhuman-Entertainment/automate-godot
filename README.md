# automate-godot

A Godot addon for automated or calendared crafting in simulation-heavy games — the Godot counterpart to [`automate-fvtt`](https://github.com/buddha314/automate-fvtt).

## Phase 0 foundation

This repository now contains the initial Godot addon scaffold:

- `project.godot` sample project for opening the addon in Godot
- `addons/automate_godot/plugin.cfg` addon manifest for editor registration
- `addons/automate_godot/plugin.gd` editor plugin entry point
- `addons/automate_godot/automate_godot.gd` runtime facade/autoload
- `addons/automate_godot/integrations/*.gd` seams for third-party addon integration
- `addons/automate_godot/icon.svg` addon/project icon

## Chosen foundations

The first pass mirrors the `automate-fvtt` approach: keep third-party integration behind a narrow seam so upstream addon drift is isolated.

### Calendar foundation

- **Selected base:** [`untamedlabs/Godot4xCalendarButton`](https://github.com/untamedlabs/Godot4xCalendarButton)
- **Why:** it is a focused Godot 4.x calendar addon, MIT licensed, and already packaged as a Godot editor addon.
- **Planned role:** provide the date-picking/editor-facing surface while `automate-godot` owns time progression, intervals, and gameplay rules.

### Crafting foundation

- **Selected base:** [`noufbmdev/Godot-Systems`](https://github.com/noufbmdev/Godot-Systems)
- **Why:** it is MIT licensed and is the closest open-source Godot foundation spanning inventory, crafting, and date/time concerns, even though the crafting/time pieces are still marked "Not Ready".
- **Planned role:** use its modular system layout as the architectural baseline while `automate-godot` defines a store-ready crafting adapter around recipe, stockpile, and tick-driven automation stories.

### Notes on trade-offs

There does not appear to be a mature, Godot-asset-library-ready crafting addon with the exact `automate-fvtt` scope today. This scaffold therefore establishes integration seams first so we can adopt upstream pieces selectively without coupling the addon core to any single external project.

## Tick dispatcher and rule engine

The automation core lives in `time/` and `rules/`, ported from automate-fvtt's
rules engine:

- **`AutomateTickDispatcher`** is the one integration point between game time
  and rules. It fans elapsed intervals out to subscribers one interval at a
  time, so a large jump (a year in one step) resolves identically to the same
  number of single-interval advances. The interval unit is the host game's
  choice.
- **`AutomateRule`** is an editor-authorable resource (plain dictionaries with
  the same fields also work): a producer / converter / consumer / upkeep kind
  with per-unit `inputs` and `outputs`.
- **`AutomateRuleEngine.resolve_interval(rules, counts, stockpile)`** is pure
  and static. Producers and converters create resources before consumers and
  upkeep spend them, so a tick can feed downstream rules from upstream output.
  Converters stop at affordable whole conversions. Shortfalls clamp at zero
  and are reported in a `deficits` dictionary — the pressure signal for
  survival-style consumers.

```gdscript
var dispatcher: AutomateTickDispatcher = AutomateGodot.create_tick_dispatcher()
var stockpile := {"food": 10.0, "ore": 7.0}
var rules := [
    {"rule_id": "garden", "kind": "producer", "inputs": {}, "outputs": {"food": 2.0}},
    {"rule_id": "smelter", "kind": "converter", "inputs": {"ore": 2.0}, "outputs": {"ingot": 1.0}},
    {"rule_id": "henchman", "kind": "consumer", "inputs": {"food": 1.0}, "outputs": {}},
]

dispatcher.subscribe("economy", func(_interval: int) -> void:
    var plan := AutomateGodot.resolve_interval(rules, {"garden": 1, "smelter": 1, "henchman": 3}, stockpile)
    stockpile = plan["stockpile"]
    # plan["deficits"] lists unmet consumption for host-game pressure systems.
)

dispatcher.advance(1)      # one day
dispatcher.advance(30)     # a month — same result as thirty single days
```

Validate headless with:

```text
GODOT_BIN=/path/to/godot ./scripts/test-headless-smoke.sh
```

## Initial user-story direction

The first implementation passes should stay aligned with the `automate-fvtt` direction:

1. expose a stable addon API from one place
2. isolate third-party calendar/crafting dependencies behind adapters
3. support stockpiles/recipes as the gameplay model
4. drive automation from time ticks instead of per-scene bespoke logic
5. stay inert when optional upstream dependencies are unavailable

## Local setup

1. Open `/home/runner/work/automate-godot/automate-godot` in Godot 4.4 or newer.
2. Confirm the **Automate Godot** plugin is enabled under **Project > Project Settings > Plugins**.
3. The plugin registers an `AutomateGodot` autoload that will become the stable runtime API surface for future work.

## Repository layout

```text
addons/automate_godot/
  automate_godot.gd
  icon.svg
  plugin.cfg
  plugin.gd
  integrations/
    calendar_adapter.gd
    crafting_adapter.gd
  rules/
    rule.gd
    rule_engine.gd
  time/
    tick_dispatcher.gd
openspec/
  changes/
project.godot
scripts/
  test-headless-smoke.sh
tests/
  automate_smoke.gd
```
