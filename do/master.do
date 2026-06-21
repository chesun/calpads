********************************************************************************
******* master do file for calpads crscomp project do files ********************
/* this master file executes all do files for the project in correct order */
********************************************************************************

/* IMPORTANT: before running this master do file, make sure the directory global macros
are set correctly in the settings.do file according to your current file structure */

/* data training material on CALPADS: https://csis.fcmat.org/resources-repository */

/* Before executing this do file, first change directory to do file location */
/* cd "/home/research/ca_ed_lab/chesun/gsr/calpads" */

/* to run this master do file, run the following line of code  */
/* do "./do/master.do" */

/* ----------------------------------------------------------------------------
   PIPELINE OVERVIEW — what each do file does (see README.md sec. 4 for full I/O)

   settings.do                  Sets the path globals $rawdtadir, $clndtadir,
                                $projdir. Run first; touches no data.

   build/prepare/clean13_14.do  One per academic year. Each reads that year's raw
   build/prepare/clean14_15.do  crscompYY_YY.dta extract, renames columns to short
   build/prepare/clean15_16.do  consistent names, trims whitespace, relabels vars,
   build/prepare/clean16_17.do  turns Y/N flags into 0/1 dummies, derives the 0-4
   build/prepare/clean17_18.do  grade point fgradept (Hurtt algorithm), and saves
                                $clndtadir/crscompYY_YY_cln_che.dta. Years are
                                independent and may run in any order. (2013-14 and
                                2014-15 key on stukey/snapkey/eoy1; 2015-16 onward
                                key on ssid; 2016-17 and 2017-18 also add honor.)

   build/prepare/ageligibility.do  DRAFT / INCOMPLETE. Computes UC A-G subject
                                requirement eligibility from a cleaned crscomp
                                dataset already in memory. Has no use/save and
                                expects a combined multi-year course history per
                                student (ssid) that no step currently builds; it
                                also contains known bugs. Off by default. See
                                README.md sec. 6 before enabling.

   NOT part of the active pipeline (do not run from here):
   check/varnames.do            DEPRECATED variable-name export (body commented out).
   archive/fgradept{15_16,16_17,17_18}.do  SUPERSEDED standalone grade-point passes;
                                that logic now lives inside the clean*.do files.

   Each step below is guarded by a 0/1 toggle. Default 0 = OFF (nothing runs on a
   bare `do master.do`); set a step's toggle to 1 to execute it.
   ---------------------------------------------------------------------------- */

clear all

do "./do/settings.do" //set global project settings
log using "$projdir/log/master.smcl", replace name(master) //start log file for the master do file and overwrite existing log file

*****************this block cleans the crscomp datasets*************************

/* clean17_18.do: clean raw crscomp17_18 (rename/recode/label + derive fgradept),
   save crscomp17_18_cln_che.dta */
local doclean17_18 = 0 // toggle for running the clean17_18.do
if `doclean17_18' == 1 {
  do "$projdir/do/build/prepare/clean17_18.do"
}

/* clean16_17.do: clean raw crscomp16_17 (rename/recode/label + derive fgradept),
   save crscomp16_17_cln_che.dta */
local doclean16_17 = 0 // toggle for running clean16_17.do
if `doclean16_17' == 1 {
  do "$projdir/do/build/prepare/clean16_17.do"
}

/* clean15_16.do: clean raw crscomp15_16 (rename/recode/label + derive fgradept),
   save crscomp15_16_cln_che.dta */
local doclean15_16 = 0 // toggle for running clean15_16.do
if `doclean15_16' == 1 {
  do "$projdir/do/build/prepare/clean15_16.do"
}

/* clean14_15.do: clean raw crscomp14_15 (rename/recode/label + derive fgradept),
   save crscomp14_15_cln_che.dta */
local doclean14_15 = 0 // toggle for running clean14_15.do
if `doclean14_15' == 1 {
  do "$projdir/do/build/prepare/clean14_15.do"
}

/* clean13_14.do: clean raw crscomp13_14 (rename/recode/label + derive fgradept),
   save crscomp13_14_cln_che.dta */
local doclean13_14 = 0 // toggle for running clean13_14.do
if `doclean13_14' == 1 {
  do "$projdir/do/build/prepare/clean13_14.do"
}

*****************this block computes UC A-G eligibility (DRAFT)*****************

/* ageligibility.do: compute UC A-G subject-requirement eligibility from a cleaned
   crscomp dataset that is ALREADY IN MEMORY (needs ssid, agcode, term, fgradept).
   WARNING: incomplete and will not run as-is — it has no use/save, expects a
   combined multi-year cohort dataset that no step currently builds, and contains
   known bugs. Kept OFF by default. See README.md sec. 6 before enabling. */
local doageligibility = 0 // toggle for running ageligibility.do (leave 0 until fixed)
if `doageligibility' == 1 {
  do "$projdir/do/build/prepare/ageligibility.do"
}


log close master // close the master log file
