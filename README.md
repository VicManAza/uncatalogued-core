# ᵁᴺcatalogued

visionOS spatial interaction framework (SwiftUI + RealityKit)

Minimal spatial conditioning system for Apple Vision Pro.

Chapter 1 establishes motor fluency and subconscious trust before gameplay begins.

No exposition.
No tutorial walls.
Only calibrated interaction.

---

## Status

Phase: **Chapter 1 — Motor Conditioning Build**

Platform: **visionOS**
Language: **Swift (SwiftUI + RealityKit)**
Environment: **Xcode**

Web prototype exists (Figma).
Native spatial build underway.

---

## Core Premise

ᵁᴺ — classification marker
catalogued — stable, grounded system

The prefix behaves like metadata.
The core name remains human.

The experience trains spatial confidence before revealing purpose.

Users are not instructed.
They are conditioned.

---

## Design Doctrine 🧊

* Minimal. Intentional. Unexplained.
* Every motion is time-bounded.
* Every response is under 300ms.
* No decorative animation.
* No theatrical transitions.
* No emotional UI.

Interaction builds trust through restraint.

---

## Visual Behavior Rules

Allowed:

* Soft static fade-in
* Phosphor halo glow (30–35%)
* Neutral depth layering

Forbidden:

* Bounce
* Slide
* Rotation as flair
* Gradient backgrounds
* Serif typography
* Heavy bold usage
* Center alignment (except isolated hero state)

Fade-out duration: **0.4 seconds maximum**

---

## Chapter 1 — Motor Conditioning Loop 🌀

Sequential progression. No branching.

1. Gaze → *(Hidden: Pinch)*
2. Pinch → *(Hidden: Drag)*
3. Drag → *(Hidden: Rotate)*
4. Rotate → *(Hidden: Scale)*
5. Scale → *(Hidden: Depth Push)*
6. Depth Push → *(Hidden: Window Move)*
7. Window Move → *(Hidden: Anchor)*
8. Anchor → *(Hidden: Occlusion)*
9. Occlusion → *(Hidden: Recenter)*
10. Recenter → *(Hidden: Cancel)*
11. Cancel → *(Hidden: Double Confirm)*
12. Double Confirm → *(Hidden: Passive Presence)*

Each lesson:

* One explicit action
* One silent preview
* Less than 7 seconds
* Immediate feedback (< 300ms)
* No textual instruction

Mastery is implied, never announced.

---

## System Architecture

SwiftUI
→ Application shell
→ Deterministic state machine
→ Timing-governed transitions

RealityKit
→ Spatial entities
→ Interaction surfaces
→ Depth logic
→ Occlusion handling

Chapter 1 transitions are:

* Linear
* Time-bounded
* Non-branching
* Reversible only through explicit cancel state

---

## Core Files

* `LessonEngine.swift` — State progression controller
* `LessonConfig.swift` — Lesson definitions + thresholds
* `TimingConstants.swift` — Global interaction caps
* `PortalSceneView.swift` — RealityKit container
* `UncataloguedTitle.swift` — Identity presentation layer

---

## Interaction Constraints

Dwell threshold: **800ms**
Cancel threshold: **300ms**
Foreground animation cap: **800ms**
Confirmation cap: **400ms**
Transition cap: **700ms**

No external services required.

All logic executes locally.

---

## Long-Term Direction

* Expand adaptive response layer
* Introduce hesitation detection
* Transition from conditioning to spatial gameplay
* Preserve minimal doctrine across all future chapters

ᵁᴺcatalogued is not an interface.
It is a behavioral calibration system.
