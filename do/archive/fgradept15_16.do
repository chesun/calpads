********************************************************************************
******* calculate final course grades for calpads crscomp15_16_cln_che_17_cln_che.dta *****
********************************************************************************

log using "$projdir/log/fgradept15_16.smcl", replace name(fgradept15_16) //start log file for this do file and overwrite existing log file

/* Before running this do file, install egenmore package from ssc */

use "$clndtadir/crscomp15_16_cln_che.dta", clear // use the cleaned dataset
set more off

gen fgradepttemp = ustrtrim(fgrade) //generate temp var for fgradept and remove leading and trailing unicode blanks
replace fgradepttemp = upper(fgradepttemp) // convert to upper case

egen aux = sieve(fgradepttemp), char(-+ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.) //generate a temp var aux that only keeps the specified characters from the fgradepttemp var
replace fgradepttemp = aux
drop aux //drop the temp var aux

gen fgradept =. // generate the final grade point variable
label var fgradept "Course Final Number Grade"

/* this following section calculates final course number grades using algorithm by Alexandria Hurtt */

replace fgradept = 4.0 if fgradepttemp == "A+"
replace fgradept = 4.0 if fgradepttemp == "A"
replace fgradept = 3.7 if inlist(fgradepttemp, "A-", "-A") // here inlist() is a shorthand of saying if fgradetemp == "A-" | fgradepttemp == "-A"
replace fgradept = 3.3 if fgradepttemp == "B+"
replace fgradept = 3.0 if inlist(fgradepttemp, "B", "BX")
replace fgradept = 2.7 if inlist(fgradepttemp, "B-", "-B")
replace fgradept = 2.3 if fgradepttemp == "C+"
replace fgradept = 2.0 if inlist(fgradepttemp, "C", "CC")
replace fgradept = 1.7 if inlist(fgradepttemp, "C-", "-C", "CX-")
replace fgradept = 1.3 if fgradepttemp == "D+"
replace fgradept = 1.0 if fgradepttemp == "D"
replace fgradept = 0.7 if inlist(fgradepttemp, "D-", "-D")
replace fgradept = 0.0 if inlist(fgradepttemp, "F", "F+", "F-")

replace fgradept = 4.0 if inlist(fgradepttemp, "100", "99", "98", "97", "96", "95", "94", "93")
replace fgradept = 3.7 if inlist(fgradepttemp, "92", "91", "90")
replace fgradept = 3.3 if inlist(fgradepttemp, "89", "88", "87")
replace fgradept = 3.0 if inlist(fgradepttemp, "86", "85", "84", "83")
replace fgradept = 2.7 if inlist(fgradepttemp, "82", "81", "80")
replace fgradept = 2.3 if inlist(fgradepttemp, "79", "78", "77")
replace fgradept = 2.0 if inlist(fgradepttemp, "76", "75", "74", "73")
replace fgradept = 1.7 if inlist(fgradepttemp, "72", "71", "70")
replace fgradept = 1.3 if inlist(fgradepttemp, "69", "68", "67")
replace fgradept = 1.0 if inlist(fgradepttemp, "66", "65", "64", "63")
replace fgradept = 0.7 if inlist(fgradepttemp, "62", "61", "60")
replace fgradept = 0.0 if inlist(fgradepttemp, "59", "58", "57", "56", "55", "54", "53")
replace fgradept = 0.0 if inlist(fgradepttemp, "52", "51", "50", "49", "48", "47", "46", "45")

replace fgradept = 4.0 if inlist(fgradepttemp, "4", "4.0", "4.5", "5")
replace fgradept = 3.9 if fgradepttemp == "3.9"
replace fgradept = 3.8 if fgradepttemp == "3.8"
replace fgradept = 3.7 if fgradepttemp == "3.7"
replace fgradept = 3.6 if fgradepttemp == "3.6"
replace fgradept = 3.5 if fgradepttemp == "3.5"
replace fgradept = 3.4 if fgradepttemp == "3.4"
replace fgradept = 3.3 if fgradepttemp == "3.3"
replace fgradept = 3.2 if fgradepttemp == "3.2"
replace fgradept = 3.1 if fgradepttemp == "3.1"
replace fgradept = 3.0 if inlist(fgradepttemp, "3", "3.0")

replace fgradept = 2.9 if fgradepttemp == "2.9"
replace fgradept = 2.8 if fgradepttemp == "2.8"
replace fgradept = 2.7 if fgradepttemp == "2.7"
replace fgradept = 2.6 if fgradepttemp == "2.6"
replace fgradept = 2.5 if fgradepttemp == "2.5"
replace fgradept = 2.4 if fgradepttemp == "2.4"
replace fgradept = 2.3 if fgradepttemp == "2.3"
replace fgradept = 2.2 if fgradepttemp == "2.2"
replace fgradept = 2.1 if fgradepttemp == "2.1"
replace fgradept = 2.0 if inlist(fgradepttemp, "2", "2.", "2.0")

replace fgradept = 1.9 if fgradepttemp == "1.9"
replace fgradept = 1.8 if fgradepttemp == "1.8"
replace fgradept = 1.7 if fgradepttemp == "1.7"
replace fgradept = 1.6 if fgradepttemp == "1.6"
replace fgradept = 1.5 if fgradepttemp == "1.5"
replace fgradept = 1.4 if fgradepttemp == "1.4"
replace fgradept = 1.3 if fgradepttemp == "1.3"
replace fgradept = 1.2 if fgradepttemp == "1.2"
replace fgradept = 1.1 if fgradepttemp == "1.1"
replace fgradept = 1.0 if inlist(fgradepttemp, "1.0", "1.", "1")

replace fgradept = 0.9 if fgradepttemp == ".9"
replace fgradept = 0.8 if inlist(fgradepttemp, "0.8", ".8")
replace fgradept = 0.7 if fgradepttemp == ".7"
replace fgradept = 0.6 if fgradepttemp == ".6"
replace fgradept = 0.5 if inlist(fgradepttemp, ".5", "0.5")
replace fgradept  = 0.4 if fgradepttemp == ".4"
replace fgradept = 0.3 if fgradepttemp == ".3"
replace fgradept = 0.2 if fgradepttemp == ".2"
replace fgradept = 0.1 if fgradepttemp == ".1"
replace fgradept = 0.0 if inlist(fgradepttemp, "0.0", "0.", "0", ".0", "0", "00")

replace fgradept = .a if inlist(fgradepttemp, "P", "PAS", "S", "S+")
replace fgradept = .b if inlist(fgradepttemp, "NP", "N", "U", "S-")
replace fgradept = .c if inlist(fgradepttemp, "M", "NA")
replace fgradept = .c if fgradepttemp=="." // extended value label if fgradepttemp only has a period
replace fgradept = .c if missing(fgradepttemp) // extended value label if missing
replace fgradept = .d if inlist(fgradepttemp, "I", "IN", "INC")
replace fgradept = .e if inlist(fgradepttemp, "PR", "IP")
replace fgradept = .f if inlist(fgradepttemp, "W", "WF", "FW", "WP")
replace fgradept = .g if fgradepttemp == "CR"
replace fgradept = .h if inlist(fgradepttemp, "NC", "NCR", "NG")
replace fgradept = .i if fgradepttemp == "NM"

/* define value labels for extended missing value codes */
label define fgradeptlabel ///
.a "Pass" ///
.b "Not Pass" ///
.c "Missing" ///
.d "Incomplete" ///
.e "Work in Progress" ///
.f "Withdrawal" ///
.g "Credit" ///
.h "No Credit/Not Graded" ///
.i "No Mark"

label values fgradept fgradeptlabel //assign the value lable fgradeptlabel to the fgradept var

drop fgradepttemp

label data "CALPADS crscomp15_16 cleaned data with calculated final number grades"

compress //compress data to save space

save "$clndtadir/crscomp15_16_cln_fgpt_che", replace // save dataset to clean data directory

log close fgradept15_16 //close current log file
