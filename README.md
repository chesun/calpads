# CALPADS Course-Completion Cleaning — Project README

> **Taking over this project?** This README is the handoff guide. Read § 1–4 to understand
> what the code does and how the pieces fit, then use the **per-do-file input/output map**
> in § 4 as your reference while running or modifying the pipeline. Known gaps and gotchas
> are collected in § 6 — read them before you run anything.

**Lab:** California Education Lab (CEL), UC Davis
**Original author:** Christina Sun (`chesun`)
**When:** ~1 month of work in 2020
**Status:** Offboarding / handoff. Lightweight — a handful of Stata `.do` files.

---

## 1. What this repo is

A per-academic-year **Stata cleaning pipeline** over CALPADS **End-of-Year 1 (EOY1) Course
Completion** extracts (internally called `crscomp`). For each school year from 2013–14 through
2017–18, the pipeline:

1. Reads that year's raw `crscompYY_YY.dta` extract.
2. Renames columns to short consistent names, trims stray whitespace, relabels variables, and
   converts the various Yes/No flags to 0/1 dummies.
3. Derives a **0.0–4.0 grade-point variable** (`fgradept`) from the recorded final letter/number
   grade, using a fixed crosswalk (the "Alexandria Hurtt algorithm"). Non-numeric outcomes
   (Pass, Incomplete, Withdrawal, etc.) are stored as Stata extended missing values with labels.
4. Saves a cleaned, compressed `.dta` per year.

A separate, **draft** script (`ageligibility.do`) computes UC **A–G** subject-requirement
eligibility from cleaned course records. It is not finished — see § 6.

The raw and cleaned datasets are **restricted-access** and live on the lab server, not in this
repo. Only code, documentation, and a few small exported artifacts are tracked here.

---

## 2. Project structure

```
calpads/
├── README.md                 # This handoff guide
├── CLAUDE.md                 # Instructions for Claude Code (workflow overlay)
├── TODO.md                   # Open work / known gaps
├── do/                       # All Stata code
│   ├── settings.do           # Global path macros (EDIT THIS to point at your file system)
│   ├── master.do             # Orchestrator — runs the pipeline in order, one toggle per step
│   ├── build/prepare/
│   │   ├── clean13_14.do     # Clean one academic year each →
│   │   ├── clean14_15.do     #   read raw extract, rename/recode/label, derive fgradept, save
│   │   ├── clean15_16.do
│   │   ├── clean16_17.do
│   │   ├── clean17_18.do
│   │   └── ageligibility.do  # UC A–G eligibility (draft, never used in production — see § 6)
│   ├── check/
│   │   └── varnames.do       # DEPRECATED — exported variable-name lists to Excel
│   └── archive/
│       ├── fgradept15_16.do  # SUPERSEDED standalone grade-point scripts; the logic they
│       ├── fgradept16_17.do  #   contain now lives inside the clean*.do files. Kept for
│       └── fgradept17_18.do  #   history only — do not run as part of the pipeline.
├── doc/                      # CALPADS reference material (see § 7)
└── out/                      # Small exported artifacts (variable lists, missing tabulations)
```

The overlay also adds `.claude/`, `decisions/`, `quality_reports/`, `explorations/`,
`master_supporting_docs/`, and `templates/` — these support the research workflow, not the
CALPADS pipeline itself. See § 8.

---

## 3. The pipeline at a glance

```
do/settings.do        sets $rawdtadir, $clndtadir, $projdir (no data touched)
        │
do/master.do          opens master log, then runs each step below if its toggle == 1 (all default to 0)
        │
        ├─ clean13_14.do :  $rawdtadir/crscomp13_14.dta ──▶ $clndtadir/crscomp13_14_cln_che.dta
        ├─ clean14_15.do :  $rawdtadir/crscomp14_15.dta ──▶ $clndtadir/crscomp14_15_cln_che.dta
        ├─ clean15_16.do :  $rawdtadir/crscomp15_16.dta ──▶ $clndtadir/crscomp15_16_cln_che.dta
        ├─ clean16_17.do :  $rawdtadir/crscomp16_17.dta ──▶ $clndtadir/crscomp16_17_cln_che.dta
        └─ clean17_18.do :  $rawdtadir/crscomp17_18.dta ──▶ $clndtadir/crscomp17_18_cln_che.dta

(separate, draft)
   ageligibility.do   :  one cleaned crscomp dataset ALREADY IN MEMORY ──▶ in-memory A–G flags
```

Each `clean*.do` is self-contained: it opens its own log, reads one raw file, and saves one
cleaned file. The years run independently and in any order. The output suffix `_cln_che` means
"**cln**eaned, by **che**sun".

---

## 4. Inputs and outputs of each do file

Paths use the Stata globals from `do/settings.do`:

- `$rawdtadir` = `/home/research/ca_ed_lab/data/restricted_access/raw/calpads/coursecomp`
- `$clndtadir` = `/home/research/ca_ed_lab/data/restricted_access/clean/calpads/dta`
- `$projdir`  = `/home/research/ca_ed_lab/chesun/gsr/calpads`

| Do file | Input | Output (data) | Output (log) | Notes |
|---|---|---|---|---|
| `do/settings.do` | — | — | — | Defines `$rawdtadir`, `$clndtadir`, `$projdir`. **Edit before running anything.** |
| `do/master.do` | runs `settings.do` | — | `$projdir/log/master.smcl` | Orchestrator. Runs each `clean*.do` if its local toggle `== 1` (all toggles default to `0` = off). |
| `do/build/prepare/clean13_14.do` | `$rawdtadir/crscomp13_14.dta` | `$clndtadir/crscomp13_14_cln_che.dta` | `$projdir/log/clean13_14.smcl` | ID vars `stukey`, `snapkey`, `eoy1`. Raw columns are PascalCase. |
| `do/build/prepare/clean14_15.do` | `$rawdtadir/crscomp14_15.dta` | `$clndtadir/crscomp14_15_cln_che.dta` | `$projdir/log/clean14_15.smcl` | Same shape as 13–14 (`stukey`/`snapkey`/`eoy1`). |
| `do/build/prepare/clean15_16.do` | `$rawdtadir/crscomp15_16.dta` | `$clndtadir/crscomp15_16_cln_che.dta` | `$projdir/log/clean15_16.smcl` | ID var switches to `ssid`. Raw columns are lowercase. No `stukey`/`snapkey`/`eoy1`. |
| `do/build/prepare/clean16_17.do` | `$rawdtadir/crscomp16_17.dta` | `$clndtadir/crscomp16_17_cln_che.dta` | `$projdir/log/clean16_17.smcl` | `ssid`; **adds a `honor`** dummy (from the raw `honors` column). |
| `do/build/prepare/clean17_18.do` | `$rawdtadir/crscomp17_18.dta` | `$clndtadir/crscomp17_18_cln_che.dta` | `$projdir/log/clean17_18.smcl` | `ssid`; **adds a `honor`** dummy (from the raw `honors` column). |
| `do/build/prepare/ageligibility.do` | a cleaned `crscomp` dataset **already loaded in memory** (needs `ssid`, `agcode`, `term`, `fgradept`) | none — creates in-memory `satisfyA`…`satisfyF`, `satisfyGA`…`satisfyGF`, `satisfyag`; **does not `save`** | none | **Draft — never used in production.** Assumes ~4 years of records per student cohort. See § 6. |
| `do/check/varnames.do` | (commented out) `crscomp13_14`, `crscomp14_15` | (commented out) Excel var lists in `$projdir` | — | **DEPRECATED — do not run.** Whole body is commented. |
| `do/archive/fgradept15_16.do` | `$clndtadir/crscomp15_16_cln_che.dta` | `$clndtadir/crscomp15_16_cln_fgpt_che.dta` | `$projdir/log/fgradept15_16.smcl` | **SUPERSEDED.** Standalone grade-point pass; logic now embedded in `clean15_16.do`. |
| `do/archive/fgradept16_17.do` | `$clndtadir/crscomp16_17_cln_che.dta` | `$clndtadir/crscomp16_17_cln_fgpt_che.dta` | `$projdir/log/fgradept16_17.smcl` | **SUPERSEDED** (see above). |
| `do/archive/fgradept17_18.do` | `$clndtadir/crscomp17_18_cln_che.dta` | `$clndtadir/crscomp17_18_cln_fgpt_che.dta` | `$projdir/log/fgradept17_18.smcl` | **SUPERSEDED** (see above). |

### Common cleaned-data variables

After a `clean*.do` runs, the cleaned file contains (names consistent across years):
`year`, `term`, `cdcode`, `cdscode7`, `cdscode` (14-digit CDS school code, built by
concatenation), `lcrsnum`/`lcrsname` (local course), `scrsnum`/`scrsname` (state course),
`credatt`/`credearn`, `fgrade` (cleaned letter grade), `fgradept` (0.0–4.0 grade point),
`uccsuapp`, `indstudy`, `distlearn`, `cte`, `agcode`/`agname`, plus `ssid` (2015–16 onward) or
`stukey`/`snapkey`/`eoy1` (2013–14, 2014–15), and `honor` (2016–17, 2017–18).

`fgradept` non-numeric codes: `.a` Pass, `.b` Not Pass, `.c` Missing, `.d` Incomplete,
`.e` Work in Progress, `.f` Withdrawal, `.g` Credit, `.h` No Credit/Not Graded, `.i` No Mark.

### Small artifacts in `out/`

`calpads variable names.xlsx`, `varnames13_14.xls`, `varnames14_15.xls` (variable-name/label
exports), and `missing tabulation.xlsx` (a missingness tabulation). All dated July 2020;
hand-exported, not regenerated by the current pipeline.

---

## 5. How to run

1. **Install the required Stata package** (provides `sieve()`, used in the grade-point block):

   ```stata
   ssc install egenmore, replace
   ```

2. **Point the pipeline at your file system.** Open `do/settings.do` and set `$rawdtadir`,
   `$clndtadir`, and `$projdir` to match where the raw data, cleaned-data target, and this
   project folder live. Make sure `$projdir/log/` exists (the do files write logs there).

3. **Change into the project directory and run the master file:**

   ```stata
   cd "/home/research/ca_ed_lab/chesun/gsr/calpads"   // your $projdir
   do "./do/master.do"
   ```

   Inside `master.do`, each step is guarded by a `local doclean..._.. = 0` toggle. **They all
   default to `0` (off), so a bare `do "./do/master.do"` runs nothing** — set a step's toggle to
   `1` to run it (and back to `0` to skip). The `ageligibility` step has its own toggle, also `0`,
   and should stay off (it is an unfinished draft — see § 6). To clean a single year without the
   master, run `do/settings.do` first (to set the globals), then that year's `clean*.do`.

---

## 6. Known issues, gaps & gotchas

Read these before running or trusting outputs.

- **`ageligibility.do` was never used in production** and will not run as-is. It is exploratory —
  it has no `use`/`save`, so it operates on whatever dataset is in memory and expects a
  **combined multi-year** course history per student (`ssid`), but nothing in the pipeline builds
  that combined dataset (the `clean*.do` files save one year each, separately). It also has known
  bugs. Treat it as a sketch of the intended A–G logic, not working code; the bugs are left as-is
  by design.
- **No append/merge step exists.** To go from five separate `crscompYY_YY_cln_che.dta` files to a
  single per-student multi-year dataset (needed for A–G eligibility), someone must write that
  append/reshape step. It was never built.
- **`varnames.do` is deprecated** and fully commented out; it also points at hard-coded absolute
  paths. Do not run it.
- **`archive/fgradept*.do` are superseded.** Their grade-point logic was folded into the
  `clean*.do` files (which save `_cln_che`). The archived versions read `_cln_che` and write a
  separate `_cln_fgpt_che` file — running them would create redundant outputs.
- **Restricted data.** Raw and cleaned `.dta` files are not in this repo and require lab server
  access. Paths in `settings.do` are server paths.
- **Unverified key fields.** `stukey`, `snapkey`, and `eoy1` (2013–14 / 2014–15 files) were
  renamed but their exact meaning was never confirmed — see the inline `// need to find out…`
  comments. `eoy1` is believed to relate to CALPADS End-of-Year 1 (Course Completion / CTE)
  reporting.
- **Grade-point crosswalk is fixed and opinionated.** `fgradept` maps letters, 0–100 numbers, and
  0–4 GPA-style values to a 0.0–4.0 scale via explicit `replace` rules. If a grade format appears
  that isn't covered, it falls through to missing (`.c`). Check the logs for unexpected missings
  after a data refresh.

---

## 7. Reference material (`doc/`)

Not code — background knowledge that informed the cleaning:

- **Trainings:** CALPADS Basics / Intro / EOY-1 / EOY-2 / EOY-Advanced slide decks (`.pptx`).
- **`alex resources/`** — Alexandria Hurtt's original final-course-grade do file and notes (the
  source of the `fgradept` algorithm), plus CDE course-code references.
- **`codebook/`** — CourseComp codebooks per year (2013–14 … 2017–18) and a course-name/A–G map.
- **`Colin/`, `example do/`** — example cleaning do files from colleagues, used as references.
- **`validcodesv12-20200701.xlsx`** — CALPADS valid-code sets.
- **`resource-examination-of-data-usability-…california.pdf`** — report on using CALPADS course
  data to assess higher-education eligibility (the motivating use case for `ageligibility.do`).

A useful external reference is the CALPADS training repository: https://csis.fcmat.org/resources-repository

---

## 8. The workflow overlay (`.claude/`)

At handoff, the lab's **applied-microeconomics research workflow** overlay was ported into this
repo (a versioned snapshot — not registered for ongoing sync). It lives in `.claude/` and adds
rules, skills, agents, and hooks that standardize how Claude Code works in the lab's projects, plus
supporting folders (`decisions/`, `quality_reports/`, `explorations/`, `master_supporting_docs/`,
`templates/`). It does not change the CALPADS pipeline; `CLAUDE.md` is the entry point. If you do
not use Claude Code, you can ignore `.claude/` entirely.

---

## 9. Provenance

- Original work: Christina Sun, CEL UC Davis, 2020 (~1 month, at the start of employment).
- The grade-point algorithm originates with Alexandria Hurtt (see `doc/alex resources/`).
- Cleaned-file naming: `crscompYY_YY_cln_che.dta` = cleaned course-completion data, by `chesun`.
