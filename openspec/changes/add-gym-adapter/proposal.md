## Why
> **Status: deferred — not near-term.** Sequenced after the calendar and crafting integrations; its first consumer is burb-sweeper's `add-rl-gym-environment` change.

Any game built on a pure tick-rules core (burb-sweeper's `SurvivalRules`, this addon's `AutomateRuleEngine`) can step its simulation without a scene tree. That makes reinforcement-learning training unusually cheap: one headless process can hold hundreds of independent state dictionaries and advance all of them per frame — orders of magnitude beyond frame-locked training. [Godot RL Agents](https://github.com/edbeeching/godot_rl_agents) provides the Godot-to-Gymnasium bridge (Sync node, Python wrappers for SB3/CleanRL/Rllib/Sample Factory) but assumes one embodied agent per scene; the missing piece is a generic adapter that exposes pure rules cores as vectorized environments. That adapter is engine-agnostic across games and belongs in this addon, beside the calendar and crafting seams.

## What Changes
- Add a **gym adapter seam** following the addon's one-seam-per-external-system rule: all godot-rl-agents contact isolated to one integration file, inert when the plugin is absent.
- Define the **environment contract** a host game implements over its rules core: `reset() -> state`, `step(state, action) -> {state, observation, reward, done}`, plus observation/action space descriptors and optional action masks.
- Add a **vectorized batch environment node** that owns N independent environment instances and steps them all per tick, reporting batched observations/rewards to the bridge.
- Deployment stays out of scope here: trained policies run in-game via godot-rl's ONNX support or the [native ncnn runner](https://godotengine.org/asset-library/asset/5358).

## Impact
- Turns every automate-godot consumer's pure rules core into a high-throughput RL training environment for free.
- Keeps godot-rl-agents API drift isolated to one file, matching the Fabricate/calendar/crafting adapter pattern.
- burb-sweeper validates the contract as first consumer; the addon gains a differentiating capability no other Godot package offers.
