********************************************************************************
********* cleaning 16-17 calpads crscomp16_17.dta ******************************
********************************************************************************

/* Before running this do file, install egenmore package from ssc */
/* ssc install egenmore, replace */


clear
log using "$projdir/log/clean16_17.smcl", replace name(clean16_17) //start log file and overwrite existing log file for this do file

use "$rawdtadir/crscomp16_17.dta", clear
set more off



********************************************************************************
/* this first block renames and recodes variables and labels */
********************************************************************************


label var ssid "State Student ID"
replace ssid = strtrim(ssid) //remove leading and trailing blanks

rename academic_year year
label var year "Academic Year"
replace year = strtrim(year) //remove leading and trailing blanks
replace year = stritrim(year) //collapse all internal consecutive blanks to one blank

rename academic_term term
label var term "Academic Term"
replace term = strtrim(term) //remove leading and trailing blanks
replace term = stritrim(term) //collapse all internal consecutive blanks to one blank

rename county_district cdcode
label var cdcode "County District Code" // first 7 digits in the full CDS code that identifies the county and school district
replace cdcode = strtrim(cdcode) //remove leading and trailing blanks
replace cdcode = stritrim(cdcode) //collapse all internal consecutive blanks to one blank

rename school_id cdscode7
label var cdscode7 "Last 7 Digits of CDS School Code" //last 7 digits of full CDS school code that identifies the school
replace cdscode7 = strtrim(cdscode7) //remove leading and trailing blanks
replace cdscode7 = stritrim(cdscode7) //collapse all internal consecutive blanks to one blank

gen cdscode = cdcode + cdscode7 //generates the full 14 digit cds school code by concatenating cdcode and cdscode7
label var cdscode "14 Digit CDS School Code"

rename local_course_number lcrsnum
label var lcrsnum "Local Course Number"
replace lcrsnum = strtrim(lcrsnum) //remove leading and trailing blanks
replace lcrsnum = stritrim(lcrsnum) //collapse all internal consecutive blanks to one blank

rename local_course_name lcrsname
label var lcrsname "Local Course Name"
replace lcrsname = strtrim(lcrsname) //remove leading and trailing blanks
replace lcrsname = stritrim(lcrsname) //collapse all internal consecutive blanks to one blank

rename state_course_code scrsnum
label var scrsnum "State Course Code"
replace scrsnum = strtrim(scrsnum) //remove leading and trailing blanks
replace scrsnum = stritrim(scrsnum) //collapse all internal consecutive blanks to one blank

rename state_course_name scrsname
label var scrsname "State Course Name"
replace scrsname = strtrim(scrsname) //remove leading and trailing blanks
replace scrsname = stritrim(scrsname) //collapse all internal consecutive blanks to one blank

rename credit_attempted credatt
label var credatt "Credits Attempted"

rename credit_earned credearn
label var credearn "Credits Earned"

rename final_grade fgrade
label var fgrade "Final Letter Grade"
replace fgrade = strtrim(fgrade) //remove leading and trailing blanks
replace fgrade = stritrim(fgrade) //collapse all internal consecutive blanks to one blank

rename uc_csuapproved_course uccsuapptemp //temp var for generating binary var
replace uccsuapptemp = strtrim(uccsuapptemp) //remove leading and trailing blanks
gen byte uccsuapp =.  //generate dummy var
label var uccsuapp "UC/CSU Approved Course"
replace uccsuapp = 1 if uccsuapptemp == "Y"
replace uccsuapp = 0 if uccsuapptemp == "N"
drop uccsuapptemp

rename independent_study indstudytemp //temp var
replace indstudytemp = strtrim(indstudytemp) //remove leading and trailing blanks
gen byte indstudy =. //generate binary var
label var indstudy "Independent Study"
replace indstudy = 1 if indstudytemp == "Y"
replace indstudy = 0 if indstudytemp == "N"
drop indstudytemp

rename distance_learning distlearntemp //temp var
replace distlearntemp = strtrim(distlearntemp) //remove leading and trailing blanks
gen byte distlearn =. //generate binary var
label var distlearn "Distance Learning"
replace distlearn = 1 if distlearntemp == "Y"
replace distlearn = 0 if distlearntemp == "N"
drop distlearntemp

rename cte_tech_prep ctetemp //temp var
replace ctetemp = strtrim(ctetemp) //remove leading and trailing blanks
gen byte cte =. //binary var
label var cte "Career Technical Education Prep Course"
replace cte = 1 if ctetemp == "Y"
replace cte = 0 if ctetemp == "N"
drop ctetemp

rename a_g_course_req_code agcode
label var agcode "A to G Course Code"
replace agcode = strtrim(agcode)
replace agcode = stritrim(agcode)

rename a_g_course_req_name agname
label var agname "A to G Course Name"
replace agname = strtrim(agname)
replace agname = stritrim(agname)

rename honors honortemp //temp var
replace honortemp = strtrim(honortemp)
gen byte honor =. //generate dummy var
label var honor "Honors Course"
replace honor = 1 if honortemp == "Y"
replace honor = 0 if honortemp == "N"
drop honortemp




********************************************************************************
 /* this second block calculate final course number grades  */
********************************************************************************


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

label data "CALPADS crscomp16_17 cleaned data with calculated final number grades" //label the dataset


compress //compress dataset to save space

save "$clndtadir/crscomp16_17_cln_che", replace // save cleaned dataset to clean data directory

log close clean16_17 //close log file
