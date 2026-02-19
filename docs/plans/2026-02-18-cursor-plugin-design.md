# Design: Create Cursor-Native GRC Plugin

**Date:** 2026-02-18  
**Approach:** Lift and Shift (Approach A)  
**Status:** Approved — ready for implementation

---

## Goal

Create a new GitHub repository (`hirosh7/grc-plugin`) containing a Cursor-native plugin built from the content of the existing `claude-grc-plugin` repo. The new repo will use Cursor's plugin system from the start — no Claude Code infrastructure. The existing `claude-grc-plugin` repo is left unchanged as an archive.

## Non-Goals

- No rules (persistent AI guidance) will be added
- No MCP server conversion
- No command behavior changes — all 24 commands stay as-is
- No reorganization of reference knowledge files

---

## Repository Structure (Target)

```
grc-plugin/                     ← new repo root = plugin root
├── .cursor-plugin/
│   └── plugin.json             ← Cursor manifest
├── agents/
│   └── grc-researcher.md
├── commands/                   ← 24 .md files
│   ├── audit-prep.md
│   ├── boundary-guidance.md
│   ├── compliance-calendar.md
│   ├── conmon-guide.md
│   ├── control-lookup.md
│   ├── deviation-request.md
│   ├── evidence-checklist.md
│   ├── gap-analysis.md
│   ├── inheritance.md
│   ├── map-controls.md
│   ├── multi-framework.md
│   ├── oscal-guide.md
│   ├── poam-help.md
│   ├── rev5-transition.md
│   ├── review-crm.md
│   ├── review-narrative.md
│   ├── review-poam.md
│   ├── review-policy.md
│   ├── review-ssp.md
│   ├── sar-response.md
│   ├── score-maturity.md
│   ├── significant-change.md
│   ├── ssp-section.md
│   └── tabletop-scenario.md
├── skills/
│   └── grc-knowledge/
│       ├── SKILL.md
│       ├── audits/             ← 14 files, no changes
│       ├── conmon/             ← 6 files, no changes
│       ├── frameworks/         ← 16 files, no changes
│       ├── mappings/           ← 9 files, no changes
│       └── tooling/            ← 1 file, no changes
├── docs/
│   └── plans/
│       └── 2026-02-18-cursor-plugin-design.md
├── README.md                   ← rewritten for Cursor install
├── GUIDE.md                    ← unchanged
├── LICENSE                     ← unchanged
└── .gitignore                  ← updated
```

---

## Manifest: `.cursor-plugin/plugin.json`

```json
{
  "name": "grc",
  "version": "1.0.0",
  "description": "GRC domain knowledge — 15 frameworks, 24 commands, cross-framework mapping, document review, and operational workflows.",
  "author": {
    "name": "hirosh7",
    "url": "https://github.com/hirosh7"
  },
  "homepage": "https://github.com/hirosh7/grc-plugin",
  "repository": "https://github.com/hirosh7/grc-plugin",
  "license": "MIT",
  "keywords": [
    "grc", "compliance", "governance", "risk-management",
    "nist", "fedramp", "soc2", "iso27001", "pci-dss",
    "hipaa", "cmmc", "audit", "security"
  ]
}
```

No explicit component path declarations needed — Cursor discovers `skills/*/SKILL.md`, `commands/`, and `agents/` by convention.

---

## Frontmatter Requirements

### Commands (24 files)

Each `commands/*.md` file needs a YAML frontmatter block added at the top:

```yaml
---
name: grc:<command-name>
description: <one-line purpose>
---
```

Example for `control-lookup.md`:
```yaml
---
name: grc:control-lookup
description: Look up controls by framework and ID or keyword
---
```

### Agent (`agents/grc-researcher.md`)

Needs frontmatter:
```yaml
---
name: grc-researcher
description: Read-only research agent for deep GRC reference lookups across frameworks, mappings, and audit procedures.
---
```

### Skill (`skills/grc-knowledge/SKILL.md`)

Needs frontmatter:
```yaml
---
name: grc-knowledge
description: GRC analyst persona and domain knowledge covering 15 compliance frameworks, cross-framework mapping, and operational workflows.
---
```

### Reference files (72 files in audits/, conmon/, frameworks/, mappings/, tooling/)

**No changes required.** These are knowledge files read by the skill, not registered as Cursor components.

---

## README Changes

The `README.md` install section is rewritten to document Cursor installation:

```markdown
## Install

### From the Cursor Marketplace
/plugin install grc@hirosh7

### From a Local Directory
git clone https://github.com/hirosh7/grc-plugin
# In Cursor: Settings → Plugins → Add Local Plugin → select repo root
```

All command examples (`/grc:control-lookup fedramp ac-2`) are unchanged — Cursor uses the same slash-command syntax.

`GUIDE.md` is unchanged.

---

## Change Summary

| File/Directory | Action |
|---|---|
| `.claude-plugin/` | Delete |
| `grc/` directory | Move all contents to repo root, then delete |
| `.cursor-plugin/plugin.json` | Create |
| `commands/*.md` (24 files) | Add YAML frontmatter to each |
| `agents/grc-researcher.md` | Add YAML frontmatter |
| `skills/grc-knowledge/SKILL.md` | Add YAML frontmatter |
| 72 reference files | No changes |
| `README.md` | Rewrite install/usage section |
| `GUIDE.md`, `LICENSE` | No changes |
| `.gitignore` | Update to remove Claude-Code-specific entries if any |

---

## Implementation Tools

1. **`create-plugin-scaffold` skill** — generate and validate `.cursor-plugin/plugin.json` scaffold
2. **`review-plugin-submission` skill** — final quality gate before committing (validates manifest, component paths, frontmatter completeness)

---

## Success Criteria

- `plugin.json` passes Cursor manifest validation
- All 24 commands discoverable via `/grc:` in Cursor
- `grc-researcher` agent available in Cursor agent selector
- `grc-knowledge` skill loads into context
- No broken file references
- `review-plugin-submission` skill reports all checks passing
