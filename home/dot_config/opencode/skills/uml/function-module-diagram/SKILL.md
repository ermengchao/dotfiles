---
name: svg-function-module-diagram
description: Use when creating thesis/report-style functional module diagrams as hand-written SVG XML, especially tree-structured diagrams with vertical Chinese labels where Mermaid is unsuitable. Produces SVG assets from real project modules, validates XML, and previews via PNG conversion.
---

# SVG Function Module Diagram

Use this skill when the user needs a functional module diagram for a thesis, report, software design document, or graduation design, and the diagram requires vertical Chinese text or a formal tree-like structure.

This skill may be routed from the root `uml` skill when the requested diagram type is `功能模块图`.

Do not use Mermaid for this diagram type when vertical labels are required. Draw SVG XML directly.

## Workflow

1. Identify the real system modules from documentation, source code, routes, services, database schema, and existing report text.
2. Group functions by business responsibility, not by implementation file type.
3. Design a tree layout:
   - top node: system name;
   - first level: major functional modules;
   - leaf nodes: concrete functions;
   - use horizontal connector lines and vertical child branches.
4. Write SVG XML directly:
   - use `<rect>` for module boxes;
   - use `<path>` for connector lines;
   - use `<text>` for titles and labels;
   - use CSS classes for consistent font, stroke, and vertical text.
5. Use vertical Chinese labels for leaf nodes.
6. Avoid vertical English labels because they render as separated letters. Rewrite technical names into Chinese where possible.
7. Save the SVG in the project's asset directory according to image function, for example:
   - `assets/module-design/function-modules.svg`
8. Validate the SVG XML.
9. Convert the SVG to a temporary PNG for visual QA.
10. Update the report or document to reference the SVG.

## SVG Style Pattern

Use a clean black-and-white thesis style:

```xml
<svg xmlns="http://www.w3.org/2000/svg" width="1800" height="960" viewBox="0 0 1800 960">
  <defs>
    <style>
      .box { fill: #ffffff; stroke: #222222; stroke-width: 1.8; }
      .line { fill: none; stroke: #222222; stroke-width: 1.6; stroke-linecap: square; }
      .title { font-family: "Songti SC", "SimSun", serif; font-size: 22px; font-weight: 600; text-anchor: middle; dominant-baseline: middle; }
      .htext { font-family: "Songti SC", "SimSun", serif; font-size: 17px; text-anchor: middle; dominant-baseline: middle; }
      .vtext { font-family: "Songti SC", "SimSun", serif; font-size: 16px; writing-mode: tb; glyph-orientation-vertical: 0; text-anchor: start; }
    </style>
  </defs>
</svg>
```

## Validation Commands

Prefer fish-compatible commands.

Check XML validity:

```fish
python3 -c "import xml.etree.ElementTree as ET; ET.parse('assets/module-design/function-modules.svg'); print('XML_OK')"
```

Check file type and size:

```fish
file assets/module-design/function-modules.svg
wc -c assets/module-design/function-modules.svg
```

Render temporary PNG preview:

```fish
rsvg-convert -w 1800 -h 960 assets/module-design/function-modules.svg -o /tmp/function-modules-full.png
```

Inspect references:

```fish
fd -H . assets/module-design -d 2
rg -n "function-modules|功能模块图" .
```

## Quality Rules

- Base module names on real project functionality; do not invent unsupported features.
- Keep the diagram readable in a thesis PDF or Word export.
- Prefer Chinese labels for leaf nodes.
- Make sure `viewBox` covers all nodes.
- Keep connectors orthogonal and visually simple.
- Do not leave overlapping text, clipped boxes, or English words split vertically.
- Preserve the SVG as the source of truth; do not keep a stale Mermaid source for the same diagram.
