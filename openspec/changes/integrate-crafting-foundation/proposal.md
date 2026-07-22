## Why
Automated crafting needs a gameplay model — stockpiles and recipes — and a seam to an actual crafting implementation. No mature, asset-library-ready Godot crafting addon matches the automate-fvtt scope today, so `Godot-Systems` (MIT) serves as the architectural baseline while `automate-godot` defines its own store-ready crafting contract, exactly as automate-fvtt wraps Fabricate behind one adapter.

## What Changes
- Define the stockpile model: a resource-to-quantity store with counts, owned by the addon and exposed through the `AutomateGodot` facade.
- Define the recipe contract: identifier, display name, inputs, outputs, and craft duration in intervals.
- Grow `integrations/crafting_adapter.gd` from a foundation record into the working seam: recipe listing, affordability checks, and craft execution against a stockpile, inert when no crafting system is installed.
- Connect crafting to the tick: started crafts consume inputs up front and deliver outputs when their intervals elapse.

## Impact
- Stockpiles and recipes become the shared gameplay vocabulary for all consumers (the automate-fvtt Keep model, burb-sweeper materials, future titles).
- Rule-driven automation and player-driven crafting run through the same stockpile, so automated production can feed manual crafts and vice versa.
- A future dedicated Godot crafting addon can be adopted by reimplementing one adapter file.
