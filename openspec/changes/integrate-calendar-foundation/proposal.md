## Why
Calendared crafting needs a date-facing surface: scheduled completion windows, day/date display, and pick-a-date interactions. `Godot4xCalendarButton` (MIT) was selected as the calendar UI foundation; `automate-godot` keeps ownership of time progression and intervals while the upstream addon supplies the picker surface.

## What Changes
- Grow `integrations/calendar_adapter.gd` from a foundation record into a working seam: detect whether the upstream calendar addon is installed, and stay inert when it is not.
- Map dispatcher intervals to calendar dates (epoch date plus interval unit) so rules can express calendar-aware completion windows.
- Surface scheduled-completion queries: given a job's remaining intervals, report its completion date.
- Vendor or document installation of `Godot4xCalendarButton` for the sample project.

## Impact
- Completion windows become date-addressable ("ready on the 14th") instead of interval counts only.
- Host games without the upstream addon keep full automation behavior; only the date UI surface is absent.
- Upstream drift in the calendar addon stays confined to the adapter.
