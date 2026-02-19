# GRC Cursor Plugin Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Create a new `hirosh7/grc-plugin` GitHub repo as a clean Cursor-native plugin, populated with content lifted from `claude-grc-plugin`.

**Architecture:** New repo at `~/projects/grc-plugin` with plugin files at root. Content copied from `claude-grc-plugin/grc/`. Cursor manifest at `.cursor-plugin/plugin.json`. YAML frontmatter added to all component files. No Claude Code infrastructure.

**Tech Stack:** Cursor plugin system, Markdown, YAML frontmatter, GitHub CLI (`gh`)

---

### Task 1: Create local and GitHub repo

**Files:**
- Create: `~/projects/grc-plugin/` (new directory)

**Step 1: Create local directory and init git**

    mkdir ~/projects/grc-plugin
    cd ~/projects/grc-plugin
    git init

Expected: `Initialized empty Git repository`

**Step 2: Create GitHub repo**

    gh repo create hirosh7/grc-plugin --public --description "GRC domain knowledge Cursor plugin"

Expected: URL printed

**Step 3: Set remote**

    git remote add origin git@github.com:hirosh7/grc-plugin.git

---

### Task 2: Create plugin manifest

**Files:**
- Create: `~/projects/grc-plugin/.cursor-plugin/plugin.json`

**Step 1: Create directory and plugin.json**

    mkdir -p ~/projects/grc-plugin/.cursor-plugin

Create `.cursor-plugin/plugin.json` with this content:

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

**Step 2: Commit**

    git add .cursor-plugin/plugin.json
    git commit -m "feat: add Cursor plugin manifest"

---

### Task 3: Copy reference knowledge files (no edits needed)

**Files:**
- Copy: `claude-grc-plugin/grc/skills/grc-knowledge/{audits,conmon,frameworks,mappings,tooling}/` to `skills/grc-knowledge/`

**Step 1: Copy all subdirectories**

    cd ~/projects/grc-plugin
    mkdir -p skills/grc-knowledge
    cp -r ~/projects/claude-grc-plugin/grc/skills/grc-knowledge/audits skills/grc-knowledge/
    cp -r ~/projects/claude-grc-plugin/grc/skills/grc-knowledge/conmon skills/grc-knowledge/
    cp -r ~/projects/claude-grc-plugin/grc/skills/grc-knowledge/frameworks skills/grc-knowledge/
    cp -r ~/projects/claude-grc-plugin/grc/skills/grc-knowledge/mappings skills/grc-knowledge/
    cp -r ~/projects/claude-grc-plugin/grc/skills/grc-knowledge/tooling skills/grc-knowledge/

**Step 2: Verify count**

    find skills/grc-knowledge -name "*.md" | wc -l

Expected: `46`

**Step 3: Commit**

    git add skills/grc-knowledge/
    git commit -m "feat: add 46 GRC reference knowledge files"

---

### Task 4: Copy and update SKILL.md

**Files:**
- Copy + edit: `grc/skills/grc-knowledge/SKILL.md` -> `skills/grc-knowledge/SKILL.md`

**Step 1: Copy**

    cp ~/projects/claude-grc-plugin/grc/skills/grc-knowledge/SKILL.md skills/grc-knowledge/SKILL.md

**Step 2: Check for existing frontmatter**

    head -3 skills/grc-knowledge/SKILL.md

If the file does NOT start with `---`, prepend this block:

    ---
    name: grc-knowledge
    description: GRC analyst persona and domain knowledge covering 15 compliance frameworks, cross-framework mapping, document review, and operational workflows.
    ---

Use Read + Write tools (or prepend via Python) — do NOT delete any existing content.

**Step 3: Verify**

    head -5 skills/grc-knowledge/SKILL.md

Expected: first line is `---`

**Step 4: Commit**

    git add skills/grc-knowledge/SKILL.md
    git commit -m "feat: add grc-knowledge skill with Cursor frontmatter"

---

### Task 5: Copy and update agent file

**Files:**
- Copy + edit: `grc/agents/grc-researcher.md` -> `agents/grc-researcher.md`

**Step 1: Copy**

    mkdir -p ~/projects/grc-plugin/agents
    cp ~/projects/claude-grc-plugin/grc/agents/grc-researcher.md agents/grc-researcher.md

**Step 2: Check for existing frontmatter**

    head -3 agents/grc-researcher.md

If NOT starting with `---`, prepend:

    ---
    name: grc-researcher
    description: Read-only research agent for deep GRC reference lookups across frameworks, mappings, and audit procedures.
    ---

**Step 3: Verify and commit**

    head -5 agents/grc-researcher.md
    git add agents/grc-researcher.md
    git commit -m "feat: add grc-researcher agent with Cursor frontmatter"

---

### Task 6: Copy all 24 command files

**Files:**
- Copy: `grc/commands/*.md` -> `commands/`

**Step 1: Copy**

    mkdir -p ~/projects/grc-plugin/commands
    cp ~/projects/claude-grc-plugin/grc/commands/*.md commands/

**Step 2: Verify count**

    ls commands/ | wc -l

Expected: `24`

Do NOT commit yet — frontmatter added in Task 7.

---

### Task 7: Add YAML frontmatter to all 24 commands

**Files:**
- Modify: `commands/*.md` (all 24 files)

**Step 1: Run frontmatter script**

Save and run this Python script from `~/projects/grc-plugin`:

    import os

    frontmatter = {
        "audit-prep": ("grc:audit-prep", "Audit preparation checklists by audit type"),
        "boundary-guidance": ("grc:boundary-guidance", "Authorization boundary definition guidance"),
        "compliance-calendar": ("grc:compliance-calendar", "Generate recurring compliance activity calendar"),
        "conmon-guide": ("grc:conmon-guide", "Continuous monitoring guidance by topic"),
        "control-lookup": ("grc:control-lookup", "Look up controls by framework and ID or keyword"),
        "deviation-request": ("grc:deviation-request", "Draft deviation and risk acceptance documentation"),
        "evidence-checklist": ("grc:evidence-checklist", "Generate audit evidence preparation checklists"),
        "gap-analysis": ("grc:gap-analysis", "Structured gap analysis worksheets"),
        "inheritance": ("grc:inheritance", "Model control inheritance by service model IaaS/PaaS/SaaS"),
        "map-controls": ("grc:map-controls", "Map controls between any two frameworks"),
        "multi-framework": ("grc:multi-framework", "Analyze overlap and gaps across multiple frameworks"),
        "oscal-guide": ("grc:oscal-guide", "OSCAL structure, readiness, and conversion guidance"),
        "poam-help": ("grc:poam-help", "POA&M creation, templates, and metrics"),
        "rev5-transition": ("grc:rev5-transition", "NIST 800-53 Rev 4 to Rev 5 transition mapping"),
        "review-crm": ("grc:review-crm", "Review CRM coverage, responsibility clarity, and common gaps"),
        "review-narrative": ("grc:review-narrative", "Review SSP control narratives with maturity scoring 0-5"),
        "review-poam": ("grc:review-poam", "Check POA&M entries for field completeness and SLA compliance"),
        "review-policy": ("grc:review-policy", "Review policy structure, control coverage, and language quality"),
        "review-ssp": ("grc:review-ssp", "Validate SSP structure against FedRAMP template"),
        "sar-response": ("grc:sar-response", "Draft structured responses to SAR findings"),
        "score-maturity": ("grc:score-maturity", "Score control implementation maturity 0-5 with next-level guidance"),
        "significant-change": ("grc:significant-change", "Analyze if a system change is significant per FedRAMP"),
        "ssp-section": ("grc:ssp-section", "Draft SSP narrative language by control family"),
        "tabletop-scenario": ("grc:tabletop-scenario", "Generate IR/CP tabletop exercise scenarios"),
    }

    for slug, (name, description) in frontmatter.items():
        path = f"commands/{slug}.md"
        with open(path, "r") as f:
            content = f.read()
        if not content.startswith("---"):
            header = f"---\nname: {name}\ndescription: {description}\n---\n\n"
            with open(path, "w") as f:
                f.write(header + content)
            print(f"Updated: {path}")
        else:
            print(f"Skipped (has frontmatter): {path}")

**Step 2: Spot-check**

    head -5 commands/control-lookup.md

Expected: starts with `---`, then `name: grc:control-lookup`

**Step 3: Commit**

    git add commands/
    git commit -m "feat: add 24 GRC slash commands with Cursor frontmatter"

---

### Task 8: Add README, GUIDE, LICENSE, .gitignore

**Files:**
- Create: `README.md`
- Copy: `GUIDE.md`, `LICENSE`
- Create: `.gitignore`

**Step 1: Copy GUIDE and LICENSE**

    cp ~/projects/claude-grc-plugin/GUIDE.md .
    cp ~/projects/claude-grc-plugin/LICENSE .

**Step 2: Create README.md**

Write a new `README.md`. Key sections:
- Title: "GRC Knowledge Plugin for Cursor"
- What it does (frameworks, document review, workflows)
- Install section with Cursor syntax: `/plugin install grc@hirosh7`
- Local install: `git clone https://github.com/hirosh7/grc-plugin`
- Quick command examples using `/grc:` prefix
- Link to GUIDE.md for full reference
- MIT license note

**Step 3: Create .gitignore**

    .DS_Store
    *.swp
    .vscode/settings.json
    .specstory/

**Step 4: Commit**

    git add README.md GUIDE.md LICENSE .gitignore
    git commit -m "docs: add README, GUIDE, LICENSE, .gitignore"

---

### Task 9: Run review-plugin-submission quality gate

**Step 1: Read the skill**

    /home/hirosh7/.cursor/plugins/cache/cursor-public/create-plugin/b697d35c75cf47b35ecea1d45df243bf865fc022/skills/review-plugin-submission/SKILL.md

**Step 2: Run through checklist against ~/projects/grc-plugin**

- [ ] `.cursor-plugin/plugin.json` exists with valid `name`
- [ ] All 24 commands have `name` + `description` frontmatter
- [ ] `agents/grc-researcher.md` has frontmatter
- [ ] `skills/grc-knowledge/SKILL.md` has frontmatter
- [ ] No broken file references in any component
- [ ] `README.md` documents purpose, install, and component coverage

**Step 3: Fix any failures, commit fixes**

    git add -A
    git commit -m "fix: address review-plugin-submission findings"

---

### Task 10: Push to GitHub and verify

**Step 1: Push**

    cd ~/projects/grc-plugin
    git push -u origin main

**Step 2: Verify repo on GitHub**

    gh repo view hirosh7/grc-plugin

Expected: repo shows correct file structure

**Step 3: Final structure check**

    find . -not -path "./.git/*" | sort

Expected: `.cursor-plugin/plugin.json`, `agents/`, `commands/` (24 files), `skills/grc-knowledge/` (SKILL.md + 5 subdirs), `README.md`, `GUIDE.md`, `LICENSE`, `.gitignore`
