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
project.godot
```
