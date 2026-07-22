## ADDED Requirements

### Requirement: Deterministic tick dispatch
The addon SHALL provide a tick dispatcher that is the single integration point between game time and automation rules, resolving elapsed intervals one at a time.

#### Scenario: Large time jump
- **GIVEN** subscribers are registered on the dispatcher
- **WHEN** time advances thirty intervals in one call
- **THEN** each subscriber is invoked exactly thirty times in order
- **AND** the resulting state is identical to thirty single-interval advances.

### Requirement: Pure economy rule resolution
The addon SHALL resolve economy rules as a pure function from (rules, unit counts, stockpile) to (stockpile, deficits) with a fixed apply order: producer, converter, consumer, upkeep.

#### Scenario: Producer output feeds a same-tick consumer
- **GIVEN** a producer rule outputs food and a consumer rule requires food
- **WHEN** one interval resolves with an empty food stockpile
- **THEN** the producer's output is available to the consumer within that interval.

#### Scenario: Converter limited by inputs
- **GIVEN** a converter needs 2 ore per conversion and 7 ore is stocked
- **WHEN** one interval resolves with 5 bound converter units
- **THEN** exactly 3 conversions occur and 1 ore remains.

#### Scenario: Shortfall is reported, not negative
- **GIVEN** consumers need more of a resource than is stocked
- **WHEN** the interval resolves
- **THEN** the resource clamps at zero
- **AND** the shortfall amount is reported as a deficit for host-game pressure systems.

### Requirement: Headless validation
The rules core SHALL be validated by a headless smoke harness that runs without a display server.

#### Scenario: CI or developer runs the suite
- **GIVEN** a Godot binary and the repository
- **WHEN** `scripts/test-headless-smoke.sh` runs
- **THEN** apply order, converter limits, deficit reporting, and large-jump determinism are asserted.
