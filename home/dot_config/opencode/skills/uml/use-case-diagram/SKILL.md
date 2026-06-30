---
name: figma-use-case-diagram
description: Create evidence-based UML use case diagrams in Figma for software projects. Use when the user asks to draw, create, update, or fix a UML use case diagram, especially in Figma, from a codebase, repository, thesis project, requirements document, API implementation, or existing system documentation. Also use when the user asks to avoid label overlap, export diagrams cleanly, or make use case diagrams suitable for reports or graduation design documents.
---

# Figma Use Case Diagram

## Overview

Create UML use case diagrams in Figma from real project evidence. Prefer implemented behavior over guesses, draw editable Figma nodes, and validate the diagram so relation labels do not cover use case text.

This skill may be routed from the root `uml` skill when the requested diagram type is `UML 用例图` or `用例图`.

## Required Companion Skills

- If writing to Figma, load and follow `figma-use` before every `use_figma` call.
- If the user explicitly asks for a Mermaid/FigJam flowchart instead of a Figma design use case diagram, use the Figma diagram skill only if the requested diagram type is supported. UML use case diagrams are not supported by `generate_diagram`; build them with `use_figma`.

## Workflow

1. Identify the target:
   - Figma URL or file key;
   - project path or document source;
   - whether to create a new diagram, update an existing one, or fix layout issues.
2. Gather evidence before drawing:
   - read README, requirements, package manifests, API routes/controllers/resolvers, auth/permission code, database schema/migrations, CLI commands, worker/daemon code, and tests relevant to the system;
   - use fast search tools such as `rg` and file listing tools such as `fd`;
   - do not invent actors, use cases, roles, endpoints, or system components.
3. Derive UML content:
   - actors: human roles first, then external systems/processes when they initiate interactions;
   - use cases: user-visible goals or system operations, not every function/class;
   - relationships: use `include` only for mandatory sub-behavior and `extend` for optional/conditional behavior;
   - system boundary: name it after the actual application or subsystem.
4. Draw in Figma:
   - create or reuse one named frame for the diagram;
   - preserve unrelated template nodes;
   - use editable text, ellipses, vectors/lines, and frames;
   - use vector paths for connector lines when precise endpoints matter;
   - put evidence notes or a short source note beside the diagram when useful for academic reports.
5. Validate and iterate:
   - run collision detection for relation labels against use case nodes;
   - fix label positions before final response;
   - return the Figma link and mention what changed.

## Layout Rules

- Put actors outside the system boundary and use cases inside it.
- Keep use case names short enough to fit in the ellipse.
- Group related use cases with subtle frames only when the diagram has more than about 10 use cases.
- Avoid crossing long diagonal connectors when a local association or relationship is clearer.
- Place `include` / `extend` tags outside ellipse text areas. Small tags are acceptable; covered use case text is not.
- Use colors sparingly to distinguish actor domains or subsystems, not as the main semantic carrier.
- Add a legend only when colors or relationship notation need explanation.

## Figma Implementation Notes

- Always inspect the target file/page first. Starter files may have a three-page limit; if `createPage()` fails, place the diagram on an existing page in clear space.
- Use `await figma.setCurrentPageAsync(page)` once per `use_figma` call.
- Load fonts before editing text. For Chinese labels, prefer an available CJK font such as `Noto Sans SC` when present.
- Return all created or mutated node IDs from every write script.
- If replacing a generated diagram, remove only a node with the exact generated frame name.
- Use `await frame.screenshot()` after drawing for quick visual QA.

## Collision Validation

Use the reference workflow in `references/figma-use-case-workflow.md` when generating or fixing diagrams. It includes a reusable collision check for relation labels.

For label-only fixes, do not redraw the whole diagram. Inspect nodes named like `关系标注 / include` or `关系标注 / extend`, compare their bounding boxes against nodes named like `用例 / ...`, then move or shrink only the labels.

## Final Response

Keep the final response concise:

- include the Figma link with the node ID when available;
- state whether it was created, updated, or fixed;
- mention any limitations, such as unsupported features, missing project evidence, or export caveats.
