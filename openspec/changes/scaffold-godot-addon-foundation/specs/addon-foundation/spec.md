## ADDED Requirements

### Requirement: Addon registration and stable API surface
The addon SHALL register through Godot's editor plugin system and expose its runtime API from a single `AutomateGodot` autoload.

#### Scenario: Plugin is enabled in a host project
- **GIVEN** a Godot 4.4+ project with the addon under `addons/automate_godot`
- **WHEN** the Automate Godot plugin is enabled in project settings
- **THEN** an `AutomateGodot` autoload is registered
- **AND** disabling the plugin removes the autoload cleanly.

### Requirement: Third-party integration seams
All contact with third-party addons SHALL go through per-dependency adapter files so upstream API drift is isolated from the addon core.

#### Scenario: Developer inspects chosen foundations
- **GIVEN** the addon is loaded
- **WHEN** the developer calls `AutomateGodot.get_foundations()`
- **THEN** the selected calendar and crafting foundations are reported with name, repository, license, and planned role.

### Requirement: Guiding user stories
The addon SHALL expose its guiding user stories programmatically so host games and tooling can display the intended scope.

#### Scenario: Host game lists addon direction
- **GIVEN** the addon is loaded
- **WHEN** `AutomateGodot.get_user_stories()` is called
- **THEN** the stories cover tick-driven automated crafting, calendar-aware completion windows, fail-safe third-party integration, and stockpiles/recipes behind a stable API.
