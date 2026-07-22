## Tasks
- [ ] Add `AutomateTickDispatcher` with subscribe/unsubscribe, per-interval fan-out, an `interval_elapsed` signal, and a running interval counter.
- [ ] Add `AutomateRule` resource: `rule_id`, kind enum (producer/converter/consumer/upkeep), and per-unit `inputs`/`outputs` dictionaries.
- [ ] Add `AutomateRuleEngine.resolve_interval(rules, counts, stockpile)` with the fixed KIND_ORDER apply order.
- [ ] Limit converters to affordable whole conversions.
- [ ] Clamp consumer/upkeep shortfalls at zero and report them in a deficits dictionary.
- [ ] Accept rules as either `AutomateRule` resources or plain dictionaries with the same fields.
- [ ] Expose dispatcher construction and rule resolution through the `AutomateGodot` facade.
- [ ] Add `scripts/test-headless-smoke.sh` and `tests/automate_smoke.gd` covering apply order, converter limits, deficits, inert unbound rules, and large-jump determinism.
- [ ] Document the tick/rules architecture and usage example in the README.
