# TODO — CALPADS Course-Completion Cleaning

Open work and known gaps at offboarding. See `README.md` § 6 for full context.

## Active

- _(none — project is in offboarding; no active work)_

## Up Next (for whoever takes over)

- **Build the combined multi-year dataset.** Write an append/reshape step that stacks the five
  `crscompYY_YY_cln_che.dta` files into one per-student (`ssid`) multi-year course history. This is
  the missing input that `ageligibility.do` assumes. Note `ssid` only exists from 2015–16 on;
  decide how (or whether) to bridge to the 2013–14 / 2014–15 `stukey` files.
- **Finish `ageligibility.do`.** Fix the known bugs (missing `|` in the Hexmester term condition;
  `satisfyB` block writes to `satisfyA`), add `use`/`save`, and incorporate SAT/ACT/AP/IB test
  scores if/when acquired (they can satisfy A–G requirements per the UC admissions rules cited in
  the file header). Validate against a few hand-checked students.

## Waiting / Needs Info

- **Confirm the meaning of `stukey`, `snapkey`, `eoy1`** (2013–14 / 2014–15 files). They were
  renamed but never verified — see the inline `// need to find out…` comments.

## Backlog / Nice-to-have

- Fix the misleading header banners in `clean13_14.do` ("14-15") and `clean16_17.do` ("17-18") —
  cosmetic only; the `use`/`save` paths are correct.

## Done

- Per-year cleaning of crscomp 2013–14 … 2017–18, including the `fgradept` grade-point derivation.
- Project documentation for handoff (`README.md`, this file) and the applied-micro workflow
  overlay snapshot in `.claude/`.
