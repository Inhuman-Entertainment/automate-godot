## Tasks
- [ ] Add a stockpile store (resource -> qty plus counts) with zero-clamped spend and shortfall reporting.
- [ ] Define the recipe contract: `recipe_id`, display name, `inputs`, `outputs`, and duration in intervals.
- [ ] Grow `crafting_adapter.gd` into the working seam: `is_available()`, `list_recipes()`, affordability checks, and `craft()` against a stockpile.
- [ ] Keep the adapter inert (empty results, no errors) when no crafting system is installed.
- [ ] Drive craft completion from dispatcher intervals: consume inputs at start, deliver outputs when the duration elapses.
- [ ] Evaluate `Godot-Systems` modules for direct reuse vs. reimplementation and record the outcome per module.
- [ ] Add headless tests for stockpile clamping, timed craft completion, and inert-when-missing behavior.
- [ ] Document the crafting contract and adapter expectations in the README.
