version 15.0
cap log close _all

*****************************************************
* First created by Matthew Naven on July 20, 2018 *
*****************************************************

if c(machine_type)=="Macintosh (Intel 64-bit)" & c(username)=="Naven" {
	local home "/Users/Naven/Documents/research/ca_ed_lab/data"
}
if c(machine_type)=="Macintosh (Intel 64-bit)" & c(username)=="navenm" {
	local home "/Users/navenm/Documents/research/ca_ed_lab/data"
}
if c(hostname)=="sapper" {
	global S_ADO BASE;.;PERSONAL;PLUS;SITE;OLDPLACE
	local home "/secure/ca_ed_lab/data"
}
cd `home'

log using log_files/clean_nsc.smcl, replace

clear all
graph drop _all
set more off
set varabbrev off
set graphics off
set scheme s1color
set seed 1984


***************
* Description *
***************
/*

*/


**********
* Macros *
**********
#delimit ;
#delimit cr
macro list


timer on 1
*****************
* Begin Do File *
*****************
**** Import Data
import delimited restricted_access/raw/nsc/receive/501208st_T199621.201808071429_DA.csv ///
	, clear delimiter(comma) varnames(1) case(lower) stringcols(_all)
tempfile T199621
save `T199621'

import delimited restricted_access/raw/nsc/receive/501208st_T199622.201807090921_DA.csv ///
	, clear delimiter(comma) varnames(1) case(lower) stringcols(_all)
tempfile T199622
save `T199622'

import delimited restricted_access/raw/nsc/receive/501208st_T199623.201807090912_DA.csv ///
	, clear delimiter(comma) varnames(1) case(lower) stringcols(_all)
tempfile T199623
save `T199623'

import delimited restricted_access/raw/nsc/receive/501208st_T199624.201807090908_DA.csv ///
	, clear delimiter(comma) varnames(1) case(lower) stringcols(_all)
tempfile T199624
save `T199624'

import delimited restricted_access/raw/nsc/receive/501208st_T199625.201807090907_DA.csv ///
	, clear delimiter(comma) varnames(1) case(lower) stringcols(_all)
tempfile T199625
save `T199625'

import delimited restricted_access/raw/nsc/receive/501208st_T199626.201807090906_DA.csv ///
	, clear delimiter(comma) varnames(1) case(lower) stringcols(_all)
tempfile T199626
save `T199626'

import delimited restricted_access/raw/nsc/receive/501208st_T199627.201807090904_DA.csv ///
	, clear delimiter(comma) varnames(1) case(lower) stringcols(_all)
tempfile T199627
save `T199627'

import delimited restricted_access/raw/nsc/receive/501208st_T199628.201807090903_DA.csv ///
	, clear delimiter(comma) varnames(1) case(lower) stringcols(_all)
tempfile T199628
save `T199628'

import delimited restricted_access/raw/nsc/receive/501208st_T199629.201807090836_DA.csv ///
	, clear delimiter(comma) varnames(1) case(lower) stringcols(_all)
tempfile T199629
save `T199629'

import delimited restricted_access/raw/nsc/receive/501208st_T199630.201807090836_DA.csv ///
	, clear delimiter(comma) varnames(1) case(lower) stringcols(_all)
tempfile T199630
save `T199630'

import delimited restricted_access/raw/nsc/receive/501208st_T199631.201807090833_DA.csv ///
	, clear delimiter(comma) varnames(1) case(lower) stringcols(_all)
tempfile T199631
save `T199631'

import delimited restricted_access/raw/nsc/receive/501208st_T199632.201807090833_DA.csv ///
	, clear delimiter(comma) varnames(1) case(lower) stringcols(_all)
tempfile T199632
save `T199632'

import delimited restricted_access/raw/nsc/receive/501208st_T199633.201807090832_DA.csv ///
	, clear delimiter(comma) varnames(1) case(lower) stringcols(_all)
tempfile T199633
save `T199633'

import delimited restricted_access/raw/nsc/receive/501208st_T199634.201807090831_DA.csv ///
	, clear delimiter(comma) varnames(1) case(lower) stringcols(_all)
tempfile T199634
save `T199634'




**** Append Data
clear
append using `T199621'
append using `T199622'
append using `T199623'
append using `T199624'
append using `T199625'
append using `T199626'
append using `T199627'
append using `T199628'
append using `T199629'
append using `T199630'
append using `T199631'
append using `T199632'
append using `T199633'
append using `T199634'




**** Clean Data
label var youruniqueidentifier "The Social Security number as provided in your request file"

label var firstname "Student’s first name as provided in your request file"

label var middleinitial "Student’s middle initial as provided in your request file"

label var lastname "Student’s last name as provided in your request file"

label var namesuffix "Name suffix as provided in your request file (e.g., III, Jr, Sr)"

split requesterreturnfield, parse(.)
drop requesterreturnfield
drop requesterreturnfield1
drop requesterreturnfield3
drop requesterreturnfield5

rename requesterreturnfield2 state_student_id
label var state_student_id "State Student ID"

rename requesterreturnfield4 cdscode
label var cdscode "CDS Code"

rename requesterreturnfield6 local_student_id
replace local_student_id = subinstr(local_student_id, "_", "", .)
label var local_student_id "Local Student ID"

label var recordfoundyn "Detail report contains student’s college record"

gen search_date = date(searchdate, "YMD")
format search_date %td
label var search_date "Search date that you provided in your request file"
drop searchdate

label var collegecodebranch "OPE/FICE code of the college that the student attended"

label var collegename "Name of the college that the student attended"

label var collegestate "State in which the college that the student attended is located"

label def college_type 1 "Less than 2-year institution"
label def college_type 2 "2-year institution", add
label def college_type 4 "4-year or higher institution", add
gen college_type:college_type = 4 if year4year=="4"
replace college_type = 2 if year4year=="2"
replace college_type = 1 if year4year=="L"
label var college_type "Type of college that the student attended"
drop year4year

label def public 1 "Public institution"
label def public 0 "Private institution", add
gen public:public = 1 if publicprivate=="Public"
replace public = 0 if publicprivate=="Private"
label var public "Public or private institution"
drop publicprivate

gen enrollment_begin = date(enrollmentbegin, "YMD")
format enrollment_begin %td
label var enrollment_begin "Begin date for the student’s period of attendance"
drop enrollmentbegin

gen enrollment_end = date(enrollmentend, "YMD")
label var enrollment_end "End date for the student’s period of attendance"
format enrollment_end %td
drop enrollmentend

label def enrollment_status 1 "Less than half-time"
label def enrollment_status 2 "Half-time", add
label def enrollment_status 3 "Three-quarter time", add
label def enrollment_status 4 "Full-time", add
label def enrollment_status -1 "Leave of absence", add
label def enrollment_status -2 "Withdrawn", add
label def enrollment_status -3 "Deceased", add
gen enrollment_status:enrollment_status = 4 if enrollmentstatus=="F"
replace enrollment_status = 3 if enrollmentstatus=="Q"
replace enrollment_status = 2 if enrollmentstatus=="H"
replace enrollment_status = 1 if enrollmentstatus=="L"
replace enrollment_status = -1 if enrollmentstatus=="A"
replace enrollment_status = -2 if enrollmentstatus=="W"
replace enrollment_status = -3 if enrollmentstatus=="D"
label var enrollment_status "The last enrollment status reported for the student"
drop enrollmentstatus

label def class_level 1 "Freshman (Undergraduate)"
label def class_level 2 "Sophomore (Undergraduate)", add
label def class_level 3 "Junior (Undergraduate)", add
label def class_level 4 "Senior (Undergraduate)", add
label def class_level 5 "Certificate (Undergraduate)", add
label def class_level 6 "Associate's", add
label def class_level 7 "Bachelor's (Undergraduate)", add
label def class_level 8 "Post Baccalaureate Certificate", add
label def class_level 9 "Master’s (Graduate)", add
label def class_level 10 "First Professional (Graduate)", add
label def class_level 11 "Doctoral (Graduate)", add
label def class_level 12 "Postdoctorate (Graduate)", add
label def class_level -1 "Unspecified (Undergraduate)", add
label def class_level -2 "Unspecified (Graduate/Professional)", add
gen class_level:class_level = 1 if classlevel=="F"
replace class_level = 2 if classlevel=="S"
replace class_level = 3 if classlevel=="J"
replace class_level = 4 if classlevel=="R"
replace class_level = 5 if classlevel=="C"
replace class_level = -1 if classlevel=="N"
replace class_level = 7 if classlevel=="B"
replace class_level = 9 if classlevel=="M"
replace class_level = 11 if classlevel=="D"
replace class_level = 12 if classlevel=="P"
replace class_level = 10 if classlevel=="L"
replace class_level = -2 if classlevel=="G"
replace class_level = 6 if classlevel=="A"
replace class_level = 8 if classlevel=="T"
label var class_level "If available, the Class level associated with the student as provided by the reporting college"
drop classlevel

label var enrollmentmajor1 "If available, the major associated with the student’s enrollment record as provided by the reporting college"

label var enrollmentcip1 "If available, appropriate NCES CIP code for major 1"

label var enrollmentmajor2 "If available, the major associated with the student’s enrollment record as provided by the reporting college"

label var enrollmentcip2 "If available, appropriate NCES CIP code for major 2"

label def degree 1 "College reported the student as graduated"
label def degree 0 "College did NOT report the student as graduated", add
gen degree:degree = 1 if graduated=="Y"
replace degree = 0 if graduated=="N"
label var degree "Graduation status information available from the reporting college"
drop graduated

gen graduation_date = date(graduationdate, "YMD")
label var graduation_date "Date of student’s graduation or degree achievement as provided by reporting college"
format graduation_date %td
drop graduationdate

label var degreetitle "If available, the title of the degree the student received as provided by the reporting college"

label var degreemajor1 "If available, the major associated with the student’s degree as provided by the reporting college"

label var degreecip1 "If available, appropriate NCES CIP code for major 1"

label var degreemajor2 "If available, the major associated with the student’s degree as provided by the reporting college"

label var degreecip2 "If available, appropriate NCES CIP code for major 2"

label var degreemajor3 "If available, the major associated with the student’s degree as provided by the reporting college"

label var degreecip3 "If available, appropriate NCES CIP code for major 3"

label var degreemajor4 "If available, the major associated with the student’s degree as provided by the reporting college"

label var degreecip4 "If available, appropriate NCES CIP code for major 4"

destring collegesequence, replace
label var collegesequence "The sequential order of each school that the student attended"




foreach v of varlist * {
	count if !mi(`v')
	if r(N)==0 drop `v'
}

compress
sort state_student_id cdscode local_student_id enrollment_begin
save restricted_access/clean/nsc/nsc_2010_2017_clean.dta, replace




desc, full
codebook

egen ssid_tag = tag(state_student_id)
tab search_date if ssid_tag==1

/*tempfile nsc_clean
save `nsc_clean'


**** State Student ID
use `nsc_clean' if !mi(state_student_id), clear
compress
sort state_student_id enrollment_begin
save restricted_access/clean/nsc/nsc_2010_2017_ssid_clean.dta, replace


**** Local Student ID
use `nsc_clean' if mi(state_student_id), clear
compress
sort cdscode local_student_id enrollment_begin
save restricted_access/clean/nsc/nsc_2010_2017_lsid_clean.dta, replace*/




timer off 1
timer list
log close
translate log_files/clean_nsc.smcl log_files/clean_nsc.log, replace

if c(hostname)=="sapper" {
	exit, STATA clear
}
