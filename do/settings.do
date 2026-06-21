********************************************************************************
******* global settings for calpads crscomp project do files********************
********************************************************************************

/* IMPORTAMT: before running running the master do file, make sure the directories global macros
are set correctly in the settings.do file according to your current file structure */

/* creating global macro for the raw data directory */
global rawdtadir "/home/research/ca_ed_lab/data/restricted_access/raw/calpads/coursecomp"

/* creating global macro for the cleaned data directory */
global clndtadir "/home/research/ca_ed_lab/data/restricted_access/clean/calpads/dta"

/* creating global macro for the current project directory which stores do files. IMPORTANT
to set correctly so that the do files will run  */
global projdir "/home/research/ca_ed_lab/chesun/gsr/calpads"
