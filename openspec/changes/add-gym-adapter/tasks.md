## Tasks
> Deferred — not near-term. Sequenced after integrate-calendar-foundation and integrate-crafting-foundation; first consumer is burb-sweeper's add-rl-gym-environment.

- [ ] Define the environment contract: reset/step signatures, observation and action space descriptors, optional action masks, deterministic seeding.
- [ ] Add the vectorized batch environment owning N independent instances stepped per tick with batched reporting.
- [ ] Add the godot-rl-agents bridge seam (one integration file, inert when the plugin is absent).
- [ ] Provide a reference environment over AutomateRuleEngine (stockpile economy survival toy) for tests and documentation.
- [ ] Validate determinism, batch stepping, and inert-when-missing behavior in the headless smoke suite.
- [ ] Document the contract and the burb-sweeper consumer path in the README.
