# Future Mountain Design Concept

Last updated: 2026-06-12

## Purpose

Future Mountain is an interactive 3D climate and watershed visualization. It turns RHESSys model outputs into a spatial experience where visitors can see how climate warming, water availability, fire, soil, and vegetation interact across a real landscape.

The current project centers on the Big Creek watershed in the Sierra Nevada. It was developed as part of the Burn Cycle Project with artist Ethan Turpin and UCSB ecohydrologist Naomi Tague, building from the RHESSys model developed by the Tague Lab at UCSB.

## Experience Goals

- Make long-term ecohydrologic model output legible to non-specialist audiences.
- Let visitors explore rather than only watch: change warming level, move through time, inspect terrain cubes, and compare scenarios.
- Connect abstract climate data to visible landscape changes: snow, groundwater depth, streamflow, vegetation growth, evapotranspiration, soil/litter, and fire.
- Support exhibition use where the experience must load quickly, run reliably, and be understandable with minimal facilitation.
- Preserve enough scientific structure that the visualization can be adapted to new scenarios, including a planned Central Coast scenario.

## Current Conceptual Model

The scene combines two complementary scales:

- A full terrain view representing the watershed-level landscape.
- A set of detailed terrain cubes representing selected patches or aggregate conditions.

The aggregate cube summarizes watershed-average behavior. Individual cubes expose local variation. Side-by-side mode lets a user compare one cube against another warming scenario at the same point in simulated time.

## Interaction Concept

The user can:

- Choose a warming scenario: baseline, +1 C, +2 C, +4 C, or +6 C.
- Start and pause the simulation.
- Control the speed of time.
- Scrub or jump through years on a timeline.
- Zoom into individual terrain cubes.
- Enter side-by-side mode to compare warming scenarios.
- Toggle model/statistics displays where available.

The visual language emphasizes living systems rather than charts alone. Data drives geometry, particles, terrain textures, water levels, snow coverage, plant growth, roots, litter, and fire behavior.

## Important Design Tensions

- Scientific fidelity vs. exhibition clarity: the experience should show meaningful model relationships without overwhelming visitors with raw variables.
- Performance vs. density: vegetation, particles, terrain textures, and WebGL constraints require careful balancing.
- Scenario specificity vs. reuse: Big Creek assumptions are still embedded in code, data contracts, scene content, and UI. The Central Coast scenario should separate scenario configuration from reusable visualization behavior where practical.



