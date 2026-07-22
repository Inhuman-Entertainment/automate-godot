## ADDED Requirements

### Requirement: Fail-safe calendar seam
The calendar adapter SHALL detect the upstream calendar addon at runtime and stay inert when it is unavailable, without degrading core automation.

#### Scenario: Upstream addon missing
- **GIVEN** a host project without `Godot4xCalendarButton` installed
- **WHEN** the addon initializes
- **THEN** `calendar_adapter.is_available()` reports false
- **AND** tick dispatch and rule resolution behave identically to a project with the calendar installed.

### Requirement: Interval-to-date mapping
The addon SHALL map dispatcher intervals to calendar dates from a configurable epoch and interval unit.

#### Scenario: Completion date for an active job
- **GIVEN** an epoch date, a one-day interval unit, and a job with 5 intervals remaining
- **WHEN** the completion date is queried on interval 10
- **THEN** the reported date is the epoch plus 15 days.
