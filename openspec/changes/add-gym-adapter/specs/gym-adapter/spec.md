## ADDED Requirements

### Requirement: Environment contract over pure rules cores
The addon SHALL define an environment contract that host games implement over a pure tick-rules core: reset, step (state, action to state, observation, reward, done), observation/action space descriptors, and optional action masks.

#### Scenario: Host game implements the contract
- **GIVEN** a game with a pure, scene-free tick resolver
- **WHEN** it implements the environment contract
- **THEN** episodes can be stepped headlessly with no scene tree or rendering
- **AND** identical seeds and actions produce identical trajectories.

### Requirement: Vectorized batch stepping
The addon SHALL provide a batch environment that owns N independent environment instances and steps all of them per tick.

#### Scenario: Parallel training batch
- **GIVEN** a batch environment configured with N instances
- **WHEN** one tick elapses
- **THEN** all N instances advance independently
- **AND** observations, rewards, and done flags are reported as batches.

### Requirement: Fail-safe bridge seam
All godot-rl-agents contact SHALL go through one adapter file that stays inert when the plugin is unavailable.

#### Scenario: Training plugin absent
- **GIVEN** a host project without godot-rl-agents installed
- **WHEN** the addon initializes
- **THEN** the gym adapter reports unavailability
- **AND** all other addon behavior is unaffected.
