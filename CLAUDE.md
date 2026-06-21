# CLAUDE.md — CALPADS Course-Completion Cleaning (Applied-Micro Overlay)

<!-- This repo is in OFFBOARDING. It is a lightweight Stata data-cleaning project,
     not an active paper. The .claude/ overlay is the original author's PERSONAL
     Claude Code setup (not a lab standard); it was ported in at handoff so the
     workflow conventions travel with the repo. There is no LaTeX paper, talks, or
     estimation here — those overlay sections are intentionally omitted. -->

**Project:** CALPADS Course Completion (crscomp) cleaning + UC A–G eligibility (draft)
**Institution:** California Education Lab (CEL), UC Davis
**Branch:** main
**Status:** Offboarding / handoff. Original work done ~1 month in 2020.
**Analysis roots:** `do/` (Stata `.do` files; the evidence/comment-balance hooks scope here)

---

## Core Principles

- **Plan first** — enter plan mode before non-trivial tasks; save plans to `quality_reports/plans/`
- **Verify after** — re-run the affected do file and confirm the cleaned `.dta` saves without error
- **Derive, don't guess** — file paths, variable names, and the grade-point algorithm already exist in `do/`; look them up, don't invent (see `.claude/rules/derive-dont-guess.md`)
- **Decisions are ADRs** — substantive cleaning/coding decisions live in `decisions/NNNN_slug.md` (see `.claude/rules/decision-log.md`)
- **Track TODOs** — `TODO.md` tracks open work / known gaps; update after completing any task
- **[LEARN] tags** — when corrected, save `[LEARN:category] wrong → right` to MEMORY.md

---

## What this project does

A per-academic-year Stata cleaning pipeline over CALPADS End-of-Year 1 (EOY1) **Course Completion (crscomp)** extracts. Each year's raw `.dta` is renamed/trimmed/relabeled, and a 0.0–4.0 grade-point variable (`fgradept`) is derived from the recorded letter/number grade using the **Alexandria Hurtt** algorithm. A separate draft script computes UC **A–G** subject-requirement eligibility from the cleaned data. See `README.md` for the full I/O map of every do file.

---

## Folder Structure

```
calpads/
├── CLAUDE.md                  # This file
├── README.md                  # Handoff doc: structure + per-do-file inputs/outputs (START HERE)
├── TODO.md                    # Open work / known gaps
├── .claude/                   # Personal Claude Code setup (rules, skills, agents, hooks)
├── do/                        # Stata code (the pipeline)
│   ├── settings.do            # Global path macros ($rawdtadir, $clndtadir, $projdir)
│   ├── master.do              # Orchestrator — runs the pipeline in order (toggle per step)
│   ├── build/prepare/         # clean13_14 … clean17_18, ageligibility (draft)
│   ├── check/                 # varnames.do (DEPRECATED — variable-name export)
│   └── archive/               # fgradept{15_16,16_17,17_18}.do (SUPERSEDED — folded into clean*.do)
├── doc/                       # CALPADS reference: code sets, valid codes, codebooks, trainings
├── out/                       # Small exported artifacts (variable-name lists, missing tabulations)
├── decisions/                 # ADRs (see decision-log.md)
├── quality_reports/           # Plans, reviews, session logs
├── explorations/              # Research sandbox
├── master_supporting_docs/    # Reference material the overlay points at
└── templates/                 # Workflow templates
```

Raw and cleaned data are **not** in this repo — they live on the lab server (restricted access). See `do/settings.do` for the paths.

---

## Commands

```stata
* From the repo root, first point Stata at this directory, e.g.:
* cd "/home/research/ca_ed_lab/chesun/gsr/calpads"

* Run the whole pipeline (paths + toggles are set inside these files):
do "./do/master.do"

* Run a single year's cleaning directly (requires settings.do globals to be set):
do "./do/settings.do"
do "./do/build/prepare/clean17_18.do"
```

Prerequisite Stata package: `ssc install egenmore, replace` (provides `sieve()`, used in the grade-point block).

---

## Skills Quick Reference

| Command | What It Does |
|---------|-------------|
| `/discover [mode] [topic]` | Discovery: interview, literature, data |
| `/analyze [dataset]` | End-to-end data analysis |
| `/review [file/--flag]` | Quality reviews (routes by target: code, data, peer) |
| `/challenge [file --mode]` | Devil's advocate review |
| `/humanize [path]` | Strip AI writing patterns from any external-facing doc |
| `/tools [subcommand]` | Utilities: commit, validate, context-status, learn |

The `.claude/skills/stata/` skill carries Stata-specific conventions relevant to this project. Paper-, talk-, and estimation-oriented skills from the overlay exist but are not used here.

---

## Current Project State

| Component | Where | Status | Notes |
|-----------|-------|--------|-------|
| Year cleaning | `do/build/prepare/clean*.do` | Complete | One do file per year, 2013–14 … 2017–18 |
| Grade points | inside `clean*.do` | Complete | `fgradept`, Hurtt algorithm |
| A–G eligibility | `do/build/prepare/ageligibility.do` | **Draft — never used in production** | Exploratory; no `use`/`save`; has known bugs (left as-is by design); needs a combined multi-year cohort dataset upstream (see TODO.md / README.md) |
| Variable-name export | `do/check/varnames.do` | **Deprecated** | Do not run |
