# Figma UML Use Case Diagram Workflow

## Evidence Checklist

Read only what is needed for the target project:

- overview: `README.md`, requirements/spec files, `AGENTS.md`;
- actors and roles: auth modules, guards, role types, session checks, user-facing pages;
- use cases: controllers, resolvers, route handlers, CLI command definitions, workers, service methods;
- data/source-of-truth: migrations, schema helpers, models, repositories;
- external systems: daemon workers, queues/outbox, deployment/runtime files, third-party integrations;
- tests: behavior assertions and edge cases.

If docs and code disagree, prefer implemented code and mention the discrepancy if it matters.

## UML Derivation Heuristics

- Actor names should describe roles, not implementation classes.
- A background worker can be an actor only when it initiates use cases across the system boundary.
- A database is usually not an actor; show it in notes unless users explicitly need infrastructure actors.
- Merge CRUD operations when the diagram is for a thesis/report and the operations share the same actor and purpose, for example `创建 / 更新 / 删除用户`.
- Do not show every endpoint as a use case if it creates a noisy diagram.
- Use `include` for required shared behavior, for example registration creating an outbox event.
- Use `extend` for optional or conditional behavior, for example token rotation extending user management.

## Recommended Figma Node Naming

Use stable names so future scripts can update the diagram:

- main frame: `<project> UML 用例图`
- actor frame: `参与者 / <actor>`
- use case frame: `用例 / <label>`
- system boundary frame: `系统边界 / <system>`
- relation tag: `关系标注 / include` or `关系标注 / extend`
- note: `说明 / <title>`

## Connector Guidance

Use vector paths instead of rotated line nodes for long connectors when exported output matters. Vector paths keep endpoint coordinates stable in screenshots and exports.

Relation tags should be small and offset from ellipses. If a tag overlaps a use case:

1. shrink the tag;
2. move it above, below, left, or right of the union of the overlapping use cases;
3. rerun collision detection;
4. accept only when there are no collisions with use case frames.

## Collision Detection Script Pattern

Use this inside `use_figma` after switching to the target page:

```js
const canvas = page.children.find((n) => n.name === "box-winder UML 用例图");
if (!canvas) throw new Error("diagram frame not found");

function rect(n) {
  return { id: n.id, name: n.name, x: n.x, y: n.y, w: n.width, h: n.height };
}

function overlaps(a, b, pad = 0) {
  return (
    a.x < b.x + b.w + pad &&
    a.x + a.w > b.x - pad &&
    a.y < b.y + b.h + pad &&
    a.y + a.h > b.y - pad
  );
}

const useCases = canvas.children
  .filter((n) => n.name?.startsWith("用例 /"))
  .map(rect);
const labels = canvas.children
  .filter((n) => n.name?.startsWith("关系标注 /"))
  .map(rect);

const collisions = labels
  .map((label) => ({
    label,
    overlaps: useCases
      .filter((uc) => overlaps(label, uc, 3))
      .map((uc) => uc.name),
  }))
  .filter((item) => item.overlaps.length > 0);

return { labelCount: labels.length, remainingCollisions: collisions };
```

## Export Advice

For report use, recommend exporting the selected main frame as SVG first. If the document tool has poor SVG support, use PDF or PNG at 3x. Avoid screenshot export for final papers unless no vector export path is available.
