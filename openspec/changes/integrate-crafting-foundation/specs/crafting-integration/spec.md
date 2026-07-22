## ADDED Requirements

### Requirement: Stockpile model
The addon SHALL provide a stockpile store mapping resources to quantities, with quantities clamped at zero.

#### Scenario: Resources are added and spent
- **GIVEN** an empty stockpile
- **WHEN** 5 wood is added and 8 wood is spent
- **THEN** the stockpile reports 0 wood
- **AND** the 3-wood shortfall is reported to the caller.

### Requirement: Recipe contract
Recipes SHALL declare identifier, display name, inputs, outputs, and craft duration in intervals, regardless of which crafting system backs them.

#### Scenario: Craft resolves over time
- **GIVEN** a recipe with a 3-interval duration and sufficient inputs
- **WHEN** the craft starts and 3 intervals elapse
- **THEN** inputs are consumed at start
- **AND** outputs are delivered on completion, not before.

### Requirement: Fail-safe crafting seam
The crafting adapter SHALL stay inert when no crafting system is installed: no recipes listed, no crafts executed, no errors raised.

#### Scenario: No crafting system installed
- **GIVEN** a host project with no crafting backend
- **WHEN** recipes are listed or a craft is attempted
- **THEN** the adapter reports unavailability and empty results
- **AND** tick-driven rule automation continues unaffected.
