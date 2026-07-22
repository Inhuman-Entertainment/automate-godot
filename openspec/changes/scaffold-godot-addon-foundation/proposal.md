## Why
Automation and calendared crafting were prototyped inside automate-fvtt (Foundry VTT) and burb-sweeper (Godot). Both games need the same core — tick-driven economy rules behind narrow third-party seams — so the shared machinery moves to an independent Godot addon that either game, and future titles, can consume.

## What Changes
- Create the `automate-godot` repository as a Godot 4 addon with a sample `project.godot` for development.
- Register an editor plugin that installs an `AutomateGodot` autoload as the single stable runtime API surface.
- Record the selected third-party foundations behind integration seams: `Godot4xCalendarButton` (calendar UI) and `Godot-Systems` (inventory/crafting architectural baseline).
- Establish the guiding user stories: shared time ticks drive automated crafting, calendar-aware completion windows, fail-safe behavior when upstream addons are unavailable, and stockpiles/recipes behind a stable API.

## Impact
- Gives automation work a home independent of any one game, mirroring automate-fvtt's role on Foundry.
- Isolates upstream addon drift to one adapter file per dependency, so the core never couples to an external project.
- Later changes build on this foundation: the tick/rules core, then real calendar and crafting integrations.
