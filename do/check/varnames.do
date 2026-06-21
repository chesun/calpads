********************************************************************************
************ Export a Description of CALPADS CRSCOMP Datasets to Excel**********
********************************************************************************

/* Deprecated, DO NOT EXECUTE */

/* cd  "/home/research/ca_ed_lab/data/restricted_access/raw/calpads/coursecomp"


use crscomp14_15, clear
describe, replace
export excel using "/home/research/ca_ed_lab/chesun/gsr/calpads/varnames14_15", firstrow(varlabels) replace

use crscomp13_14, clear
describe, replace
export excel using "/home/research/ca_ed_lab/chesun/gsr/calpads/varnames13_14", firstrow(varlabels) replace */
