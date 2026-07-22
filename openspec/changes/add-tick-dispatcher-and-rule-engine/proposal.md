## Why
Every consumer of this addon needs the same automation core automate-fvtt proved out on Foundry: a single time seam that fans elapsed intervals out to subscribers, and a pure, deterministic economy rules engine that turns bound unit counts into stockpile deltas. burb-sweeper's survival tick (`scripts/survival_rules.gd`) independently validated the pure-core pattern in Godot and is the intended first consumer.

## What Changes
- Add `AutomateTickDispatcher`: the one integration point between game time and rules, resolving one interval at a time so large jumps match stepped time exactly.
- Add `AutomateRule` as an editor-authorable resource: producer / converter / consumer / upkeep kinds with per-unit inputs and outputs.
- Add `AutomateRuleEngine`: pure static interval resolution with a fixed apply order (producers and converters create before consumers and upkeep spend), affordable-whole converter limits, and zero-clamped deficit reporting.
- Add a headless smoke harness (`scripts/test-headless-smoke.sh` plus `tests/`) validating apply order, converter limits, deficits, and large-jump determinism.
- Expose the dispatcher and engine through the `AutomateGodot` facade.

## Impact
- Establishes the addon's core value: deterministic, testable automation independent of any scene tree.
- Deficit reporting gives survival games (burb-sweeper) their pressure signal; producers-before-consumers gives factory chains same-tick flow.
- The calendar and crafting integrations hang their behavior off this tick, not bespoke per-scene logic.
