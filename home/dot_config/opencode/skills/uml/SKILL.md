---
name: uml
description: 汇总常见 UML、软件设计图表、论文/报告图表和表格的制作方式。用于生成或更新系统架构图、E-R 图、流程图、时序图、类图、权限模型图、部署架构图、甘特图、数据表结构、测试用例表、功能模块图、UML 用例图等；默认大多数图使用 Mermaid，功能模块图使用手写 SVG XML，用例图使用 Figma。
---

# UML 与图表制作总入口

本 skill 用于选择合适的图表制作方式。先识别用户要表达的内容，再选择 Mermaid、SVG、Figma 或表格输出。

## 总体流程

1. 先从项目证据中提取内容：README、需求文档、源码入口、路由/API、数据库 schema、权限代码、测试、已有论文或报告文本。
2. 判断图表类型和目标文档场景。用户没有指定图类型时，推荐能表达需求的最小图表。
3. Mermaid 能清楚表达的图，直接输出 Mermaid 源码。
4. Mermaid 不适合的特殊图，路由到对应子 skill。
5. 不要为 Mermaid 已经支持且可读的图手绘 SVG。

## 图表路由

| 图表 | 默认方式 | 说明 |
| --- | --- | --- |
| 系统架构图 | Mermaid `architecture` | 表达系统组件、服务和依赖关系。 |
| E-R 图 | Mermaid `erDiagram` | 表达实体、字段和关系。 |
| 流程图 | Mermaid `flowchart` | 表达业务流程、状态分支或模块流程。 |
| 时序图 | Mermaid `sequenceDiagram` | 表达参与者、服务调用和消息顺序。 |
| 类图 | Mermaid `classDiagram` | 表达类、接口、属性、方法和继承/依赖关系。 |
| 权限模型图 | Mermaid `flowchart` | 表达角色、权限、资源和访问关系。 |
| 部署架构图 | Mermaid `architecture` | 表达节点、服务、数据库、网络和部署依赖。 |
| 项目进程安排图 | Mermaid `gantt` | 表达任务、阶段、日期和依赖。 |
| 功能模块图 | SVG XML | 使用 `function-module-diagram/SKILL.md`，手写正式论文风格 SVG。 |
| UML 用例图 | Figma | 使用 `use-case-diagram/SKILL.md`，在 Figma 中创建可编辑 UML 用例图。 |

## Mermaid 图规则

- 只输出 Mermaid 源码，除非用户还要求解释或嵌入文档。
- 根据真实项目内容命名节点，不编造模块、角色、表或接口。
- 节点名称保持短而清楚；复杂说明放在图后文字中。
- 中文论文/报告场景优先使用中文标签。
- 需要表达结构时优先选择专用 Mermaid 图类型，不要把所有图都塞进 `flowchart`。

## 功能模块图

当用户要求“功能模块图”“系统功能模块图”“毕业论文功能模块图”等，读取并遵循 `function-module-diagram/SKILL.md`。

关键约束：

- 手写 SVG XML，不使用 Mermaid。
- 使用真实功能模块，按业务职责分组。
- 适合论文/报告的黑白树状结构。
- 需要验证 SVG XML，并渲染临时 PNG 做视觉检查。

## UML 用例图

当用户要求“UML 用例图”“用例图”“Figma 用例图”“修复用例图重叠”等，读取并遵循 `use-case-diagram/SKILL.md`。

关键约束：

- 使用 Figma 制作可编辑图形，不使用 Mermaid 代替。
- 写入 Figma 前，必须按 Figma 工具要求加载对应 Figma skill。
- 先根据项目证据提取参与者、用例、系统边界和关系。
- 需要检查 `include` / `extend` 标签与用例文本不要重叠。

## 表格类输出

| 内容 | 默认方式 | 说明 |
| --- | --- | --- |
| 数据表结构 | Markdown 表格 | 包含字段名、类型、约束、说明；如用户要求再转为 Excel/Word。 |
| 测试用例表 | Markdown 表格 | 包含编号、用例名称、前置条件、步骤、预期结果、优先级等。 |

表格应来自真实 schema、接口、需求或测试，不要补充未经证据支持的字段和用例。
